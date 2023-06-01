import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageNoteFound extends StatelessWidget {
  static const route='pageNotFound';
  const PageNoteFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Column(children: [Text('pageNotFound').tr()],),
    );
  }
}
