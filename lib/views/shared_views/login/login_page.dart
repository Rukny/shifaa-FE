import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
 import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/login_provider.dart';
import 'package:shifaa/widgets/gradient_background.dart';
import 'package:shifaa/widgets/text_field.dart';

class LoginPage extends StatelessWidget {
  static const route = 'login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : true,

      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<LoginProvider>(
        create: (context) => LoginProvider(),
        builder: (_, child) => Consumer<LoginProvider>(
          builder: (context, prov, child) {
            return ListView(

              children: [
                Container(
                  height: 10.h,

                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                          context.locale.languageCode.toLowerCase()=="en"?context.setLocale(Locale('ar')):context.setLocale(Locale('en'));

                          },
                          child: Text(handleLocale(context))),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 30.h,
                      alignment: Alignment.center,
                    ),
                    const Text(
                      "welcomeBack",
                      style: TextStyle(
                          color: AppConstants.aquamarine, fontSize: 18),
                    ).tr(),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
                FormBuilder(
                    key: prov.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextField(
                          name: 'id',
                          hintText: "idOrNumber".tr(),

                          formatter: FilteringTextInputFormatter.deny(' '),
                          validators:FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: 'emailRequired'.tr()),
                            FormBuilderValidators.email(errorText: 'emailMalformed'.tr())

                          ]),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        AppTextField(
                          name: 'password',
                          hintText: "password".tr(),
                          formatter: FilteringTextInputFormatter.deny(' '),
                          validators: (String? val){
                            if(val==null)
                              {
                                return "fieldRequired".tr();

                              }
                            else {
                              if(val.length<4) {
                                return 'invalidPassword'.tr();
                              }
                            }
                          },
                          obscureText: true,
                          textInputType: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        // Text(
                        //   "Or".tr(),
                        //   style: const TextStyle(
                        //       color: AppConstants.aquamarine, fontSize: 16),
                        // ),
                        SizedBox(
                          height: 5.h,
                        ),
                        RoundedLoadingButton(
                            controller: prov.btnController,
                            animateOnTap: true,
                            resetAfterDuration: true,
                            resetDuration: const Duration(seconds: 3),
                            color: AppConstants.aquamarine,
                            onPressed: () {
                              if(prov.formKey.currentState!.saveAndValidate())
                              prov.Login(   context);
                            },
                            child: Text(
                              "submit".tr(),
                              style: const TextStyle(color: Colors.white),
                            )),

                        SizedBox(
                          height: 1.h,
                        ),
                        TextButton(
                            onPressed: () => prov.showResetPasswordModal(context),
                            child: Text(
                              'forgotPassword'.tr(),
                              style: const TextStyle(
                                  color: AppConstants.green, fontSize: 12),
                            )),

                        Align(alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () async{
                              Navigator.pushNamed(context, 'register');
                            },
                            child: Text('noAccountRegister'.tr(),style: TextStyle(color: AppConstants.green),),

                          ),)
                      ],
                    )),
              ],
            );
          },
        ),
      ),
    );
  }

  String handleLocale(BuildContext ctx) {
    return ctx.locale.languageCode.toLowerCase()=='en'?'عربي':'English';
  }
}
