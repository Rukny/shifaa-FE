

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shifaa/models/centre.dart';
import 'package:shifaa/models/doctor.dart';
import 'dart:collection';

import 'package:shifaa/models/speciality.dart';
class CenterDetailsProvider extends ChangeNotifier{
  final Centre centre;
  List<Doctor>? allDoctors;
  List<Doctor>? filteredDoctors;
  List<Specialty>? specialities;
  var selectedSpecialty;

 final TextEditingController textEditingController=TextEditingController();

  handleSearch(String p0, BuildContext context) {
    selectedSpecialty=specialities!.firstWhere((element) => element.getName(context)==p0);
   handleDoctors();
  }

  CenterDetailsProvider({required this.centre}){
    init();
  }
  init()async{
    log('init centersDetailsprovider');
    specialities=await Specialty.getSpecialities();
    allDoctors= await Doctor.getCentreDoctors(centre.id);
    handleDoctors();


  }
  handleDoctors() {
    log('handleDoctors alldoctors ${allDoctors?.length} filtered ${filteredDoctors?.length}');

    if(allDoctors!=null){
      filteredDoctors?.clear();
      filteredDoctors=List.of(allDoctors!);
    }
     if(allDoctors!=null && selectedSpecialty!=null){
      filteredDoctors?.clear();
      log('selected specialty ${selectedSpecialty}');
      filteredDoctors=List.from(allDoctors!.where((element) => element.specialty==selectedSpecialty).toList() ?? []);

    }
    notifyListeners();
  }

  void clearSearch() {
    textEditingController.clear();
    selectedSpecialty=null;
    handleDoctors();
  }


}