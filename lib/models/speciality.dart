import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'package:shifaa/utils/restService.dart';

class Specialty extends Equatable{
  final int id;
  final String nameAr;
  final String nameEn;
  final String descAr;
  final String descEn;
  final int status;
  final List<SubSpecialty>? subDisciplines;
  Specialty({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descAr,
    required this.descEn,
    required this.status,
    required this.subDisciplines,
  });

  factory Specialty.fromRawJson(String str) => Specialty.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Specialty.fromJson(Map<String, dynamic> json) => Specialty(
    id: json["id"],
    nameAr: json["nameAr"],
    nameEn: json["nameEn"],
    descAr: json["descAr"],
    descEn: json["descEn"],
    status: json["status"],
    subDisciplines: json["subDisciplines"] == null ? [] : List<SubSpecialty>.from(json["subDisciplines"]!.map((x) => SubSpecialty.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nameAr": nameAr,
    "nameEn": nameEn,
    "descAr": descAr,
    "descEn": descEn,
    "status": status,
    "subDisciplines": subDisciplines == null ? [] : List<dynamic>.from(subDisciplines!.map((x) => x.toJson())),

  };

  getName(BuildContext context){
    return context.locale.languageCode=="en"?nameEn:nameAr;
  }
  getDesc(BuildContext context) {
    return context.locale.languageCode=="en"?descEn:descAr;
  }
  
 static  Future<List<Specialty>> getSpecialities()async{
    var res=await RestApiService.get(ApiPaths.getSpecialities);

    if(res.statusCode==200){
      var decoded=jsonDecode(res.body);
      return (decoded as List).map((e) => Specialty.fromJson(e)).toList();

    }
    if(res.statusCode==204){
      return [];

    }
    else throw Exception("getSpecialties exception ${res.statusCode} ${res.body}");
  }
  static getSpecialitiesWithSubs() async {

    var res=await RestApiService.get(ApiPaths.getSpecialitiesWithSubs);

    if(res.statusCode==200){
      var decoded=jsonDecode(res.body);
      return (decoded as List).map((e) => Specialty.fromJson(e)).toList();

    }
    if(res.statusCode==204){
      return [];

    }
    else throw Exception("getSpecialitiesWithSubs exception ${res.statusCode} ${res.body}");
  }

  @override
  List<Object?> get props => [id];


}

class SubSpecialty extends Equatable{
  final int id;
  final String nameAr;
  final String nameEn;
  final String descAr;
  final String descEn;

  const SubSpecialty({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descAr,
    required this.descEn,

  });

  factory SubSpecialty.fromRawJson(String str) => SubSpecialty.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubSpecialty.fromJson(Map<String, dynamic> json) => SubSpecialty(
    id: json["id"],
    nameAr: json["nameAr"],
    nameEn: json["nameEn"],
    descAr: json["descAr"],
    descEn: json["descEn"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nameAr": nameAr,
    "nameEn": nameEn,
    "descAr": descAr,
    "descEn": descEn
  };

  getName(BuildContext context){
    return context.locale.languageCode=="en"?nameEn:nameAr;
  }
  getDesc(BuildContext context) {
    return context.locale.languageCode=="en"?descEn:descAr;
  }

  static getSubSpecialty()async{
    ///todo update
    var res=await RestApiService.get(ApiPaths.getSpecialities);

    if(res.statusCode==200){
      var decoded=jsonDecode(res.body);
      return (decoded as List).map((e) => Specialty.fromJson(e)).toList();

    }
    if(res.statusCode==204){
      return [];

    }
    else throw Exception("getSpecialties exception ${res.statusCode} ${res.body}");
  }

  @override

  List<Object?> get props => [id];
}
