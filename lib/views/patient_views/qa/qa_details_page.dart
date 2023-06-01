import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/patient.dart';
import 'package:shifaa/models/question.dart';
import 'package:shifaa/views/patient_views/qa/qa_page.dart';
import 'package:shifaa/views/patient_views/qa/widgets/answer_card.dart';

import 'package:shifaa/widgets/gradient_background.dart';
import 'package:shifaa/widgets/text_field.dart';

class QuestionDetails extends StatelessWidget {
  final Question question;

  const QuestionDetails({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton:context.read<UserProvider>().getCurrentUser() is Patient?null: CircleButton(
        icon: const Icon(
          Icons.add_comment,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onTap: () async {
          var key = GlobalKey<FormBuilderState>();
        var res = await  showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('addAnswerTitle'.tr()),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('cancel'.tr())),    TextButton(
                          onPressed: () async {
                            if(key.currentState!.saveAndValidate()) {

                          //    var res= Question.postAnswer(question,a);
                              Navigator.pop(
                                  context, key.currentState!.value['answer']);
                            }
                          },
                          child: Text('submit'.tr())),
                    ],
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),scrollable: true,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Container(

                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: FormBuilder(
                              key: key,
                              child:
                                  Column(mainAxisSize: MainAxisSize.min, children: [
                                   AppTextField(name: 'title',hintText: 'addAnswerTitle'.tr(),   validators: FormBuilderValidators.required(),padding: 0.0) ,
                               SizedBox(height: 10,),
                               FormBuilderTextField(name: 'desc',
                               decoration: InputDecoration(labelText: 'addAnswer'.tr(),
                                  alignLabelWithHint: true,
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
                                   ),

                               ),

                                minLines: 3,
                               maxLines: 6,
                               maxLength: 250,

                               buildCounter: (context, {required currentLength, required isFocused, maxLength}) => Text('$currentLength/$maxLength'),
                               validator: FormBuilderValidators.required(errorText:  'required'.tr()),)
                              ])),
                        ),
                      ],
                    ),
                  ));
        print('dialog res is ${res}');
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "qa".tr(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GradiantBackGroundWrapper(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 12.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                ),
                child: Card(
                  color: AppConstants.aquamarine,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100.w,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child:
                                            Image.asset('assets/ui/person.png'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'questionTopic'
                                                .tr(args: [question.title]),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            question.getStringDate(context),
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text('since'.tr(args: [
                                            DateTime.now()
                                                .difference(question.createDate)
                                                .inHours
                                                .toString()
                                          ]).toString()),
                                        ],
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          constraints: BoxConstraints(minHeight: 70),
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          width: 100.w,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    question.desc,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  )),

                              ///sub-specialties
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        runAlignment: WrapAlignment.start,
                                        alignment: WrapAlignment.start,
                                        spacing: 5,
                                        direction: Axis.horizontal,
                                        children: [
                                          ...question.subDisciplines.map((e) =>
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 2),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color:
                                                        AppConstants.gradiant1,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    )),
                                                child: Text(e.getName(context)),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        runAlignment: WrapAlignment.start,
                                        alignment: WrapAlignment.start,
                                        spacing: 5,
                                        direction: Axis.horizontal,
                                        children: [
                                          ...question.subDisciplines.map((e) =>
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 2),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color:
                                                        AppConstants.gradiant1,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    )),
                                                child: Text(e.getName(context)),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //  Container(height: 0.5,width: 100.w,color: Colors.black,margin: EdgeInsets.symmetric(vertical: 5),),
                              if (question.links?.isNotEmpty ?? false)
                                ExpansionTile(
                                    title: Text('attachements'.tr()),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    tilePadding: EdgeInsets.zero,
                                    children: [
                                      Row(
                                        children: [
                                          ...?question.links
                                              ?.map((e) => InstaImageViewer(
                                                    child: CachedNetworkImage(
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              'assets/logo.png'),
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  progress) =>
                                                              Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                        value: progress
                                                            .downloaded
                                                            .toDouble(),
                                                      )),
                                                      imageUrl: e.link!,
                                                      height: 85,
                                                      width: 30.w,
                                                    ),
                                                  ))
                                        ],
                                      ),
                                    ])
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ...?question.answers?.map((e) => AnswerCard(answer: e))
            ],
          ),
        ),
      ),
    );
  }
}
