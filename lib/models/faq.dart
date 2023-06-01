


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class faq {

  String titleEn;
  String titleAr;
  String answerEn;
  String answerAr;

  faq(this.titleEn, this.titleAr, this.answerEn, this.answerAr);

  getTitle(BuildContext context){
  return  context.locale.languageCode=="en"?titleEn:titleAr;
  }
  getAnswer(BuildContext context){
  return  context.locale.languageCode=="en"?answerEn:answerAr;
  }
}