import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/models/appointment.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/models/question.dart';
import 'package:shifaa/utils/local_storage.dart';
import 'package:shifaa/widgets/doctor_card.dart';
import 'package:shifaa/widgets/question_answer_card.dart';

class LandingProvider extends ChangeNotifier {
  final PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  final CardSwiperController cardSwiperController = CardSwiperController();
  final List<BannerModel> banners = [
    BannerModel(imagePath: 'assets/images/doctors.png', id: "0"),
    BannerModel(imagePath: 'assets/images/doctors2.png', id: "1"),
    BannerModel(imagePath: 'assets/images/doctors3.png', id: "2"),
    BannerModel(imagePath: 'assets/images/doctors4.png', id: "3"),
  ];

  List<Appointment> myAppointments=[];


  List<Widget> myQuestions = [
    const Center(
      child: CircularProgressIndicator(
        color: AppConstants.aquamarine,
      ),
    )
  ];

  List<Widget> favoriteDoctors = [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: const Center(child: CircularProgressIndicator()),
    )
  ];

  LandingProvider() {


    initQA();
    initFav();
    initMyAppointments();
  }

  initSlider() {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.page!.toInt() < 3) {
        pageController.nextPage(
            duration: const Duration(seconds: 1), curve: Curves.easeIn);
      } else {
        pageController.jumpTo(0.0);
      }
    });
  }

  onNext() {
    cardSwiperController.swipeLeft();
    if (pageController.page!.toInt() < 3) {
      pageController.nextPage(
          duration: const Duration(seconds: 1), curve: Curves.easeIn);
    } else {
      pageController.jumpTo(0.0);
    }
  }

  initQA() async {
    var questions = await Question.getQuestions();
    myQuestions.clear();
    myQuestions =
        List.from(questions.map((e) => QuestionAnswerCard(question: e)));

    notifyListeners();
  }

  initFav() async {
    String? res = await LocalStorage.retrieveValue('favoriteDoctors');
    if (res != null && res != "") {
      Map<String, dynamic> list = jsonDecode(res);
      List<Doctor> doctors = [];
      log('fav docs are ${list}');
      await Future.forEach(list.entries, (element) async {
        var res = await Doctor.getCenterDoctor(
            int.parse(element.value), int.parse(element.key));
        doctors.add(res);
      });
      favoriteDoctors = List.from(doctors.map((e) => DoctorCard(
        key: Key(e.id.toString()),
            doctor: e,
            fun: (int i) {
             initFav();
            },
          )));
    } else {
      favoriteDoctors = [];
    }
    notifyListeners();
  }

  onDispose() {
    log('landing page provider onDispose called');
    cardSwiperController.dispose();
    pageController.dispose();
  }

  void initMyAppointments() async{
    var pid=await LocalStorage.retrieveValue('patientId');
    if(pid !=null) {
      myAppointments = await Appointment.getPatientAppointments(int.parse(pid));
      log('retrieved myAppointments ${myAppointments.length}');
      notifyListeners();

    }
  }
}
