import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/center_details_provider.dart';
import 'package:shifaa/models/centre.dart';
import 'package:shifaa/widgets/doctor_card.dart';
import 'package:shifaa/widgets/gradient_background.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CenterDetailsPage extends StatelessWidget {
  final Centre centre;

  const CenterDetailsPage({Key? key, required this.centre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ChangeNotifierProvider<CenterDetailsProvider>(
        create: (_) => CenterDetailsProvider(centre: centre),
        builder: (_, child) => Consumer<CenterDetailsProvider>(
          builder: (_, prov, child) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Image.asset('assets/ui/centrebg.png'),
                  Positioned(
                    top: 15.h,
                    left: 5.w,
                    right: 5.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  centre.getName(context),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              centre.getAddress(
                                context,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                   /*         AbsorbPointer(
                              child: RatingStars(
                                onValueChanged: null,
                                starSize: 14,
                                value: 1.w,
                                valueLabelVisibility: false,
                              ),
                            ),*/
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      log("loc is ${prov.centre.map}");
                                      String googleString="https://www.google.com/maps/search/?api=1&query=${prov.centre.map}";
                                       if(await canLaunchUrlString(googleString)) {
                                         launchUrl(Uri.parse(googleString),mode: LaunchMode.externalApplication);
                                       }
                                    },
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Colors.blueAccent,
                                  ),
                                    onPressed: () async {
                                      log("phone is ${prov.centre.phone}");
                                      String phoneString="tel:${prov.centre.phone}";
                                      if(await canLaunchUrlString(phoneString)) {
                                        launchUrl(Uri.parse(phoneString));
                                      }
                                    }
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 30.h,
                      right: 5.w,
                      left: 5.w,
                      child: prov.specialities == null
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: AppConstants.gradiant1,
                            ))
                          : CustomDropdown(
                              hintText: 'selectSpecialty'.tr(),
                              borderSide: const BorderSide(
                                  color: AppConstants.aquamarine),
                              items: [

                                     ... prov.specialities!.map((e) => e.getName(context))
                              ],
                              onChanged: (p0) => prov.handleSearch(p0, context),
                              controller: prov.textEditingController,
                              selectedStyle: const TextStyle(
                                  color: AppConstants.gradiant2),
                            )),
                  Container(

                      margin: EdgeInsets.only(top: 40.h ,bottom: 0.h),

                      width: 100.w,padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: prov.filteredDoctors == null
                          ? Padding(
                            padding:   EdgeInsets.only(top: 15.h),
                            child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                          )
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                            children: [
                              if(prov.selectedSpecialty!=null)
                              TextButton(onPressed: () {
                                  prov.clearSearch();
                              }, child: Text("clear".tr())),
                              Padding(
                                padding:   EdgeInsets.only(bottom: 20.h),
                                child: GridView(

                        physics: const NeverScrollableScrollPhysics(),shrinkWrap: true,
                                    padding: EdgeInsets.only(bottom: 1.h,left: 5,right: 5,top: 15),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.95),

                                    children:  prov.filteredDoctors!.map((e) => DoctorCard(
                                      doctor: e,key: Key(e.user.id.toString()),
                                    )).toList()),
                              ),
                            ],
                          )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
