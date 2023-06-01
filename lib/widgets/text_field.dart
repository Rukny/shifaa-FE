

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
 import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';

class AppTextField extends StatelessWidget {
  final String name;
  final dynamic  validators;
  final bool  obscureText;
  final TextInputType textInputType;
  final   hintText;
  final padding;
  final height;
  final String? value;
  final formatter;
  final enabled;
 const  AppTextField({Key? key, required this.name, this.validators, this.obscureText=false,this.textInputType=TextInputType.text,this.hintText,this.padding,this.height,this.value,this.formatter, this.enabled=true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Container(
      height: height ?? 54,
      padding: EdgeInsets.symmetric(horizontal: padding ?? 10.w),
      child: FormBuilderTextField(
        name: name,
        obscureText: obscureText,
        enabled: enabled,
        initialValue: value,
        inputFormatters:formatter==null?null: [formatter],

        decoration:   InputDecoration(

          labelText: hintText,
            hintStyle:const TextStyle(color: Colors.grey),
            disabledBorder: InputBorder.none,
            focusedBorder:const OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color: AppConstants.aquamarine,
                width: 0.5,
              ),
            ),
            enabledBorder:  OutlineInputBorder(
              borderRadius:
              const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color: Colors.blueGrey.shade50,
                width: 0.5,
              ),
            )),
        validator: validators,
      ),
    );
  }
}
