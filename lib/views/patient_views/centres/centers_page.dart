import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/centers_provider.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/city.dart';
import 'package:shifaa/widgets/gradient_background.dart';

class CentersPage extends StatelessWidget {
  const CentersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GradiantBackGroundWrapper(
        child: ChangeNotifierProvider<CentersProvider>(
      create: (_) => CentersProvider(),
      builder: (_, child) => Consumer<CentersProvider>(
        builder: (_, prov, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: 30.h,
                    margin: EdgeInsets.only(bottom: 3.h),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff64BECD),
                            Color(0xff5BC7CA),
                            Color(0xff50D2C5),
                            Color(0xff49DAC2),
                            Color(0xff46DDC0),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                  ),
                  Positioned(
                      top: 6.h,
                      right: 0,left: 0,

                      child: Center(child: Text(    'centers'.tr(),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 20),))),
                  Positioned(
                    top: 12.h,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'hello'.tr(args: [context.read<UserProvider>().getCurrentUser().user.getName(context)]),
                                style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              Text(
                                'findYourCenter'.tr(),
                                style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            ],
                          ),
                          const CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.transparent,
                            foregroundImage:
                                AssetImage('assets/logoc.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 10.w,
                      left: 10.w,
                      child: prov.cities == null
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: AppConstants.gradiant1,
                            ))
                          : CustomDropdown(
                              hintText: 'selectCity'.tr(),hintStyle: TextStyle(locale: context.locale,),
                              borderSide: const BorderSide(
                                  color: AppConstants.aquamarine),
                              items: [
                                ...prov.cities!.map((e) => e.getName(context))
                              ],
                              onChanged: (p0) => prov.handleSearch(p0,context),
                              controller: prov.textEditingController,
                              selectedStyle: const TextStyle(
                                  color: AppConstants.gradiant2),
                            )),
                ],
              ),
              if(prov.selectedCity!=null)
                TextButton(onPressed: () {
                  prov.clearSearch();
                }, child: Text('clear'.tr()),),
              SizedBox(height: 2.h,),
              Expanded(
                child: Wrap(

                    children: prov.centres == null
                        ? [Padding(
                          padding:   EdgeInsets.only(top: 15.h),
                          child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                        )]
                        : prov.cards),
              )
            ],
          );
        },
      ),
    ));
  }
}
