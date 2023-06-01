
import 'dart:developer';


import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/models/user.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'package:shifaa/utils/local_storage.dart';
import 'package:shifaa/utils/restService.dart';

class UserProvider extends ChangeNotifier{

  Patient? patient;
  Doctor? doctor;


  UserProvider(BuildContext context){
    log('userProvider init');
    init(context);
  }


  doLogin(String email, String password)async{
    var pat=await  Patient.login(email, password);
  log('doLogin res ${pat}');

    if(pat is Patient){
      await setPatient(pat);
      return patient;

    }
    else if( pat is Doctor){

      setDoctor(pat);
      return doctor;
    }

    else if (pat is String) {
      log('patientlogin else ${pat}');
      return pat;
    }
  }

  getCurrentUser(){

    log('getCurrentUser is ${patient} ${doctor}');
    if(patient!=null) {
      return patient;
    } else if(doctor!=null) {
      return doctor;
    } else {
      null;
    }

  }

  logOut()async {
    log('logout');
    doctor=patient=null;
   return await LocalStorage.clearStorage();
  }

  Future<void> setPatient(Patient pat) async {
    patient=pat;
   await LocalStorage.storeValue('patientId', pat.id.toString());
   await LocalStorage.storeValue('patient', pat.toRawJson());
   await LocalStorage.storeValue('userId', pat.user.id.toString());
    await User.updateFcmToken();
    notifyListeners();
    log('setPatient success');
    FirebaseCrashlytics.instance.setUserIdentifier("user is patient user id ${pat.id} ${pat.user.nameEn}");

  }
  setDoctor(Doctor doc) async{

    doctor=doc;
    await LocalStorage.storeValue('doctorId', doctor!.id.toString());
    await LocalStorage.storeValue('doctor', doc.toRawJson());
    await LocalStorage.storeValue('userId', doc.user.id.toString());
    await User.updateFcmToken();
    FirebaseCrashlytics.instance.setUserIdentifier("user is patient user id ${doc.id} ${doc.user.nameEn}");

    notifyListeners();
  }

    init(BuildContext context) async{

  try {
    var dId=  await LocalStorage.retrieveValue('doctorId');
    var pId=  await LocalStorage.retrieveValue('patientId');
    if(pId!=null) {
      log('user is patient');
     await FirebaseMessaging.instance.subscribeToTopic('patients');
     await FirebaseMessaging.instance.unsubscribeFromTopic('doctors');

      patient=await  Patient.getPatient();
      await LocalStorage.storeValue('userId', patient!.user.id.toString());

    }
    if(dId!=null) {
      log('user is doctor');
      await FirebaseMessaging.instance.subscribeToTopic('doctors');
      await FirebaseMessaging.instance.unsubscribeFromTopic('patients');
      doctor=await Doctor.getDoctor(dId);
      await LocalStorage.storeValue('doctorId', doctor!.id.toString());
      await LocalStorage.storeValue('userId', doctor!.user.id.toString());
    }

   await User.updateFcmToken();

      notifyListeners();
  } on Exception catch (e) {
    log('caught excetion in UserPrivder init function \n ${e.toString()}');
    log('clearing storage and restarting the app');
    await LocalStorage.clearStorage();
    Navigator.of(context).pushReplacementNamed('login');
  }
  }




}