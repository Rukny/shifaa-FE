import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/qa_provider.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/views/patient_views/qa/widgets/qa_box.dart';



import 'add_question_page.dart';

class QaPage extends StatelessWidget {
  const QaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QaProvider>(
      create: (_) => QaProvider(context),
      builder: (_, child) => Consumer<QaProvider>(
        builder: (_, prov, child) {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 30.h,
                    margin: EdgeInsets.only(bottom: 1.h),
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
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                        shape: BoxShape.rectangle),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(  'qa'.tr(),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 20)),),
                      SizedBox(
                        height: 4.h,
                      ),
                      prov.specialities == null
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: AppConstants.gradiant1,
                            ))
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: CustomDropdown(
                                hintText: 'selectSpecialty'.tr(),
                                borderSide: const BorderSide(
                                    color: AppConstants.aquamarine),
                                items: [
                                  ...prov.specialities!
                                      .map((e) => e.getName(context))
                                ],
                                onChanged: (p0) =>
                                    prov.handleSearch(p0, context),
                                controller: prov.textEditingController,
                                selectedStyle: const TextStyle(
                                    color: AppConstants.gradiant2),
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'sortBy'.tr(),
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(color: Colors.white),
                            ),

                            ///filters
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => prov.setSort('all'),
                                    child: Card(
                                      shadowColor: Colors.white,
                                      color: prov.selectedSort == 'all'
                                          ? AppConstants.green
                                          : Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Container(
                                          width: 85,
                                          padding: const EdgeInsets.all(15),
                                          child: Center(
                                            child: Text(
                                              "all".tr(),
                                              style: TextStyle(
                                                  color:
                                                      prov.selectedSort == 'all'
                                                          ? Colors.white
                                                          : AppConstants
                                                              .aquamarine),
                                            ),
                                          )),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => prov.setSort('recent'),
                                    child: Card(
                                      shadowColor: Colors.white,
                                      color: prov.selectedSort == 'recent'
                                          ? AppConstants.green
                                          : Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Container(
                                          width: 85,
                                          padding: const EdgeInsets.all(15),
                                          child: Center(
                                            child: Text(
                                              "recent".tr(),
                                              style: TextStyle(
                                                  color: prov.selectedSort ==
                                                          'recent'
                                                      ? Colors.white
                                                      : AppConstants
                                                          .aquamarine),
                                            ),
                                          )),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => prov.setSort('answerNum'),
                                    child: Card(
                                      shadowColor: Colors.white,
                                      color: prov.selectedSort == 'answerNum'
                                          ? AppConstants.green
                                          : Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          child: Center(
                                            child: Text(
                                              "answerNum".tr(),
                                              maxLines: 2,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: prov.selectedSort ==
                                                          'answerNum'
                                                      ? Colors.white
                                                      : AppConstants
                                                          .aquamarine),
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if(context.read<UserProvider>().doctor==null)
                  TextButton(
                      onPressed: () async {
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddQuestionPage()));
                        if (res!=null && res) {
                        await  prov.init();
                          prov.setSort('recent');
                        }
                      },
                      child: Text('postQuestion'.tr())),
                  const SizedBox(
                    height: 5,
                  ),
                  if (prov.selectedSpecialty != null)
                    TextButton(
                        onPressed: () => prov.clearSpeciality(),
                        child: Text('clear'.tr())),
                  if (prov.filteredQuestions == null)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (prov.filteredQuestions != null)
                    Flexible(
                      fit: FlexFit.loose,
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 15, right: 5, left: 5),
                        shrinkWrap: true,
                        children: prov.filteredQuestions!
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: QaBox(question: e),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
              /*        Positioned(
         right: 25,
              child: Container(
                  padding: EdgeInsets.all(5),

                  decoration: BoxDecoration(color: AppConstants.darkBlue,

                      shape: BoxShape.circle),

                  child: IconButton(
                      onPressed: () async{
                        await  Navigator.push(context, MaterialPageRoute(builder:(context) => AddQuestionPage()));
                        prov.init();
                      },

                      icon: Icon(FontAwesomeIcons.plus,color: Colors.white,)))),*/
            ],
          );
        },
      ),
    );
  }
}
