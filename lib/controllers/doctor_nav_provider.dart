
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shifaa/views/doctor_views/doctor_profile_page/doctor_profile_page.dart';
import 'package:shifaa/views/doctor_views/my_appointments/doctor_appointments_page.dart';

import 'package:shifaa/views/patient_views/centres/centers_page.dart';
import 'package:shifaa/views/patient_views/landing_page/landing_page.dart';
import 'package:shifaa/views/patient_views/my_bookings/mybookings_page.dart';
import 'package:shifaa/views/patient_views/profile/profile_page.dart';
import 'package:shifaa/views/patient_views/qa/qa_page.dart';

class DoctorNavProvider extends ChangeNotifier {
  int bottomNavIndex = -1;
  Widget currentPage = const LandingPage();

  final AdvancedDrawerController advancedDrawerController =
  AdvancedDrawerController();

  List<Widget> pages = [
    const MyBookingsPage(),
    const QaPage(),

    const DoctorProfilePage(),
  ];

  List<String> pageTitles = [
    'MyAppointments'.tr(),
    'qa'.tr(),

    'myProfile'.tr()
  ];

  List<IconData> icons = [
    FontAwesomeIcons.list,
    Icons.question_answer_outlined,

    Icons.account_circle_rounded
  ];

  List<Widget> actions = [];

  onNavTap(int index) {
    log('onnavtap ${index}');
    if (bottomNavIndex != index) {
      bottomNavIndex = index;
      currentPage = pages[index];
      notifyListeners();
    } else {
      log('tapped on same item, ignoring');
    }
  }

  setActions(List<Widget> widgets) {
    actions.clear();
    actions.addAll(widgets);
    notifyListeners();
  }

  onHomeTap() {
    bottomNavIndex = -1;
    currentPage = const LandingPage();
    notifyListeners();
  }

  void closeDrawer() async {
    advancedDrawerController.hideDrawer();

    notifyListeners();
  }
}
