import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/utils/local_storage.dart';
import 'package:shifaa/widgets/text_field.dart';

class LoginProvider extends ChangeNotifier {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();


  LoginProvider(){
    FlutterSecureStorage().readAll().then((value) => print('all storage ${value}'));
  }
  showResetPasswordModal(BuildContext context) async {
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    final RoundedLoadingButtonController _btnController =
        RoundedLoadingButtonController();

    var res = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) {


        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 40.w,
                  height: 5,
                  decoration: BoxDecoration(
                      color: const Color(0xffC4C4C4),
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'forgotPassword'.tr(),
                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'forgotPasswordBody'.tr(),
                style: const TextStyle(
                    fontFamily: 'Rubik', fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(
                height: 30,
              ),
              FormBuilder(
                key: formKey,
                child: AppTextField(
                  name: 'id',
                  hintText: 'idOrNumber'.tr(),
                  padding: 1.w,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              RoundedLoadingButton(
                onPressed: () {},
                color: AppConstants.aquamarine,
                controller: _btnController,
                child: Text(
                  'submit'.tr(),
                  style: TextStyle(fontFamily: 'Rubik', color: Colors.white),
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        );
      },
    );
  }

  Login(BuildContext ctx) async {
    String email = formKey.currentState!.value['id'];

    String password = formKey.currentState!.value['password'];
    var res = await ctx.read<UserProvider>().doLogin(email, password);
    log('Login res ${res}');
    if (res is Patient) {

      log('login res is patient');

      Navigator.pushReplacementNamed(ctx, 'home');

    }
    else if (res is Doctor){
      log('login res is Doctor');
      Navigator.pushReplacementNamed(ctx, 'doctorHome');

    }
    else if (res is String) {
      log('login failed $res');
      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('error: ${res}')));
      btnController.error();
      Future.delayed(Duration(seconds: 2))
          .whenComplete(() => btnController.reset());
    }
  }
}
