import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppConstants {
  static const aquamarine = Color(0xff5ED2B7);
  static const green = Color(0xff0EBE7F);
  static const gradiant1 = Color(0xFF61CEFF);
  static const gradiant2 = Color(0xff0EBE7E);
  static const textBlueGrey = Color(0xff677294);
  static const darkBlue = Color(0xff5DC4CA);

  static final formatDate = DateFormat("yyyy-MM-dd hh:mm:ss a");

  static loadingDialogWidget() => const AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        ),
      );
}
