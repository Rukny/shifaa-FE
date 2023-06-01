import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/mybookings_provider.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/views/shared_views/appointment_details/appointment_details_page.dart';
import 'package:shifaa/widgets/gradient_background.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCardDate =
        DateFormat("EEE, d MMM, hh:mm a", context.locale.languageCode);
    return GradiantBackGroundWrapper(
      child: ChangeNotifierProvider<MyBookingsProvider>(
        create: (context) => MyBookingsProvider(context),
        child: CircularProgressIndicator(),
        builder: (context, child) => Consumer<MyBookingsProvider>(
          builder: (_, prov, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 15.h,child:   Center(
                  child: Text(
                    'myBookings'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 20) ,
                  ),
                ) ,
                ),

              if(prov.loading)
                SizedBox(height: 20.h,child: const Center(child: CircularProgressIndicator(),),),
                ///filters
                if(prov.allMyAppointments.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => prov.setFilter('all'),
                      child: Card(
                        shadowColor: Colors.white,
                        color: prov.filterBy == 'all'
                            ? AppConstants.green
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Container(
                            width: 85,
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                "all".tr(),
                                style: TextStyle(
                                    color: prov.filterBy == 'all'
                                        ? Colors.white
                                        : AppConstants.aquamarine),
                              ),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => prov.setFilter('upcoming'),
                      child: Card(
                        shadowColor: Colors.white,
                        color: prov.filterBy == 'upcoming'
                            ? AppConstants.green
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                "upcoming".tr(),
                                style: TextStyle(
                                    color: prov.filterBy == 'upcoming'
                                        ? Colors.white
                                        : AppConstants.aquamarine),
                              ),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => prov.setFilter('previous'),
                      child: Card(
                        shadowColor: Colors.white,
                        color: prov.filterBy == 'previous'
                            ? AppConstants.green
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                "previous".tr(),
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                    color: prov.filterBy == 'previous'
                                        ? Colors.white
                                        : AppConstants.aquamarine),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
               const SizedBox(height: 15,),
                if(prov.allMyAppointments.isEmpty && prov.loading==false)
                   Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Image.asset('assets/images/empty-list.jpg'),
                 //      Text('noAppointments'.tr(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                     ],
                   ),
                if(prov.filteredAppointments.isEmpty && prov.loading==false)
                  SizedBox(height: 20.h,child: Center(child: Text('noAppointments'.tr())),),

                if(prov.filteredAppointments.isNotEmpty)
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 5),

                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,

                    children: prov.filteredAppointments
                        .map((e) => Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, bottom: 1, top: 10),
                              child: Row(
                                children: [
                                  Card(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    color: AppConstants.green,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            e.appointmentDate.day.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            DateFormat(
                                                'MMMM',
                                                context
                                                    .locale.languageCode)
                                                .format(e.appointmentDate)
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${prov.getUserName(e, context)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      if(prov.userType is Patient)
                                        Text("${e.doctor!.specialty.getName(context)}"),
                                      const SizedBox(height: 5,),
                                      AutoSizeText(
                                        formatCardDate
                                            .format(e.appointmentDate)
                                            .toString(),
                                        style: const TextStyle(
                                            color: AppConstants.aquamarine),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            log("loc is ${e.doctor!.medicalCenter!.map}");
                                            String googleString="https://www.google.com/maps/search/?api=1&label=testtt&query=${e.doctor!.medicalCenter!.map}";
                                            if(await canLaunchUrlString(googleString)) {
                                              launchUrl(Uri.parse(googleString),mode: LaunchMode.externalApplication);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.location_on,
                                            color: Colors.blue,
                                            size: 25,
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap:  () async {
                                          log("phone is ${e.doctor!.medicalCenter!.phone}");
                                          String phoneString="tel:${e.doctor!.medicalCenter!.phone}";
                                          if(await canLaunchUrlString(phoneString)) {
                                            launchUrl(Uri.parse(phoneString));
                                          }
                                        },
                                        child: const Icon(
                                          Icons.phone,
                                          color: Colors.blueAccent,
                                          size: 20,



                                        ),
                                      )

                                    ],)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Card(
                                    shadowColor: Colors.white,
                                    color: Colors.lightGreenAccent.shade700,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Container(
                                        margin: EdgeInsets.all(1),
                                        width: 60,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 2),
                                        child: Center(
                                          child: AutoSizeText(
                                            e.getStatus().tr(),
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10),
                                    child: GestureDetector(
                                        onTap: () async {
                                          var cancelChoice=await    showDialog<bool?>(context: context, builder:(context) =>  AlertDialog(title: Text('cancelConfirmationTitle'.tr()),
                                            content: Text('cancelConfirmationBody'.tr()),
                                            actions: [
                                              TextButton(onPressed: () {
                                                Navigator.pop(context,false);
                                              }, child: Text('no'.tr())),
                                              TextButton(onPressed: () {
                                                Navigator.pop(context,true);
                                              }, child: Text('yes'.tr())),
                                            ],
                                          ));
                                          if(cancelChoice!=null && cancelChoice)
                                            prov.cancelAnAppointment(e,context);
                                        },
                                        child: Text('cancel'.tr(),  style: const TextStyle(color: Colors.red,fontSize: 13 ),)),
                                  )

                                ],
                              ),
                            ),

                          ],
                        )))
                        .toList(),
                  ),
                ),

              ],
            );
          },
        ),
      ),
    );
  }
}
