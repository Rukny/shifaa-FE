




import 'dart:convert';

import 'doctor.dart';

class Answer {
  final DateTime createDate;
  final int id;
  final String title;
  final String desc;
  final String publicationDate;
  final dynamic likes;
  final Doctor? doctor;

  Answer({
    required this.createDate,
    required this.id,
    required this.title,
    required this.desc,
    required this.publicationDate,
    required this.likes,
    required this.doctor,
  });

  factory Answer.fromRawJson(String str) => Answer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    createDate: DateTime.parse((json["publicationDate"] as String).replaceAll('\t\r\n','')),
    id: json["id"],
    title: json["title"],
    desc: json["desc"],
    publicationDate: json["publicationDate"],
    likes: json["likesCount"] ?? 0,
    doctor: Doctor.fromJson(json["doctor"]),
  );

  Map<String, dynamic> toJson() => {
    "createDate": createDate,
    "id": id,
    "title": title,
    "desc": desc,
    "publicationDate": publicationDate,
    "likes": likes,
    "doctor": doctor?.toJson(),
  };
}