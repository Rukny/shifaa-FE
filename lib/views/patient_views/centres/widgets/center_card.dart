

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/models/centre.dart';
import 'package:shifaa/views/patient_views/centre_details/center_details_page.dart';

class CenterCard extends StatelessWidget {
  final Centre centre;
  const CenterCard({Key? key,required this.centre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return     GestureDetector(
      onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CenterDetailsPage(centre: centre),));
      },
      child: Card(elevation: 5,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Container(

            width: 90.w,

            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        centre.getName(context),
                        style: TextStyle(
                            color: AppConstants.aquamarine,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
        /*            Row(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        Text(
                          '${1.w.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const     SizedBox(
                          width: 5,
                        ),
                        const     Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),

                      ],
                    ),*/

                  ],
                ),
                const SizedBox(height: 5,),
                Text(centre.getAddress(context))
              ],
            )),
      ),
    );
  }
}
