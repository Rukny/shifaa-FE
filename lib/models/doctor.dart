// To parse this JSON data, do
//
//     final doctor = doctorFromJson(jsonString);

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:shifaa/models/speciality.dart';
import 'package:shifaa/models/user.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'package:shifaa/utils/local_storage.dart';
import 'dart:convert';

import 'package:shifaa/utils/restService.dart';

import 'booked_day.dart';
import 'centre.dart';
import 'medical_center.dart';

class Doctor {
  final int id;
  final int slotDuration;
  final String infoAr;
  final String infoEn;
  final int status;
  User user;
  final Specialty specialty;
  final String? centreId;
  bool isFavorite;
  final List<DaysPref> daysPreference;
  final MedicalCenter? medicalCenter;
  final List<DaysPref>? daysPref;
  final List<BookedDay>? bookedDays;
  final List<BookedDaySlot>? bookedDaySlots;


  Doctor(
      {required this.id,
      required this.slotDuration,
      required this.infoAr,
      required this.infoEn,
      required this.status,
      required this.user,
      required this.specialty,
      required this.isFavorite,
      required this.centreId,
      required this.bookedDays,
      this.medicalCenter,
      this.daysPref,
        this.bookedDaySlots,
      required this.daysPreference});

  factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str)['object']);

  String toRawJson() => json.encode(toJson());

  factory Doctor.fromJson(Map<String, dynamic> json,
      [Map<String, dynamic>? favs]) {
    return Doctor(
        id: json["id"],
        slotDuration: json["slotDuration"],
        infoAr: json["infoAr"],
        infoEn: json["infoEn"],
        status: json["status"],
        daysPreference: json["daysPref"] == null
            ? []
            : List<DaysPref>.from(
                json["daysPref"].map((x) => DaysPref.fromJson(x))),
        user: User.fromJson(json["user"]),
        specialty: Specialty.fromJson(json["specialty"]),
        isFavorite: favs?.keys.contains(json["id"].toString()) ?? false,
        centreId: json['medicalCenter'] == null
            ? null
            : json['medicalCenter']['id'].toString(),
      medicalCenter: json["medicalCenter"] == null ? null : MedicalCenter.fromJson(json["medicalCenter"]),
      daysPref: json["daysPref"] == null ? [] : List<DaysPref>.from(json["daysPref"]!.map((x) => DaysPref.fromJson(x))),
      bookedDays: json["bookedDays"] == null ? [] : List<BookedDay>.from(json["bookedDays"]!.map((x) => BookedDay.fromJson(x))),
      bookedDaySlots: json["bookedDaySlots"] == null ? [] : List<BookedDaySlot>.from(json["bookedDaySlots"]!.map((x) => BookedDaySlot.fromJson(x))),



    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "slotDuration": slotDuration,
        "infoAr": infoAr,
        "infoEn": infoEn,
        "status": status,
        "user": user.toJson(),
        "specialty": specialty.toJson(),
        "isFavorite": isFavorite ? 1 : 0
      };

  getName(BuildContext context) {
    return context.locale.languageCode == "en" ? user.nameEn : user.nameAr;
  }

  getDesc(BuildContext context) {
    return context.locale.languageCode == "en" ? infoEn : infoAr;
  }

  Future<bool?> toggleLike() async {
    String? res = await LocalStorage.retrieveValue('favoriteDoctors');
    log('favs is ${res} ${res.runtimeType}');
    Map<String, dynamic> favs = {};

    if (res != null && res != "") {
      favs.addAll(jsonDecode(res));

      log("favs not null ${favs.length} \n fav ${favs}");

      if (favs.keys.contains(id.toString())) {
        favs.remove(id.toString());
        isFavorite = false;
      } else {
        favs[id.toString()] = centreId;
        isFavorite = true;
      }
    } else {
      log('favs is empty, adding first id ${id}');
      favs[id.toString()] = centreId;
      isFavorite = true;
    }
    await LocalStorage.storeValue('favoriteDoctors', jsonEncode(favs));
    return true;
  }

  static getCentreDoctors(int centreId) async {
    String? ls = await LocalStorage.retrieveValue('favoriteDoctors');
    Map<String, dynamic> favs = {};

    if (ls != null) {
      favs = jsonDecode(ls);
      log('fav doctors in getCentreDoctors $favs');
    }

    var res = await RestApiService.get(ApiPaths.getDoctors(centreId));

    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      var array =
          (decoded as List).map((e) => Doctor.fromJson(e, favs)).toList();
      return array;
    } else if (res.statusCode == 204) {
      return [];
    } else {
      throw Exception(
          "error getCentreDoctors $centreId ${res.statusCode} ${res.body}");
    }
  }

  static getCenterDoctor(int centreId, int doctorId) async {
    var res = await RestApiService.get(ApiPaths.getDoctor(centreId, doctorId));
    String? ls = await LocalStorage.retrieveValue('favoriteDoctors');
    Map<String, dynamic> favs = {};

    if (ls != null) {
      favs = jsonDecode(ls);
    }
    log('fav doctors in getDoctor ${favs}');
    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      var array = Doctor.fromJson(decoded, favs);
      return array;
    } else if (res.statusCode == 204) {
      return [];
    } else {
      throw Exception(
          "error getDoctor $centreId $doctorId ${res.statusCode} ${res.body}");
    }
  }
  static getDoctor(String doctorId) async {
    var res = await RestApiService.get(ApiPaths.getDoctorDetails(doctorId));

    log('getDoctor res ${res.body}');




    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      var doctor = Doctor.fromJson(decoded);
      return doctor;
    } else if (res.statusCode == 204) {
      return [];
    } else {
      throw Exception(
          "error getDoctor $doctorId ${res.statusCode} ${res.body}");
    }
  }

  getTimeSlots() async {
    var res =
        await RestApiService.get(ApiPaths.getDoctorTimeSlots(id, centreId));

    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      return List.of((decoded as List).map((e) => null));
    }
  }
}


class BookedDaySlot extends Equatable{
  final int? slotId;
  final DateTime? slotStartTime;
  final DateTime? slotEndTime;
  final int? duration;
  final bool? booked;
  final Day? day;

  BookedDaySlot({
    this.slotId,
    this.slotStartTime,
    this.slotEndTime,
    this.duration,
    this.booked,
    this.day,
  });

  factory BookedDaySlot.fromRawJson(String str) => BookedDaySlot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookedDaySlot.fromJson(Map<String, dynamic> json) {
    final format = DateFormat("yyyy-MM-dd hh:mm:ss a");

    return BookedDaySlot(
    slotId: json["slot_id"],
    slotStartTime: json["slot_start_time"] == null ? null : format.parse(json["slot_start_time"]),
    slotEndTime: json["slot_end_time"] == null ? null : format.parse(json["slot_end_time"]),
    duration: json["duration"],
    booked: json["booked"],
    day: json["day"] == null ? null : Day.fromJson(json["day"]),
  );
  }

  Map<String, dynamic> toJson() => {
    "slot_id": slotId,
    "slot_start_time": slotStartTime?.toIso8601String(),
    "slot_end_time": slotEndTime?.toIso8601String(),
    "duration": duration,
    "booked": booked,
    "day": day?.toJson(),
  };

  @override
  // TODO: implement props
  List<Object?> get props => [ slotStartTime];
}

