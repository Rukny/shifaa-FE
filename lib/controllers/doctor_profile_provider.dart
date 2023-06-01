
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/models/speciality.dart';
import 'package:shifaa/utils/local_storage.dart';

class DoctorProfileProvider extends ChangeNotifier{


  final formKey = GlobalKey<FormBuilderState>();
  Doctor?  doctor;

  List<Specialty> specialities=[];
  List<SubSpecialty> subSpecialities=[];
  Specialty? selectedSpecialty;

  bool isEditing=false;

  final   RoundedLoadingButtonController btnController=RoundedLoadingButtonController();
  DoctorProfileProvider() {
  init();
  }

  init() async {
  var did=await LocalStorage.retrieveValue('doctorId');
  doctor=await  Doctor.getDoctor(did!);
  specialities=await Specialty.getSpecialitiesWithSubs();

  notifyListeners();
  }

  void toggleEdit() {
  isEditing=!isEditing;
  notifyListeners();
  }

  submitEdit(BuildContext context)async {
  var body=Map.from(formKey.currentState!.value);
 // var uid=context.read<UserProvider>().patient!.user.id;
  log('body is ${body}');
  body['birthday']=formKey.currentState!.value['birthday'].toString();
//  body['userId']=uid;
  body['name']="${formKey.currentState!.value['firstName']} ${formKey.currentState!.value['lastName']}";
  body['fcm_token']=await FirebaseMessaging.instance.getToken();
  body.forEach((key, value) => print( "$key ${value.runtimeType}"));
  var res= await Patient.patchUser(body);
  if(res){
 // context.read<UserProvider>().init(context);
  btnController.success();
  isEditing=false;
  notifyListeners();
  return true;
  }
  else return res;

  }

 Specialty? getSubSpecialties() {
if(isEditing && selectedSpecialty!=null) {
  return selectedSpecialty!;
}
 return doctor?.specialty;

  }

  setSelectedSpecialty(Specialty? value) {
    selectedSpecialty=value;

    notifyListeners();
  }




}