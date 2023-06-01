



import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/controllers/near_me_provider.dart';

class NearMePage extends StatelessWidget {
  const NearMePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NearMeProvider>(
      create:(context) => NearMeProvider(),
      builder: (context, child) => Consumer<NearMeProvider>(builder: (_, prov, child) {
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,

                title: Text('centersNearby'.tr())),
              extendBodyBehindAppBar: true,

              floatingActionButtonLocation:  FloatingActionButtonLocation.startFloat,
           body: SafeArea(
          child: GoogleMap(initialCameraPosition: prov.cameraPosition,
            myLocationEnabled: true,myLocationButtonEnabled: true,
            buildingsEnabled: true,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapToolbarEnabled: false,
            onMapCreated: (controller) => prov.onMapReady(controller),),
        ),);
      },),
    );
  }
}
