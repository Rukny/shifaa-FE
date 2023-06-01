// To parse this JSON data, do
//
//     final city = cityFromJson(jsonString);

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'dart:convert';

import 'package:shifaa/utils/restService.dart';

class City {
  final int id;
  final String nameAr;
  final String nameEn;
  final int status;

  City({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.status,
  });

  factory City.fromRawJson(String str) => City.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    nameAr: json["nameAr"],
    nameEn: json["nameEn"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nameAr": nameAr,
    "nameEn": nameEn,
    "status": status,
  };

  getName(BuildContext ctx){
    try {
      print(ctx.deviceLocale.languageCode);
  return    ctx.locale.languageCode=='en'? nameEn : nameAr;
    } on Exception catch (e) {
      log('caught e ${e.toString()}');
    }
  }

  static getCities()async{
    log("Get Cities");
    var res= await RestApiService.get(ApiPaths.availableCity);
    if(res.statusCode==200){
      var decoded=jsonDecode(res.body);
      var list= (decoded as List).map((e)=> City.fromJson(e)).toList();
      return list;
    }
    else if(res.statusCode==204){
      log("no Data response, ${res.statusCode} \n ${res.body}");
    }
    else {
      throw Exception("error fetching Cities ${res.statusCode} ${res.body}");
    }
  }

}
