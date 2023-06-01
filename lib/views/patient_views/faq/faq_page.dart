import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/models/faq.dart';
import 'package:shifaa/widgets/gradient_background.dart';

class FaqPage extends StatelessWidget {
    FaqPage({Key? key}) : super(key: key);

  final List<faq> faqs = [
    faq(
        'What should I do to prevent diabetes from getting worst?',
        'ماذا ينبغي علي ان افعل لمنع تفاقم مرض السكري؟',
        'Maintaining your blood sugar levels within the normal or near-normal range is the best way to reduce the risk of complications associated with diabetes. The higher your blood sugar levels, the greater the risks of developing eye, kidney, heart, blood vessel, and nerve diseases.',
        " الحفاظ على مستويات السكر في دمكم ضمن المجال الطبيعي أو الشبه طبيعي هو أفضل وسيلة للحد من خطر الإصابة بالمضاعفات الناجمة عن مرض السكر. كلما ارتفعت مستويات السكر في دمكم، كلما زادت مخاطر الإصابة بأمراض العينين، الكلى، القلب، الأوعية الدموية، والأعصاب."),
    faq(
        'What are the causes of acne formation?',
        'ما هي اسباب تكون حبّ الشباب ؟',
        "Acne begins when oils and dead skin cells clog the skin's pores in affected individuals. If bacteria enter the pores, it can result in swelling, redness, and pus.For most people, acne starts during the teenage years. This is because hormonal changes make the skin oilier after the onset of puberty  ",
        "حب الشباب يبدأ عندما تسد الدهون والجلد الميت مسام الجلد عند المصاب. إذا دخلت البكتيريا في المسام، فقد تكون النتيجة تورم، احمرار وصديد.بالنسبة لمعظم الناس، حب الشباب يبدأ في فترة المراهقة. وذلك لأن التغيرات الهرمونية تجعل الجلد دهني أكثر بعد بدء سن البلوغ."),
    faq("Is it possible to avoid getting obsessive-compulsive disorder (OCD)?", "هل من الممكن تجنب الاصابة بالوسواس القهري؟", "It is not possible to prevent the occurrence of this disorder. However, early diagnosis and treatment can reduce the period of suffering for individuals affected by it.", "لا يمكن منع الإصابة بهذا المرض. لكن مع هذا، فإن من شأن التشخيص والعلاج المبكرين لهذا المرض أن يحدّا من فترة معاناة الشخص المصاب منه.")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('faq').tr(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: GradiantBackGroundWrapper(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Image.asset('assets/ui/faq.png'),
            const SizedBox(height: 15,),
            Container(
              height: 70.h,
              width: 95.w,
              padding: EdgeInsets.zero,

              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children: faqs.map((e) => Card(
                  child: ExpansionTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    title:   Text(
                      e.getTitle(context),
                      style:const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Rubik'),
                    ),
                    //  leading: const Icon(CupertinoIcons.question,color: AppConstants.gradiant1,),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                         e.getAnswer(context),
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                )).toList(),
              ),
            )
          ],
        ),
      )),
    );
  }
}
