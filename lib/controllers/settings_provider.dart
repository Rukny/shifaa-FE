

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/utils/local_storage.dart';

class SettingsProvider extends ChangeNotifier{

  bool notificationsEnabled=true;

  SettingsProvider(){
    init();
  }

  init() async{
  var notifEnabled=await LocalStorage.retrieveValue('subscribed');
  log('subscribed is ${notifEnabled}');
  if(notifEnabled!=null){

    notifEnabled=="true"?notificationsEnabled=true:notificationsEnabled=false;
    notifyListeners();
  }
 

  }
  toggleNotifications(bool opt,BuildContext context)async{
    showDialog(context: context,barrierDismissible: false, builder: (context) => AppConstants.loadingDialogWidget(),);

    if(opt) {
      log('subscribe to topic');
      await FirebaseMessaging.instance.subscribeToTopic('patients');
      await LocalStorage.storeValue('subscribed', 'true');
      notificationsEnabled=opt;


    } else {
      log('unsunscribe from topic');
      await FirebaseMessaging.instance.unsubscribeFromTopic('patients');
      notificationsEnabled=false;
      await LocalStorage.storeValue('subscribed', 'false');

    }
    Navigator.pop(context);
    notifyListeners();
  }

}