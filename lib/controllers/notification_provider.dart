import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shifaa/models/notification.dart';
import 'package:shifaa/utils/local_storage.dart';

class NotificationProvider extends ChangeNotifier {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  List<AppNotification> notifications=[];
  int notifCount=0;
  NotificationProvider() {
    _getNotifs();
    initialize();
    listen();
  }

  listen() async {
    print('fcm is ${await FirebaseMessaging.instance.getToken()}');
    FirebaseMessaging.onMessage.listen((event) async {
      print('recieved notification onMessage  \n ${event.toMap()}');
   await   storeNotif(event);
  await onNotification(event);
    });

  }

 static Future<void>  firebaseMessagingBackgroundHandler(RemoteMessage message) async {

    await Firebase.initializeApp();
   await storeNotifBg(message);
    print("Handling a background message: ${jsonEncode(message.toMap())}");
  }

  onNotification(dynamic event)async {
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(Random().nextInt(100).toString(), 'shifaa',
        channelDescription: 'Shifaa Notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    await  flutterLocalNotificationsPlugin.show(
        Random().nextInt(100), event.notification?.title ?? " ",
        event.notification?.body ?? " ",  NotificationDetails(android: androidNotificationDetails));

  }

  static requestFirebasePerms() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    return await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }
  void initialize()async {

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          print('onDidReceiveNotificationResponse details: ${details} ');
        },);
  }

  _getNotifs()async{
    var notifs=await  const FlutterSecureStorage().read(key: 'notifications');

    print('notifs storeNotif is ${notifs}');
    if(notifs!="" && notifs!=null) {
      notifications=List.from(jsonDecode(notifs)).map((e) => AppNotification.fromJson(e)).toList();
      notifCount=notifications.length;
    }
  }

    storeNotif(RemoteMessage message) async {
    var notifs=await  const FlutterSecureStorage().read(key: 'notifications');
    List  list=[];
    print('notifs storeNotif is ${notifs}');
    if(notifs!="" && notifs!=null) {
         list=List.from(jsonDecode(notifs)).map((e) => AppNotification.fromJson(e)).toList();
    }
    notifCount++;
    list.add(AppNotification.fromFcmJson(message.toMap()));
    notifications=List.from(list);
    notifCount=list.length;
    await const FlutterSecureStorage().write(key: 'notifications', value: jsonEncode(list));
    print('added new notif to ls storeNotif');
    notifyListeners();
  }

 static storeNotifBg(RemoteMessage message) async {
    var notifs=await  const FlutterSecureStorage().read(key: 'notifications');
    List  list=[];

    if(notifs!=null)
         list=List.from(jsonDecode(notifs)).map((e) => AppNotification.fromJson(e)).toList();
    list.add(AppNotification.fromJson(message.toMap()));

    await const FlutterSecureStorage().write(key: 'notifications', value: jsonEncode(list));
    print('added new notif to ls storeNotifBg');

  }
    removeNotif(AppNotification e) async{
    print('delete notif ${e.messageId}');


    notifications.remove(e);
    notifCount--;


    await const FlutterSecureStorage().write(key: 'notifications', value: jsonEncode(notifications));

      notifyListeners();

  }


}

