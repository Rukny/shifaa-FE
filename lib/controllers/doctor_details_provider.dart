import 'dart:convert';
import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/booked_day.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/models/question.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'package:shifaa/utils/restService.dart';
import 'package:shifaa/widgets/question_answer_card.dart';
import 'package:collection/collection.dart';
class DoctorDetailsProvider extends ChangeNotifier {
  final Doctor doctor;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  DaySlot? selectedDaySlot;

  List<DaySlot> slots = [  ];
  List<Widget> questions = [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: const Center(child: CircularProgressIndicator()),
    )
  ];

  final buttonController = RoundedLoadingButtonController();

  DoctorDetailsProvider({required this.doctor}) {
    initTimeSlots();
    selectedDaySlot = slots.firstWhereOrNull(
        (element) => element.date.difference(DateTime.now()).inDays == 0);
if(selectedDaySlot==null)
  {
    slots.isEmpty?null:slots.first;
  }
    initQA();
  }

  initQA() async {
    List res = await Question.getQuestions();

    questions = List.from(res.map((e) => QuestionAnswerCard(question: e)));

    notifyListeners();
  }

  initTimeSlots() async {


    /// when index is 0 means it's today
    for(int i=0;i<20;i++){

      DateTime iterationDay=DateTime.now().add(Duration(days: i));
      if(doctor.daysPreference.any((element) => element.day.dayName.contains(DateFormat('EEE').format(iterationDay)))) {

        slots.add(DaySlot(i, iterationDay,  getDayPref(iterationDay),doctor.slotDuration));

      }


      slots = slots.map((daySlot) {


        // Use List.any() to check if there is a match in the booked list
         daySlot.slots.forEach((slot) {
        var slotMatch=    doctor.bookedDaySlots?.any((element) =>
          element.slotStartTime
              !.isAtSameMomentAs(slot.startTime)
              ) ?? false;
            if(slotMatch)
              slot.disabled=true;
        } ,);




        return daySlot;
      }).toList();
    }



  }

  void setSelectedDaySlot(DaySlot daySlot) {

      selectedDaySlot = daySlot;
    notifyListeners();
  }

  void setSelectedTimeSlot(TimeSlot timeSlot) {
    print('selected Timeslot is ${timeSlot}');
    selectedDaySlot!.selectedTimeSlot = timeSlot;
    notifyListeners();
  }

  submitAppointment(BuildContext context) async {
    if (selectedDaySlot == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('selectDay'.tr())));
      buttonController.error();
      Future.delayed(const Duration(seconds: 1))
          .whenComplete(() => buttonController.reset());
    } else if (selectedDaySlot?.selectedTimeSlot == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('selectTime'.tr())));
      buttonController.error();
      Future.delayed(const Duration(seconds: 1))
          .whenComplete(() => buttonController.reset());
    } else {

      Map data={
          "operationDate": DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now()),
        "appointmentDate": DateFormat('yyyy-MM-dd hh:mm:ss a').format(selectedDaySlot!.selectedTimeSlot!.startTime).toUpperCase() ,
        "dayId": selectedDaySlot!.preferredDay.day.dayId,

        "startTime": DateFormat('yyyy-MM-dd hh:mm:00 a').format(selectedDaySlot!.selectedTimeSlot!.startTime).toUpperCase(),
        "endTime": DateFormat('yyyy-MM-dd hh:mm:00 a').format(selectedDaySlot!.selectedTimeSlot!.endTime).toUpperCase(),
        "doctorId": doctor.id,
        "patientId": context.read<UserProvider>().patient!.id
      };

   var submitRes=  await createAppointment(data);

      print('appointment data is  \n ${jsonEncode(data)}');
    if(submitRes) {
      var res=  await showDialogSuper(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            content: Column(
              mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/ui/thumbsup.png',
                  height: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'thankYou'.tr(),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rubik',
                  ),
                ),
                Center(
                  child: Text(textAlign: TextAlign.center,
                    'bookingConfDialog'.tr(),
                    style: const TextStyle(color: AppConstants.textBlueGrey),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                  child: Text(textAlign: TextAlign.center,
                    'aptConfirmed'.tr(namedArgs: {
                      'drName': doctor.getName(context),
                      'date': DateFormat('d-MMMM', context.locale.languageCode)
                          .format(selectedDaySlot!.date),
                      'time': DateFormat('hh:mm a', context.locale.languageCode)
                          .format(selectedDaySlot!.selectedTimeSlot!.startTime)
                    }),
                    style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Rubik',
                        color: AppConstants.textBlueGrey),
                  ),
                ),
                const SizedBox(height: 15,),
                ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(1000.w, 50)),backgroundColor: MaterialStateProperty.all(AppConstants.green),
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))))),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'home');
                    },
                    child: Text('close'.tr()))
              ],
            ),
          );
        },
      );
    }
      buttonController.success();
      Future.delayed(Duration(seconds: 2))
          .whenComplete(() => buttonController.reset());
    }
  }

  DaysPref getDayPref(DateTime iterationDay) {
   print('formatted is ${DateFormat('EEE').format(iterationDay)}');

    return doctor.daysPreference.firstWhere((element) {
    //  print("day name is ${element.day.dayName}");
      return element.day.dayName.contains(DateFormat('EEE').format(iterationDay));
    });

  }

  createAppointment(Map data) async {
    var res= await RestApiService.post(ApiPaths.createAppointment,data);
    print("create appoint res ${res.statusCode} ${res.body}");
      if(res.statusCode==201) {
        return true;
      } else {
        return false;
      }
  }
}
