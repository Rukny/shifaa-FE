


import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

class BookedDay {
  final int? id;
  final bool? available;
  final DateTime? dayDate;
  final Day? day;
  final List<TimeSlot>? slots;

  BookedDay({
    this.id,
    this.available,
    this.dayDate,
    this.day,
    this.slots,
  });

  factory BookedDay.fromRawJson(String str) => BookedDay.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookedDay.fromJson(Map<String, dynamic> json) => BookedDay(
    id: json["id"],
    available: json["available"],
    dayDate: json["day_date"] == null ? null : DateTime.parse(json["day_date"]),
    day: json["day"] == null ? null : Day.fromJson(json["day"]),
    slots: json["slots"] == null ? [] : List<TimeSlot>.from(json["slots"]!.map((x) => TimeSlot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "available": available,
    "day_date": dayDate?.toIso8601String(),
    "day": day?.toJson(),
    "slots": slots == null ? [] : List<dynamic>.from(slots!.map((x) => x.toJson())),
  };
}

class DaySlot {
  final int id;
  final DateTime date;
  late List<TimeSlot> slots;
  final DaysPref preferredDay;
  final int duration;
  TimeSlot? selectedTimeSlot;


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "date": DateFormat('yyyy-MM-dd').format(date),

      "preferredDay": preferredDay.toJson(),
      "duration": duration,
      "selectedTimeSlot": selectedTimeSlot?.toJson(),
    };
  }

  DaySlot(this.id, this.date, this.preferredDay, this.duration,
      ) {
    slots=[];
    DateTime dayStartTime = date.copyWith(
        hour: int.tryParse(preferredDay.startTime.split(':')[0]),
        minute: int.tryParse(preferredDay.startTime.split(':')[1],),second: 00,microsecond: 00,millisecond: 00);

    DateTime dayEndTime=date.copyWith(
        hour: int.tryParse(preferredDay.endTime.split(':')[0]),
        minute: int.tryParse(preferredDay.endTime.split(':')[1]),second: 00,microsecond: 00,millisecond: 00,);
    int diff=dayEndTime.difference(dayStartTime).inMinutes~/duration;


    DateTime timeUsed=dayStartTime;

    for(int i=0; i<=diff;i++){
      if(i==0){
        slots.add(TimeSlot(timeUsed, timeUsed.add(Duration(minutes: duration)), duration, i));
      }
      else {
        TimeSlot obj = TimeSlot(timeUsed.add(Duration(minutes: duration*i)), timeUsed.add(Duration(minutes:duration*i+ duration)), duration, i);

        slots.add(obj);
      }

    }
 //   log("number if slots to fill is $diff , filled slots count for this day is ${slots.length}");
  //  log('start time is ${dayStartTime.toString()} and end time is ${dayEndTime.toString()}');
  }
}

class TimeSlot extends Equatable{
final  DateTime startTime;
final  DateTime endTime;
final  int duration;
final  int id;

  bool disabled=false;

  TimeSlot(this.startTime, this.endTime, this.duration, this.id);

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
       DateTime.parse(json["slot_start_time"]),
     DateTime.parse(json["slot_end_time"]),
     json["duration"],
      json["slot_id"],
    );
  }

Map<String, dynamic> toJson() {
    return {
      "startTime": DateFormat('hh:mm:00').format(startTime),
      "endTime": DateFormat('hh:mm:00').format(endTime),
      "duration": duration,
      "id": id,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [startTime,];
}

class DaysPref {
  int id;
  String startTime;
  String endTime;

  Day day;

  DaysPref({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.day,
  });

  factory DaysPref.fromRawJson(String str) =>
      DaysPref.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DaysPref.fromJson(Map<String, dynamic> json) => DaysPref(
    id: json["id"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    day: Day.fromJson(json["day"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_time": startTime,
    "end_time": endTime,
    "day": day.toJson(),
  };
}

class Day extends Equatable{
  int dayId;
  String dayName;
  bool weekend;

  Day({
    required this.dayId,
    required this.dayName,
    required this.weekend,
  });

  factory Day.fromRawJson(String str) => Day.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    dayId: json["day_id"],
    dayName: json["day_name"],
    weekend: json["weekend"],
  );

  Map<String, dynamic> toJson() => {
    "day_id": dayId,
    "day_name": dayName,
    "weekend": weekend,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [dayName];
}

