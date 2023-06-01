

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shifaa/models/appointment.dart';
import 'package:shifaa/widgets/gradient_background.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointment appointment;
  const AppointmentDetailsPage({Key? key,required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(elevation: 0,backgroundColor: Colors.transparent,
        centerTitle: true,
        title:Text('appointmentDetails'.tr(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),) ,),
        body: GradiantBackGroundWrapper(child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

            ],
          ),
        )),

    );
  }
}
