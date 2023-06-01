// To parse this JSON data, do
//
//     final centre = centreFromJson(jsonString);

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'dart:convert';

import 'package:shifaa/utils/restService.dart';

class Centre {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descAr;
  final String descEn;
  final String phone;
  final String email;
  final String addressAr;
  final String addressEn;
  final String map;
  final int status;
  final int cityId;

  Centre({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descAr,
    required this.descEn,
    required this.phone,
    required this.email,
    required this.addressAr,
    required this.addressEn,
    required this.map,
    required this.status,
    required this.cityId
  });

  factory Centre.fromRawJson(String str) => Centre.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Centre.fromJson(Map<String, dynamic> json) => Centre(
    id: json["id"],
    nameAr: json["nameAr"],
    nameEn: json["nameEn"],
    descAr: json["descAr"],
    descEn: json["descEn"],
    phone: json["phone"],
    email: json["email"],
    addressAr: json["addressAr"],
    addressEn: json["addressEn"],
    map: json["map"],
    status: json["status"],
    cityId: json['city']['id']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nameAr": nameAr,
    "nameEn": nameEn,
    "descAr": descAr,
    "descEn": descEn,
    "phone": phone,
    "email": email,
    "addressAr": addressAr,
    "addressEn": addressEn,
    "map": map,
    "status": status,
    "cityId":cityId
  };
  getName(BuildContext ctx){
    try {
      print(ctx.deviceLocale.languageCode);
      return    ctx.locale.languageCode=='en'? nameEn : nameAr;
    } on Exception catch (e) {
      log('caught e ${e.toString()}');
    }
  }
  getAddress(BuildContext ctx){
    try {
      print(ctx.deviceLocale.languageCode);
      return    ctx.locale.languageCode=='en'? addressEn : addressAr;
    } on Exception catch (e) {
      log('caught e ${e.toString()}');
    }
  }

  getDesc(BuildContext ctx){
    try {
      print(ctx.deviceLocale.languageCode);
      return    ctx.locale.languageCode=='en'? descEn : descAr;
    } on Exception catch (e) {
      log('caught e ${e.toString()}');
    }
  }


  static getAvailableCentres()async{
    log('GetAvailableCentres');
    
    var res= await RestApiService.get(ApiPaths.availableMedicalCentres);
    if(res.statusCode==200){
      var decoded=jsonDecode(res.body);
      return (decoded as List).map((e) => Centre.fromJson(e)).toList();
    }
    else if(res.statusCode==204) {
      return [];
    } else {
      throw Exception('getAvailableCentres else exception  ${res.statusCode} ${res.body}');
    }
  }
}
