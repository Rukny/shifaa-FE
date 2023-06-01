




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';

class GradiantBackGroundWrapper extends StatelessWidget {
  final Widget child;
  final Color? topColor;
  final Color? bottomColor;
  const GradiantBackGroundWrapper({Key? key,required this.child,this.topColor,this.bottomColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Container(
      height: 100.h,
      width: 100.w,
      child: Stack(
        children: [
          Column(

            children: [

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    height: 300,
                    width: 300,
                    decoration:   BoxDecoration(

                      gradient: RadialGradient(
                        center: const Alignment(-1, -0.6), // near the top right
                        radius: 0.7,

                        colors: <Color>[
                          topColor?.withOpacity(0.1) ?? AppConstants.gradiant1.withOpacity(0.1),
                          Colors.white.withOpacity(0.4),

                          // blue sky
                        ],
                      ),
                    )),
              ),
              const Spacer(),
              Align(alignment: Alignment.bottomRight,
                child:       Container(
                    height: 300,
                    width: 300,
                    decoration:   BoxDecoration(

                      gradient: RadialGradient(
                        center: const Alignment(0.6, 0.6), // near the top right
                        radius: 0.4,

                        colors: <Color>[
                          bottomColor?.withOpacity(0.1) ?? AppConstants.gradiant2.withOpacity(0.1),
                          Colors.white.withOpacity(0.4),

                          // blue sky
                        ],
                      ),
                    )),)
            ],
          ),
          child
        ],
      ),
    );
  }
}
