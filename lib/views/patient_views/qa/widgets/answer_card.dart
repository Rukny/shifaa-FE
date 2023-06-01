import 'package:animated_react_button/animated_react_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/answer.dart';
import 'package:shifaa/models/patient.dart';

class AnswerCard extends StatelessWidget {
  final Answer answer;

  const AnswerCard({Key? key, required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  foregroundImage:
                      CachedNetworkImageProvider(answer.doctor!.user.photo!),
                ),const SizedBox(width: 5,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer.doctor!.getName(context),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Rubik'),
                    ),
                          Text(
                      answer.doctor!.specialty.getName(context),
                      style: const TextStyle(
                          fontSize: 12, fontFamily: 'Rubik'),
                    ),


                  ],
                ),
                const Spacer(),
                Row(

                  mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    Text(DateFormat('dd/MM/yyyy \n \t hh:mm a',context.locale.languageCode).format(answer.createDate)),
                  ],
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
              child: Row(children: [
                Text(answer.desc)
              ],),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
              child: Row(children: [
                Row(mainAxisSize: MainAxisSize.min,
                children: [ AbsorbPointer(
                 absorbing: context.read<UserProvider>().getCurrentUser() is Patient ,
                  child: AnimatedReactButton(
                    reactColor: Colors.lightBlue,
                    defaultColor:context.read<UserProvider>().getCurrentUser() is Patient? Colors.lightBlue:Colors.grey,
                    defaultIcon: FontAwesomeIcons.thumbsUp,
                    showSplash: true,

                    onPressed:  (){

                    },
                  ),
                ),const SizedBox(width: 5,),Text(answer.likes.toString(),locale: context.locale,)],)
              ],),
            )
          ],
        ),
      ),
    );
  }
}
