

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifaa/models/patient.dart';

class RegisterProvider extends ChangeNotifier{
  final formKey=GlobalKey<FormBuilderState>();

  final btnController=RoundedLoadingButtonController();

    submit()async {
      final fcmToken = await FirebaseMessaging.instance.getToken();
    Map fields=formKey.currentState!.value;

    Map<String,dynamic> body={
      "name":"${fields['firstName']} ${fields['lastName']}",
      "birthday": "${fields['birthdate'].toString()}",
      "gender": fields['gender'],
      "email": fields['email'],
      "phone":fields['password'],
      "password":fields['password'],
      "fcm_token":fcmToken

    };
    log('register body is ${body}');
    var res= await Patient.register(body);

    log('submit res ${res}');
    return res;

  }

}