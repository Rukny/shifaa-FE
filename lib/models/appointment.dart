

// To parse this JSON data, do
//
//     final appointment = appointmentFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'package:shifaa/utils/restService.dart';

import 'doctor.dart';

class Appointment {
  final String? createDate;
  final int id;
  final String? operationDate;
  final DateTime appointmentDate;
  final int? status;
  final String startTime;
  final String endTime;
  final BookedSlot bookedSlot;
  final Doctor? doctor;
  final Patient? patient;
  String appointmentState="";

  Appointment({
    this.createDate,
    required this.id,
    this.operationDate,
    required this.appointmentDate,
    this.status,
    required this.startTime,
    required this.endTime,
    required this.bookedSlot,
    required this.doctor,
    this.patient, required String appointmentState,
  });

  factory Appointment.fromRawJson(String str) => Appointment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    createDate: json["createDate"],
    id: json["id"],
    operationDate: json["operationDate"],
    appointmentDate:DateFormat("yyyy-MM-dd hh:mm:ss a","en_US").parseLoose(json["appointmentDate"])  ,
    status: json["status"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    bookedSlot: BookedSlot.fromJson(json["bookedSlot"]),
    doctor:json['doctor']==null ? null : Doctor.fromJson(json["doctor"]),
    patient:json['patient']==null?null: Patient.fromJson(json['patient']),
    appointmentState:DateFormat("yyyy-MM-dd hh:mm:ss a","en_US").parseLoose(json["appointmentDate"]).isAfter(DateTime.now())? 'upcoming':'previous'
  );

  Map<String, dynamic> toJson() => {
    "createDate": createDate,
    "id": id,
    "operationDate": operationDate,
    "appointmentDate": appointmentDate,
    "status": status,
    "startTime": startTime,
    "endTime": endTime,
    "bookedSlot": bookedSlot.toJson(),
    "doctor": doctor?.toJson(),

  };

  static getPatientAppointments(int pid)async{
    var res= await RestApiService.get(ApiPaths.getPatientAppointments(pid));

    if(res.statusCode==200){
      return (jsonDecode(res.body) as List).map((value) => Appointment.fromJson(value)).toList();
    }
    else {
      throw Exception("error fetching Appointments ${res.statusCode} ${res.body}");
    }
  }

  static getDoctorAppointments(int did) async {
    var res= await RestApiService.get(ApiPaths.getDoctorAppointments(did));

    if(res.statusCode==200){
      return (jsonDecode(res.body) as List).map((value) => Appointment.fromJson(value)).toList();
    }
    else {
      throw Exception("error fetching Appointments ${res.statusCode} ${res.body}");
    }

  }

  String getStatus() {

 return   appointmentState=   appointmentDate.isAfter(DateTime.now())? 'upcoming':'previous';

  }

  cancelAppointment(dynamic user) async {
    String cancelledBy = "";
    if (user is Patient)
      cancelledBy = "patient";
    if (user is Doctor)
      cancelledBy = "doctor";
    var res = await RestApiService.delete(
        ApiPaths.cancelAppointment(cancelledBy, id));

    log('cancel appointment res ${res.statusCode} ${res.body} ');
    if (res.statusCode == 200) {
      return true;
    }
    else if(res.statusCode>300){
      return false;
    }
  }
}

class BookedSlot {
  final int? slotId;
  final String? slotStartTime;
  final String? slotEndTime;
  final int? duration;
  final bool? booked;

  BookedSlot({
    this.slotId,
    this.slotStartTime,
    this.slotEndTime,
    this.duration,
    this.booked,
  });

  factory BookedSlot.fromRawJson(String str) => BookedSlot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookedSlot.fromJson(Map<String, dynamic> json) => BookedSlot(
    slotId: json["slot_id"],
    slotStartTime: json["slot_start_time"],
    slotEndTime: json["slot_end_time"],
    duration: json["duration"],
    booked: json["booked"],
  );

  Map<String, dynamic> toJson() => {
    "slot_id": slotId,
    "slot_start_time": slotStartTime,
    "slot_end_time": slotEndTime,
    "duration": duration,
    "booked": booked,
  };
}


