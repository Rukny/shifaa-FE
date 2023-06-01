


import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/models/question.dart';
import 'package:shifaa/views/patient_views/qa/qa_details_page.dart';

class QaBox extends StatelessWidget {
  final Question question;
  const QaBox({
    super.key,
   required this.question
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionDetails(question: question),)),
      child: SizedBox(

        width: 95.w,
        child: Card(

          color: AppConstants.green,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(

                width: 100.w,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff64BECD),
                      Color(0xff5BC7CA),
                      Color(0xff50D2C5),
                      Color(0xff49DAC2),
                      Color(0xff46DDC0),
                    ],
                  ),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Image.asset(
                                  question.patient.user.gender=="male"?'assets/ui/person.png':'assets/ui/female.png'),
                            ),SizedBox(width: 10,),
                            Column(mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row( mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text('questionTopic'.tr(args: [question.title],),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                  ),
                                ],
                              ), Text(question.getStringDate(context),style: const TextStyle(color: Colors.white,fontSize: 14),),

                                 if( question.createDate.difference(DateTime.now()).inMinutes<60)
                                   Text('sinceMinutes'.tr(args: [ question.createDate.difference(DateTime.now()).inHours.toString()]),style: TextStyle(fontSize: 13)),

                                if(DateTime.now().difference(question.createDate).inHours>1 && DateTime.now().difference(question.createDate).inHours<48)
                                 Text('since'.tr(args: [ DateTime.now().difference(question.createDate).inHours.toString()]),style: TextStyle(fontSize: 13)),
                                 if(DateTime.now().difference(question.createDate).inHours>48)
                                 Text('sinceDays'.tr(args: [ DateTime.now().difference(question.createDate).inDays.toString()]),style: TextStyle(fontSize: 13)),


                              ],)
                          ]),
                    ),

                  ],
                ),
              ),
              Container(
                  constraints: BoxConstraints(minHeight: 70),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
                  width: 100.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(question.desc,maxLines: 3,overflow: TextOverflow.ellipsis,softWrap: true, ),
                      if(question.answers!.isNotEmpty)
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                      child:                         Text('answerCount'.tr(args: [question.answers!.length.toString()])),
                          ),
                     if(question.answers!.isEmpty)
                       Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                         child:                         Text(''),
                       ),
                   ///sub-specialties
                   /*   Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(children: [

                          Expanded(

                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.spaceAround,
alignment: WrapAlignment.spaceEvenly,
                              direction: Axis.horizontal,
                              children: [
                                ...question.subDisciplines.map((e) => ChoiceChip(label: Text(e.getName(context)), selected: false))  ],),
                          )
                        ],),
                      )*/
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}