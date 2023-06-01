import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/doctor_profile_provider.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/speciality.dart';
import 'package:shifaa/widgets/gradient_background.dart';
import 'package:shifaa/widgets/text_field.dart';

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradiantBackGroundWrapper(
      child: ChangeNotifierProvider<DoctorProfileProvider>(
        create: (context) => DoctorProfileProvider(),
        builder: (context, child) =>
            Consumer2<DoctorProfileProvider, UserProvider>(
          builder: (context, profileProv, userProv, child) {
            return SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  if (profileProv.doctor == null) {
                    return Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 30.h,
                              width: 100.w,
                              margin: const EdgeInsets.only(bottom: 30),
                              decoration: const BoxDecoration(
                                  color: AppConstants.aquamarine,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.elliptical(400, 70),
                                      bottomRight: Radius.elliptical(400, 70))),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 30.w,
                              left: 30.w,
                              child: CircleAvatar(
                                radius: 47,
                                backgroundColor: Colors.transparent,
                                foregroundImage: CachedNetworkImageProvider(
                                    profileProv.doctor!.user.photo!),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton.outlined(
                                onPressed: () {
                                  profileProv.toggleEdit();
                                },
                                icon: const Icon(
                                  Icons.edit,
                                )),
                            const SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        FormBuilder(
                            enabled: profileProv.isEditing,
                            initialValue: {
                              'birthday': DateTime.tryParse(
                                  profileProv.doctor!.user.birthday),
                              'gender': profileProv.doctor!.user.gender,
                              'speciality':profileProv.doctor?.specialty
                            },
                            key: profileProv.formKey,
                            child: Wrap(
                              runSpacing: 15,
                              children: [
                                AppTextField(
                                  name: 'firstName',
                                  hintText: 'firstName'.tr(),
                                  validators: FormBuilderValidators.required(
                                      errorText: 'required'.tr()),
                                  padding: 2.w,
                                  value: profileProv.doctor!.user.nameEn
                                      .split(' ')[0],
                                ),
                                AppTextField(
                                    name: 'lastName',
                                    hintText: 'lastName'.tr(),
                                    padding: 2.w,
                                    value: profileProv.doctor!.user.nameEn
                                        .split(' ')[1],
                                    validators: FormBuilderValidators.required(
                                        errorText: 'required'.tr())),
                                AppTextField(
                                    name: 'email',
                                    hintText: 'email'.tr(),
                                    enabled: false,
                                    textInputType: TextInputType.number,
                                    value: profileProv.doctor!.user.email,
                                    padding: 2.w,
                                    validators: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText: 'required'.tr()),
                                      FormBuilderValidators.email()
                                    ])),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'birthDate'.tr(),
                                          maxLines: 2,
                                          style: const TextStyle(
                                              color: AppConstants.textBlueGrey),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 70.w,
                                        child: FormBuilderDateTimePicker(
                                          name: 'birthday',
                                          locale: context.locale,
                                          enableInteractiveSelection: true,
                                          format: DateFormat('dd-MMM-yyyy'),
                                          textAlign: TextAlign.center,
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              borderSide: BorderSide(
                                                color: AppConstants.aquamarine,
                                                width: 0.5,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          inputType: InputType.date,
                                          onSaved: (newValue) {
                                            profileProv.formKey.currentState!
                                                .transformValue('birthdate',
                                                    newValue.toString());
                                          },
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          autofocus: false,
                                          validator: (value) {
                                            if (value == null) {
                                              return 'required'.tr();
                                            } else if (value
                                                .isAfter(DateTime(2015))) {
                                              return "tooYoungError".tr();
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          'gender'.tr(),
                                          maxLines: 2,
                                          style: const TextStyle(
                                              color: AppConstants.textBlueGrey),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      SizedBox(
                                        width: 50.w,
                                        child: FormBuilderRadioGroup<String>(
                                          name: 'gender',
                                          validator:
                                              FormBuilderValidators.required(
                                                  errorText: 'required'.tr()),
                                          decoration: InputDecoration.collapsed(
                                              hintText: 'selectGender'.tr()),
                                          options: [
                                            FormBuilderFieldOption(
                                              value: 'Male',
                                              child: Text('male'.tr()),
                                            ),
                                            FormBuilderFieldOption(
                                              value: 'Female',
                                              child: Text('female'.tr()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 95.w,
                                    height: 0.3,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  width: 95.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                 child: FormBuilderDropdown(
                                     name: 'speciality',validator: FormBuilderValidators.required(errorText: 'required'.tr()),

                                     decoration:  InputDecoration(label: Text('speciality'.tr()),
                                       focusedBorder:const OutlineInputBorder(
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(15)),
                                         borderSide: BorderSide(
                                           color: AppConstants.aquamarine,
                                           width: 0.5,
                                         ),
                                       ),
                                       enabledBorder:const OutlineInputBorder(
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(15)),
                                         borderSide: BorderSide(
                                           color: AppConstants.aquamarine,
                                           width: 0.5,
                                         ),
                                       ),
                                       disabledBorder: InputBorder.none,




                                     ),
                                     onChanged: (value) => profileProv.setSelectedSpecialty(value),
                                     items: profileProv.specialities
                                         .map((e) => DropdownMenuItem(
                                       value: e,
                                         child: Text(
                                             e.getName(context))))
                                         .toList()),
                                ),  Container(

                                  width: 95.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                 child: FormBuilderCheckboxGroup<dynamic>(
                                     name: 'sub-speciality',validator: FormBuilderValidators.required(errorText: 'required'.tr()),

                                     decoration:  InputDecoration(label: Text('subSpeciality'.tr()),
                                       enabled: profileProv.isEditing,
                                       focusedBorder:const OutlineInputBorder(
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(15)),
                                         borderSide: BorderSide(
                                           color: AppConstants.aquamarine,
                                           width: 0.5,
                                         ),
                                       ),
                                       enabledBorder:const OutlineInputBorder(
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(15)),
                                         borderSide: BorderSide(
                                           color: AppConstants.aquamarine,
                                           width: 0.5,
                                         ),
                                       ),
                                       disabledBorder: const OutlineInputBorder(
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(15)),
                                         borderSide: BorderSide(
                                           color: Colors.black,
                                           width: 0.5,
                                         ),
                                       ),
                                       border: const OutlineInputBorder(
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(15)),
                                         borderSide: BorderSide(
                                           color: Colors.red,
                                           width: 0.5,
                                         ),
                                       ),






                                     ),
                                     options: [
                                       ...? profileProv.getSubSpecialties()?.subDisciplines
                                           ?.map((e) => FormBuilderFieldOption(
                                           value: e,
                                           child: Row(mainAxisSize: MainAxisSize.min,
                                             children: [
                                               Text( e.getName(context)),
                                               Tooltip(
                                                 triggerMode: TooltipTriggerMode.tap,
                                                showDuration: const Duration(seconds: 5),
                                                waitDuration: Duration(milliseconds: 100),
                                                   message: e.getDesc(context),
                                                   child:  Icon(Icons.info,size: 20,color: AppConstants.gradiant2,),),
                                             ],
                                           )))
                                     ]
                                          ,

                                 ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 2.h,
                        ),
                        if (profileProv.isEditing)
                          RoundedLoadingButton(
                              controller: profileProv.btnController,
                              animateOnTap: true,
                              resetAfterDuration: true,
                              resetDuration: const Duration(seconds: 3),
                              color: AppConstants.aquamarine,
                              onPressed: () async {
                                if (profileProv.formKey.currentState!
                                    .saveAndValidate()) {
                                  var res =
                                      await profileProv.submitEdit(context);
                                  if (res) {
                                  } else
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('error ${res}')));
                                }
                              },
                              child: Text(
                                "submit".tr(),
                                style: const TextStyle(color: Colors.white),
                              )),
                        SizedBox(
                          height: 15.h,
                        )
                      ],
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
