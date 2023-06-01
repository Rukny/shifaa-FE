import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/speciality.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'package:shifaa/utils/local_storage.dart';
import 'package:shifaa/utils/restService.dart';
import 'package:shifaa/widgets/gradient_background.dart';
import 'package:collection/collection.dart';
class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({Key? key}) : super(key: key);

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  List<Specialty>? specialties;

  @override
  initState() {
    super.initState();
    getSpecialties();
  }

  final formkey = GlobalKey<FormBuilderState>();
  String? body;
  String? title;
  Specialty? specialty;
  bool hideName = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'AddQuestion'.tr(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: FormBuilder(
          key: formkey,
          initialValue: {'images': []},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: 30.h,
                    margin: EdgeInsets.only(bottom: 3.h),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff64BECD),
                            Color(0xff5BC7CA),
                            Color(0xff50D2C5),
                            Color(0xff49DAC2),
                            Color(0xff46DDC0),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                  ),
                  Positioned(
                    top: 12.h,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'hello'.tr(args: [
                                  context
                                      .read<UserProvider>()
                                      .patient!
                                      .user
                                      .getName(context)
                                ]),
                                style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              Text(
                                'askYourQuestion'.tr(),
                                style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            ],
                          ),
                          const CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.transparent,
                            foregroundImage:
                                AssetImage('assets/images/doctors2.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10.w,
                    left: 10.w,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5),
                        child: FormBuilderDropdown<Specialty>(
                            initialValue: specialty,
                            name: 'specialty',
                            onChanged: (value) {
                              specialty = value;
                            },
                            validator: (value) =>
                                value == null ? 'required'.tr() : null,
                            decoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                hintText: 'selectSpecialty'.tr(),
                                errorStyle: const TextStyle(color: Colors.red)),
                            items: [
                              ...?specialties?.map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.getName(context)),
                                  ))
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: FormBuilderTextField(
                        name: 'title',
                        maxLines: 1,
                        validator: (value) {
                          if (value == null) {
                            return "emptyTitle".tr();
                          } else if (value.length >= 30) {
                            return "tooLongTitle".tr();
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'describeTitle'.tr(),
                            alignLabelWithHint: true,
                            labelText: 'titleLabel'.tr(),
                            counter: Text('${title?.length ?? 0}/30'),
                            border: InputBorder.none),
                      ),
                    )),
                    Card(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: FormBuilderTextField(
                        name: 'desc',
                        maxLines: 6,
                        maxLength: 500,
                        validator: (value) {
                          if (value == null) {
                            return "emptyDesc".tr();
                          } else if (value.length >= 500) {
                            return "tooLongDesc".tr();
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            body = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'describeQuestion'.tr(),
                            alignLabelWithHint: true,
                            labelText: 'questionLabel'.tr(),
                            counter: Text('${body?.length ?? 0}/500'),
                            border: InputBorder.none),
                      ),
                    )),
                    const SizedBox(
                      height: 25,
                    ),
                    FormBuilderImagePicker(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: "images",

                      loadingWidget: (context) => CircularProgressIndicator(),
                      maxImages: 3,
                      validator: (value) {
                        log('in validator');
                        if (value == null) {
                          return null;
                        } else {
                          log('in else');
                     var res=   value.firstWhereOrNull((element) => File(element.path).lengthSync()/1000>10000);
                              if(res!=null){
                                var file=File(res.path);
                                log('file length is ${file.lengthSync()}');
                                return "${basename(file.path)} is too large, 10MB max";
                              }
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "Attachment".tr()),
                    ),
                    /*         FormBuilderRadioGroup(
                        validator: (value) =>
                            value == null ? 'required'.tr() : null,
                        decoration: InputDecoration(
                          labelText: 'anonQuestion'.tr(),
                          border: InputBorder.none,
                        ),
                        name: 'anon',
                        options: [
                          FormBuilderFieldOption(
                              child: Text('no'.tr()), value: false),
                          FormBuilderFieldOption(
                              child: Text('yes'.tr()), value: true),
                        ]),*/
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> body = {};

                    if (formkey.currentState!.saveAndValidate()) {
                      body['patientId'] = 1;
                      body['title'] = formkey.currentState!.value['title'];
                      body['desc'] = formkey.currentState!.value['desc'];
                      body['anon'] = formkey.currentState!.value['anon'];
                      body['date']=DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now());
                      body['specialtyId'] =
                          formkey.currentState!.value['specialty'].id;

                      if (formkey.currentState!.value['images'] != null) {
                        loadingDialog(context);
                        var upRes = await doUpload();
                        Navigator.pop(context);
                        body['links'] = upRes;
                        log('body is ${body}');
                        var submitRes = await doSubmit(body);
                        if (submitRes is bool) {
                          await ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(' success'.tr())));

                          Navigator.pop(context, true);
                          //   Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('error ${submitRes}')));
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('error').tr()));
                    }
                  },
                  child: Text('submit'.tr()))
            ],
          ),
        ),
      ),
    );
  }

  loadingDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
              title: Text('uploading'.tr()),
              content: Row(
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            ));
  }

  doSubmit(Map body) async {
    var res = await RestApiService.post(ApiPaths.postQuestion, body);
    if (res.statusCode == 201) {
      return true;
    } else {
      log('upload res is ${res.statusCode} ${res.body}');
    }
  }

  doUpload() async {
    List files = formkey.currentState!.value['images'];
    var pid = await LocalStorage.retrieveValue('patientId');
    log('doUpload patientId ${pid}');
    var res = await Future.wait(files.map((element) async {
      ///todo use real user id instead of 1
      var ref = FirebaseStorage.instance.ref('patients/$pid/${element.name}');
      var res = await ref.putFile(
        File(
          element.path!,
        ),
      );
      var string = await res.ref.getDownloadURL();
      return {'name': element.name, 'link': string};
    }));
    log('done uploading ${res}');
    return res;
  }

  void getSpecialties() async {
    log('getting specialties');
    var res = await Specialty.getSpecialities();
    setState(() {
      specialties = res;
    });
  }
}
