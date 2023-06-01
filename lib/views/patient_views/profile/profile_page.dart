import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/nav_provider.dart';
import 'package:shifaa/controllers/profile_provider.dart';
import 'package:shifaa/widgets/gradient_background.dart';
import 'package:shifaa/widgets/text_field.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradiantBackGroundWrapper(
      bottomColor: AppConstants.darkBlue,

        child: ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
          builder: (context,child) {
            return Consumer<ProfileProvider>(

              builder: (context,prov,child) {

                return SingleChildScrollView(
                  child:   Builder(builder: (context) {
                    if(prov.patient==null) {
                      return Padding(
                        padding:   EdgeInsets.only(top: 50.h),
                        child: const Center(child: CircularProgressIndicator(),),
                      );
                    }
                    else {
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
                              child: Center(child: Text(  'myProfile'.tr(),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 20))),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 30.w,
                              left: 30.w,
                              child:   CircleAvatar(
                                radius: 47,
                                backgroundColor: Colors.transparent,
                                foregroundImage:prov.patient?.user.gender.toLowerCase()=="male"? AssetImage('assets/images/male.png'): AssetImage('assets/images/female.png'),
                              ),
                            ),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                          IconButton.outlined(onPressed: () {
                            prov.toggleEdit();
                          }, icon: const Icon(Icons.edit,)),SizedBox(width: 15,)
                        ],
                        ),
                        SizedBox(height: 3.h,),
                        FormBuilder(
                          enabled: prov.isEditing,
                          initialValue: {
                            'birthday':DateTime.tryParse(prov.patient!.user.birthday),
                            'gender':prov.patient!.user.gender
                          },
                            key: prov.formKey,
                            child: Wrap(
                              runSpacing: 15,
                              children: [
                                AppTextField(
                                  name: 'firstName',
                                  hintText: 'firstName'.tr(),validators: FormBuilderValidators.required(errorText:  'required'.tr()),
                                  padding: 2.w,
                                  value: prov.patient!.user.nameEn.split(' ')[0],
                                ),
                                AppTextField(
                                    name: 'lastName',
                                    hintText: 'lastName'.tr(),
                                    padding: 2.w,
                    value: prov.patient!.user.nameEn.split(' ')[1],
                                    validators: FormBuilderValidators.required(errorText:  'required'.tr())
                                ),
                                AppTextField(
                                    name: 'email',
                                    hintText: 'email'.tr(),
                                    enabled:false,
                                    textInputType: TextInputType.number,
                                    value: prov.patient!.user.email,
                                    padding: 2.w,validators: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText:  'required'.tr()),
                                  FormBuilderValidators.email()

                                ])
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(bottom: 5),
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
                                          inputType: InputType.date,onSaved: (newValue) {
                                            prov.formKey.currentState!.transformValue('birthdate', newValue.toString());
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(bottom: 10),
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
                                        child: FormBuilderRadioGroup(
                                          name: 'gender',
                                          validator: FormBuilderValidators.required(errorText:  'required'.tr()),
                                          decoration: InputDecoration.collapsed(
                                              hintText: 'selectGender'.tr()),
                                          options: [
                                            FormBuilderFieldOption(
                                              value: 'male',
                                              child: Text('male'.tr()),
                                            ),
                                            FormBuilderFieldOption(
                                              value: 'female',
                                              child: Text('female'.tr()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            )),
                        SizedBox(height: 2.h,),
                        if(prov.isEditing)
                        RoundedLoadingButton(
                            controller: prov.btnController,
                            animateOnTap: true,
                            resetAfterDuration: true,
                            resetDuration: const Duration(seconds: 3),
                            color: AppConstants.aquamarine,
                            onPressed: () async {
                              if(prov.formKey.currentState!.saveAndValidate()) {
                                var res= await  prov.submitEdit(   context);
                                if(res){

                                }
                                else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error ${res}')));
                              }
                            },
                            child: Text(
                              "submit".tr(),
                              style: const TextStyle(color: Colors.white),
                            )),
                      SizedBox(height: 15.h,)
                      ],
                    );
                    }
                  },),
                );
              }
            );
          }
        ));
  }
}
