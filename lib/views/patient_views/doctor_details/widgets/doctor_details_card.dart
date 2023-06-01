

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:like_button/like_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/models/doctor.dart';

class DoctorDetailsCard extends StatefulWidget {
  final Doctor doctor;
  const DoctorDetailsCard({Key? key,required this.doctor}) : super(key: key);

  @override
  State<DoctorDetailsCard> createState() => _DoctorDetailsCardState();
}

class _DoctorDetailsCardState extends State<DoctorDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.doctor.user.photo ?? "https://img.freepik.com/premium-vector/avatar-male-doctor-with-black-hair-beard-doctor-with-stethoscope-vector-illustrationxa_276184-32.jpg" ,
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(8)),
                    child: Hero(
                      tag: widget.doctor.user.id,
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        height: 92,
                        width: 87,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                ),
                const SizedBox(width: 10,),
                Column(mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),

                    Text(widget.doctor.getName(context),maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,fontFamily: 'Rubik'),),
                    const SizedBox(height: 15,),
                    Text(widget.doctor.specialty.getName(context)),
                    const SizedBox(height: 10,),

            /*        RatingStars(valueLabelVisibility: false,maxValue: 4.0,starCount: 4,
                      value: Random(DateTime.now().microsecondsSinceEpoch).nextDouble(),)*/
                  ],),
                const Spacer(),
                LikeButton(
                    isLiked: widget.doctor.isFavorite,
                    size: 28,
                    onTap: (isLiked) async {
                      print("liked? $isLiked");
                      var res=  await widget.doctor.toggleLike();
                      setState(()   {


                        isLiked=  widget.doctor.isFavorite;
                      });
                      return Future.value( widget.doctor.isFavorite);
                    }
                ),
              ],
            ),
            const SizedBox(height: 25,),
            Text("doctorDetails".tr(),style: const TextStyle(fontFamily: 'Rubik',fontSize: 16,fontWeight: FontWeight.bold,color: AppConstants.green),),
            const SizedBox(height: 5,),
            Text(widget.doctor.getDesc(context),maxLines: 5,overflow:TextOverflow.ellipsis,style: const TextStyle(color: AppConstants.textBlueGrey,fontFamily: 'Rubik',)),
            Container(width: 95.w,height: 1,margin: const EdgeInsets.symmetric(vertical: 5),color: AppConstants.textBlueGrey.withOpacity(0.2),)
          ],
        ),
      ),
    );
  }
}
