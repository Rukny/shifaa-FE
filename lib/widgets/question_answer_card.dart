import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/models/answer.dart';
import 'package:shifaa/models/question.dart';
import 'package:shifaa/views/patient_views/qa/qa_details_page.dart';


class QuestionAnswerCard extends StatelessWidget {
  final Question question;

  const QuestionAnswerCard({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250,
        child: GestureDetector(
          onTap: () {


            log('onpress question ${question}');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionDetails(question: question),
                ));
          },
          child: Card(
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          question.title,
                          style: const TextStyle(
                            color: AppConstants.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /*FutureBuilder<List<Answer>?>(
                       future: question. getAnswers() ,
                         builder: (_, snapshot){
                         if(snapshot.hasData && snapshot.data!=null)
                           {



                           }
                         else {
                           return const Center(child: CircularProgressIndicator(),);
                         }

                       },)*/
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  question.desc,
                                  style: const TextStyle(
                                      color: Colors.blueGrey, fontSize: 16),
                                  softWrap: false,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              if (question.answers!.length > 1)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('answersCount'.tr(args: [
                                      question.answers!.length.toString()
                                    ])),
                                  ],
                                )
                              /*if(snapshot.data!.length>1)
                          Text('answersCount'.tr(args: [snapshot.data!.length.toString()]),)
                     */
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
