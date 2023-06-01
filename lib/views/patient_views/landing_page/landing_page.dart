import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/landing_provider.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/appointment.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/widgets/gradient_background.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LandingProvider(),
      builder: (_, __) => Consumer<LandingProvider>(
        builder: (_, prov, __) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Stack(
                      children: [
                        BannerCarousel.fullScreen(
                          banners: prov.banners,
                          //  customizedIndicators: IndicatorModel.animation(width: 20, height: 5, spaceBetween: 2, widthAnimation: 50),

                          height: 40.h,
                          pageController: prov.pageController,
                          activeColor: Colors.amberAccent,
                          disableColor: Colors.white,
                          animation: false,
                          borderRadius: 0,

                          indicatorBottom: false,
                        ),
                        Positioned(
                          bottom: 30,
                          left: 40,
                          child: AnimatedTextKit(
                            isRepeatingAnimation: true,
                            repeatForever: true,
                            pause: Duration(milliseconds: 500),
                            onNext: (p0, p1) => prov.onNext(),
                            animatedTexts: [
                              RotateAnimatedText('slide1Text'.tr(),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 32,
                                    color: AppConstants.gradiant1,
                                  ),
                                  duration: const Duration(seconds: 4)),
                              RotateAnimatedText('slide2Text'.tr(),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 32,
                                    color: AppConstants.green,
                                  ),
                                  duration: const Duration(seconds: 4)),
                              RotateAnimatedText('slide3Text'.tr(),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 32,
                                    color: AppConstants.gradiant2,
                                  ),
                                  duration: const Duration(seconds: 4)),
                              RotateAnimatedText('slide4Text'.tr(),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 32,
                                    color: AppConstants.aquamarine,
                                  ),
                                  duration: const Duration(seconds: 4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 36.h),
                      child: Container(
                        width: 100.w,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const SizedBox(
                            height: 10,
                          ),
                          if (prov.myAppointments.length >= 2)
                            SizedBox(
                              height: 220,
                              width: 95.w,
                              child: CardSwiper(
                                cardsCount: prov.myAppointments.length,
                                controller: prov.cardSwiperController,
                                backCardOffset: const Offset(30, 0),
                                isVerticalSwipingEnabled: false,
                                cardBuilder: (context, index) =>
                                    AppointmentCard(
                                        appointment:
                                            prov.myAppointments[index]),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'YourQuestions'.tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'Rubik'),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'more'.tr(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'Rubik'),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 95.w,
                            height: 140,
                            child: ListView(
                              cacheExtent: 50.w,
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              semanticChildCount: prov.myQuestions.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: prov.myQuestions,
                            ),
                          ),
                          if (prov.favoriteDoctors.isNotEmpty &&
                              context.read<UserProvider>().patient != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'FavoriteDoctors'.tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Rubik'),
                                  ),
                                  /*     TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'more'.tr(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'Rubik'),
                                    )),*/
                                ],
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (prov.favoriteDoctors.isEmpty &&
                              context.read<UserProvider>().getCurrentUser() is Patient)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/ui/no-result.jpg',
                                    fit: BoxFit.contain,
                                    height: 250,
                                    width: 250,
                                  ),
                                  Text('noFavoriteDoctors'.tr()),
                                ],
                              ),
                            ),
                              if(prov.favoriteDoctors.isNotEmpty && context.read<UserProvider>().patient!=null)
                            SizedBox(
                              width: 95.w,
                              height: 210,
                              child: ListView(
                                cacheExtent: 50.w,
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                semanticChildCount: prov.favoriteDoctors.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: prov.favoriteDoctors,
                              ),
                            ),
                          const SizedBox(
                            height: 40,
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: AppConstants.aquamarine.withOpacity(0.95),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(
                        appointment.doctor!.user.photo!,
                      ),
                      backgroundColor: AppConstants.aquamarine,
                      radius: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctor?.getName(context) ?? " ",
                          style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          appointment.doctor?.specialty.getName(context),
                          style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: 100.w,
                child: Card(
                  color: const Color(0xff8EE0D4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_sharp,
                            color: Colors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          DateFormat('EEE, dd, hh:mm a')
                              .format(appointment.appointmentDate),
                          style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const Spacer(),
                        if (appointment.appointmentDate
                                .difference(DateTime.now())
                                .inDays ==
                            0)
                          Text(
                            "today".tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        if (appointment.appointmentDate
                                .difference(DateTime.now())
                                .inDays >
                            1)
                          Text(
                            'inxDays'.tr(args: [
                              appointment.appointmentDate
                                  .difference(DateTime.now())
                                  .inDays
                                  .toString()
                            ]),
                            style: TextStyle(color: Colors.white),
                          )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
