// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AppNotification  extends Equatable{
  final Map? data;
  final String? from;
  final String? messageId;
  final String? title;
  final String? body;
  final String? imageUrl;
  final int? sentTime;
  final int? ttl;

  AppNotification({
    this.data,
    this.from,
    this.messageId,
    this.title,
    this.body,
    this.imageUrl,
    this.sentTime,
    this.ttl,
  });

  factory AppNotification.fromRawJson(String str) => AppNotification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppNotification.fromFcmJson(Map<String, dynamic> json) => AppNotification(
    data: json["data"]  ,
    from: json["from"],
    messageId: json["messageId"],
    title: json['notification']['title'],
    body: json['notification']['body'],
    imageUrl: json['notification']['android']['imageUrl'],
    sentTime: json["sentTime"],
    ttl: json["ttl"],
  );
  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    data: json["data"]  ,
    from: json["from"],
    messageId: json["messageId"],
    title: json['title'],
    body: json['body'],
    imageUrl: json['imageUrl'],
    sentTime: json["sentTime"],
    ttl: json["ttl"],
  );

  Map<String, dynamic> toJson() {
    return {
      "data": data,
      "from": from,
      "messageId": messageId,
      "title": title,
      "body": body,
      "imageUrl": imageUrl,
      "sentTime": sentTime,
      "ttl": ttl,
    };
  }

  static Future<List<AppNotification>> getNotifications() async{

    var notifs=await  const FlutterSecureStorage().read(key: 'notifications');
    List  list=[];
    print('notifs storeNotif is ${notifs}');
    if(notifs!="" && notifs!=null) {
    return  list=List.from(jsonDecode(notifs)).map((e) => AppNotification.fromJson(e)).toList();
    }
    else return [];
  }

  @override

  List<Object?> get props => [messageId];


}



