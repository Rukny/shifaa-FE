// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/models/speciality.dart';
import 'dart:convert';

import 'package:shifaa/models/user.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'package:shifaa/utils/restService.dart';

import 'answer.dart';
import 'doctor.dart';

class Question {
  final DateTime createDate;
  final int id;
  final String title;
  final String desc;
  final int status;
  final Specialty specialty;
        List<Answer>? answers;
  final List<Link>? links;

  final Patient patient;
  final List<SubSpecialty> subDisciplines;

  Question({
    required this.createDate,
    required this.id,
    required this.title,
    required this.desc,
    required this.status,
    required this.specialty,
    this.links,

    required this.answers,
    required this.patient,
    required this.subDisciplines,
  });

  factory Question.fromRawJson(String str) => Question.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    createDate: DateTime.parse((json["publicationDate"] as String).replaceAll('\t\r\n','')),
    id: json["id"],
    title: json["title"],
    desc: json["desc"],
    status: json["status"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),

    specialty: Specialty.fromJson(json["specialty"]),
    answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
    patient: Patient.fromJson(json["patient"]),
    subDisciplines: List<SubSpecialty>.from(json["subDisciplines"].map((x) => SubSpecialty.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "createDate": createDate,
    "id": id,
    "title": title,
    "desc": desc,
    "status": status,
    "specialty": specialty.toJson(),
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),

    "patient": patient.toJson(),
    "subDisciplines": List<dynamic>.from(subDisciplines.map((x) => x.toJson())),
  };

  getStringDate(BuildContext context){
    return DateFormat('dd-MMM hh:mm a',context.locale.languageCode).format(createDate,);
  }
  static getQuestions()async{
    var res= await RestApiService.get(ApiPaths.getQuestions);
    if(res.statusCode==200){
      var decoded=jsonDecode(res.body);
      var list = (decoded as List).map((e) => Question.fromJson(e)).toList();
      return list;
    }
    else if (res.statusCode==204)
      return [];
    else throw Exception('getQuestions error ${res.statusCode} ${res.body}');
  }
  Future<List<Answer>?>   getAnswers()async{
    var res= await RestApiService.get(ApiPaths.getAnswers(id));
    if(res.statusCode==200){
      var decoded=jsonDecode(res.body);
      var list = (decoded as List).map((e) => Answer.fromJson(e)).toList();
      answers=List.from(list);
      return list;
    }
    else if (res.statusCode==204)
      return [];
    else throw Exception('getAnswers error ${res.statusCode} ${res.body}');
  }
}

class Link {
  final String? createDate;
  final int? id;
  final String? name;
  final String? link;
  final DateTime? publicationDate;
  final int? questionId;

  Link({
    this.createDate,
    this.id,
    this.name,
    this.link,
    this.publicationDate,
    this.questionId,
  });

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    createDate: json["createDate"],
    id: json["id"],
    name: json["name"],
    link: json["link"],
    publicationDate: json["publicationDate"] == null ? null : DateTime.parse(json["publicationDate"]),
    questionId: json["questionId"],
  );

  Map<String, dynamic> toJson() => {
    "createDate": createDate,
    "id": id,
    "name": name,
    "link": link,
    "publicationDate": publicationDate?.toIso8601String(),
    "questionId": questionId,
  };
}









