

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shifaa/models/centre.dart';
import 'package:shifaa/models/city.dart';
import 'package:shifaa/views/patient_views/centres/widgets/center_card.dart';

class CentersProvider extends ChangeNotifier{
  List<City>? cities ;
  List<Centre>? centres;
  List<Widget> cards=[];
  City? selectedCity;
  final TextEditingController textEditingController=TextEditingController();

  CentersProvider(){

    initCities();
    initCentres();
  }

  initCities()async{
  cities=await  City.getCities();
  log('cities ${cities!.length}');
  notifyListeners();
  }
  initCentres()async{
    centres=await  Centre.getAvailableCentres();
    log('centres ${centres!.length}');
    handleCentres();
  }

  handleCentres() {

    if(centres!=null) {
      cards=   centres!.map((e) => CenterCard(centre: e,key: Key(e.id.toString()  ),)).toList();
    } if(selectedCity!=null && centres!=null) {
      log('handleCentres, filtering by city');
      cards= centres!.where((element) => element.cityId==selectedCity!.id).map((e) => CenterCard(centre: e,key: Key(e.id.toString()  ),)).toList();
    }
  log('centers count ${cards.length}');
    notifyListeners();
  }

  handleSearch(String p0,ctx)  {
    selectedCity=cities?.firstWhere((element) => element.getName(ctx)==p0);
    log('handleSearch ${selectedCity}');
    handleCentres();
  }

  void clearSearch() {
    selectedCity=null;
    textEditingController.clear();
    handleCentres();
  }
}