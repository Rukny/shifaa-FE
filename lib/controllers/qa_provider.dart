

import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/controllers/nav_provider.dart';
import 'package:shifaa/models/question.dart';
import 'package:shifaa/models/speciality.dart';

class QaProvider extends ChangeNotifier{

  List<Specialty>? specialities;
  Specialty? selectedSpecialty;
  List<Question>? questions;
  List<Question>? filteredQuestions;
final TextEditingController textEditingController=TextEditingController();

  String selectedSort='all';
  handleSearch(String p0, BuildContext context) {
    selectedSpecialty=specialities!.firstWhere((element) => element.getName(context)==p0);
    HandleQuestions();
  }

  QaProvider(BuildContext ctx){

    init();
  }
  init()async{
    log('init centersDetailsprovider');
    specialities=await Specialty.getSpecialities();

    questions=await Question.getQuestions();
    filteredQuestions=List.from(questions!);
      notifyListeners();


  }
  HandleQuestions(){

    filteredQuestions?.clear();

    if(selectedSpecialty!=null)
      {
        log('selectedSpeciality is not null!');
        filteredQuestions=questions?.where((element) => element.specialty==selectedSpecialty!).toList();
      }
    else     filteredQuestions=List.from(questions!);
    switch(selectedSort){

      case 'recent':


        filteredQuestions?.sort((a, b) =>a.createDate.isBefore(b.createDate)?1:-1);
        break;
      case 'answerNum':
        filteredQuestions?.sort((a, b) => a.answers!.length>b.answers!.length?0:1);
       break;
      default:
        {

        }
    }
    notifyListeners();
  }

  setSort(String s) {
    selectedSort=s;
    HandleQuestions();

  }

  clearSpeciality() {
    selectedSpecialty=null;
    textEditingController.clear();
    HandleQuestions();
  }
}