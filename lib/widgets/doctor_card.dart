import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/views/patient_views/doctor_details/doctor_details_page.dart';


class DoctorCard extends StatefulWidget {
  final Doctor doctor;
  final Function(int i)? fun;
  const DoctorCard({Key? key,required this.doctor, this.fun}) : super(key: key);


  @override
  State<DoctorCard> createState() => _DoctorCardState();


}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    print("isfavorite? ${widget.doctor.isFavorite}");
   var name=widget.doctor.getName(context);
   var speciality= widget.doctor.specialty.getName(context);
   bool isLiked= widget.doctor.isFavorite;
    return GestureDetector(
      onTap: () async {
        var res= await Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetailsPage(doctor:widget.doctor),));
            setState(() {
              widget.doctor.isFavorite;
            });
        },
      child: SizedBox(
        width: 45.w,

        child: Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 1),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LikeButton(
                        onTap: (isLiked) async {
                          print("liked? $isLiked");
                        var res=  await widget.doctor.toggleLike();
                       setState(()   {
                      if(widget.fun!=null) {
                        widget.fun!(widget.doctor.id);
                      }
                        isLiked=  widget.doctor.isFavorite;
                       });
                        return Future.value( widget.doctor.isFavorite);
                        }
                         ,size: 25,
                        isLiked: isLiked,
                      ),
                    //  Text("${widget.doctor.id}, ${widget.doctor.user.id}"),
                    //  Text(widget.doctor.specialty.getName(context)),
                     /* Row(
                        mainAxisSize: MainAxisSize.min,
                        children:  const [
                          Icon(
                            Icons.star,size: 17,
                            color: Colors.yellow,
                          ), SizedBox(width: 2,),
                          Text('3.6',style: TextStyle(fontSize: 12),)
                        ],
                      )*/
                    ],
                  ),
                ),
                if(widget.doctor.user.photo=="")
                CircleAvatar(foregroundImage: AssetImage('assets/images/avatar.png'),radius: 31,backgroundColor: Colors.white),
                if(widget.doctor.user.photo!="")
                  CachedNetworkImage(imageUrl: widget.doctor.user.photo ?? "https://img.freepik.com/premium-vector/avatar-male-doctor-with-black-hair-beard-doctor-with-stethoscope-vector-illustrationxa_276184-32.jpg",
                    imageBuilder: (context, imageProvider) => Hero(
                      tag: widget.doctor.user.id,
                      child: Container(
                        width: 85.0,
                        height: 85.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, progress) =>Center(child: CircularProgressIndicator(value: progress.progress,)),),

                const SizedBox(height: 5,),
                Text(name,overflow: TextOverflow.ellipsis,maxLines: 1, style: const TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold,fontSize: 14, overflow: TextOverflow.ellipsis,),),
                const SizedBox(height: 2,),
                Expanded(child: Text(speciality,softWrap: true,textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Rubik',color: AppConstants.aquamarine, fontSize: 12, overflow: TextOverflow.ellipsis,),maxLines: 3)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
