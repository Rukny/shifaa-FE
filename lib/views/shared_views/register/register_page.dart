import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/register_provider.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/widgets/gradient_background.dart';
import 'package:shifaa/widgets/text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<RegisterProvider>(
      create: (context) => RegisterProvider(),
      builder: (context, child) => Consumer2<RegisterProvider,UserProvider>(
        builder: (_, regProv,userProv, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      children: [
                        Text(
                          'welcomeRegister'.tr(),
                          locale: context.locale,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rubik',
                              color: AppConstants.green),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    FormBuilder(
                        key: regProv.formKey,
                        child: Wrap(
                          runSpacing: 15,
                          children: [
                            AppTextField(
                              name: 'firstName',

                              hintText: 'firstName'.tr(),validators: FormBuilderValidators.required(errorText:  'required'.tr()),
                              padding: 2.w,
                            ),
                            AppTextField(
                              name: 'lastName',

                              hintText: 'lastName'.tr(),
                              padding: 2.w,
                                 validators: FormBuilderValidators.required(errorText:  'required'.tr())
                            ),
                            AppTextField(
                              name: 'email',
                                formatter: FilteringTextInputFormatter.deny(' '),
                              hintText: 'email'.tr(),
                              textInputType: TextInputType.number,
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
                                      name: 'birthdate',
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
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      autofocus: false,
                                      lastDate: DateTime.now(),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'required'.tr();
                                        } else if (value
                                            .isAfter(DateTime(2005))) {
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
                                  Container(
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
                            AppTextField(
                              name: 'password',
                              formatter: FilteringTextInputFormatter.deny(' '),
                              textInputType: TextInputType.visiblePassword,
                              padding: 5.w,
                              hintText: "password".tr(),

                              validators: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'require'.tr()),
                                FormBuilderValidators.minLength(6,
                                    errorText: 'passwordTooShort'.tr())
                              ]),
                            ),
                            // AppTextField(
                            //   name: 'confirmPassword',
                            //   textInputType: TextInputType.visiblePassword,
                            //   padding: 5.w,
                            //   hintText: "confirmPassword".tr(),
                            //   validators: FormBuilderValidators.compose([
                            //     FormBuilderValidators.required(
                            //         errorText: 'require'.tr()),
                            //     FormBuilderValidators.equal(
                            //         prov.formKey.currentState
                            //             ?.value['password'] ?? " ",
                            //         errorText: 'passwordNotEqual'.tr())
                            //   ]),
                            // )
                          ],
                        )),
                    SizedBox(height: 5.h,),
                    RoundedLoadingButton(
                        controller: regProv.btnController,
                        animateOnTap: true,
                        resetAfterDuration: true,
                        resetDuration: const Duration(seconds: 3),
                        color: AppConstants.aquamarine,
                        onPressed: () async {
                          if(regProv.formKey.currentState!.saveAndValidate()) {
                          var res= await  regProv.submit();
                          if(res is Patient){
                            regProv.btnController.success();
                           await context.read<UserProvider>().setPatient(res);
                            Future.delayed(const Duration(seconds: 1)).whenComplete(() => Navigator.pushNamedAndRemoveUntil(context, 'home',(route) => false,));
                          }
                          else if(res is Doctor){
                            Future.delayed(const Duration(seconds: 1)).whenComplete(() => Navigator.pushReplacementNamed(context, 'doctorHome'));
                          }
                          else if(res is String) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error ${res}')));
                          }
                          }
                        },
                        child: Text(
                          "submit".tr(),
                          style: const TextStyle(color: Colors.white),
                        )),
                    SizedBox(height: 2.h,),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      ),
      ),
    );
  }
}
