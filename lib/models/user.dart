import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'package:shifaa/utils/local_storage.dart';
import 'package:shifaa/utils/restService.dart';

class User {
  final int id;
  final String nameAr;
  final String nameEn;
  final String birthday;
  final String gender;
  final String email;

  final String phone;
  final String? photo;

  User({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.birthday,
    required this.gender,
    required this.email,

    required this.phone,
    required this.photo,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    nameAr: json["nameAr"],
    nameEn: json["nameEn"],
    birthday: json["birthday"],
    gender: json["gender"],
    email: json["email"],

    phone: json["phone"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nameAr": nameAr,
    "nameEn": nameEn,
    "birthday": birthday,
    "gender": gender,
    "email": email,


    "phone": phone,
    "photo": photo,
  };

  getName(BuildContext context) {
  return  context.locale.languageCode =="en"? nameEn:nameAr;
  }

  static   updateFcmToken() async{
    log('updating FCM token');
    var userId=await LocalStorage.retrieveValue('userId');
    var token=await FirebaseMessaging.instance.getToken();
    if(userId==null)
      throw('updateFcmToken user id is null');
  return  await RestApiService.post(ApiPaths.updateUserFcm,{'userId':userId,'token':token});
  }




}
