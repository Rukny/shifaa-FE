import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/doctor_details_provider.dart';
import 'package:shifaa/models/doctor.dart';

import 'package:shifaa/views/patient_views/doctor_details/widgets/doctor_details_card.dart';
import 'package:shifaa/widgets/gradient_background.dart';
import 'package:shifaa/widgets/question_answer_card.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsPage({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        
        title: Text(
          "doctorDetails".tr(),
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Rubik',
              color: Colors.black),
        ),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradiantBackGroundWrapper(
          child: ChangeNotifierProvider<DoctorDetailsProvider>(
        create: (context) => DoctorDetailsProvider(doctor: doctor),
        builder: (_, child) => Consumer<DoctorDetailsProvider>(
          builder: (_, prov, child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  DoctorDetailsCard(doctor: doctor),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 150,
                    width: 95.w,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: prov.questions,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                if(prov.slots.isEmpty)
                  Container(
                    padding: const EdgeInsets.only(top: 50),

                    width: 90.w,
                    alignment: Alignment.center,
                    child: Text('noSlots'.tr()),
                  ),
                  ///DaySlots
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 55,
                        width: 95.w,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...prov.slots.map((daySlot) => GestureDetector(
                                  onTap: () {
                                    prov.setSelectedDaySlot(daySlot);
                                  },
                                  child: Card(
                                    shadowColor: Colors.white,
                                    color:
                                        prov.selectedDaySlot?.id == daySlot.id
                                            ? AppConstants.green
                                            : Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        margin: const EdgeInsets.all(5),
                                        child: Text(
                                          DateFormat('EEE, d-MMM',context.locale.languageCode)
                                              .format(daySlot.date,),
                                          style: TextStyle(
                                            height: 2,
                                              color: prov.selectedDaySlot?.id ==
                                                      daySlot.id
                                                  ? Colors.white
                                                  : AppConstants.aquamarine),
                                        )),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(
                    height: 25,
                  ),

                  if (prov.selectedDaySlot != null)

                    ///TimeSlots
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Text(
                                'availableTimes'.tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Rubik'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 95.w,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runSpacing: 4,
                            spacing: 1,
                            children: [
                              ...prov.selectedDaySlot!.slots
                                  .map((timeSlot) => GestureDetector(
                                        onTap:timeSlot.disabled? ()async{
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('slotAlreadyBooked'.tr())));
                                        } : () {
                                          prov.setSelectedTimeSlot(timeSlot);
                                        },
                                        child: Card(
                                          shadowColor: Colors.white,
                                          color:timeSlot.disabled?Colors.grey: (prov.selectedDaySlot
                                                      ?.selectedTimeSlot?.id ==
                                                  timeSlot.id
                                              ? AppConstants.green
                                              : Colors.white),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Container(
                                              padding: const EdgeInsets.all(15),
                                              child: Text(
                                                DateFormat('hh:mm a',context.locale.languageCode)
                                                    .format(timeSlot.startTime),
                                                style: TextStyle(
                                                    color:timeSlot.disabled?Colors.white: (prov
                                                                .selectedDaySlot
                                                                ?.selectedTimeSlot
                                                                ?.id ==
                                                            timeSlot.id
                                                        ? Colors.white
                                                        : AppConstants
                                                            .aquamarine)),
                                              )),
                                        ),
                                      ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  if(prov.slots.isNotEmpty)
                  RoundedLoadingButton(
                    borderRadius: 5,

                    color: AppConstants.green,

                    onPressed: () async{
                    prov.submitAppointment(context);
                    }, controller: prov.buttonController,
                    child: Text('submitAppointment'.tr(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}
