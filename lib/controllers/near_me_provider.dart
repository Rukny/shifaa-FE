


import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class NearMeProvider extends ChangeNotifier{
 late  final GoogleMapController googleMapController;
    CameraPosition cameraPosition=const CameraPosition(target: LatLng( 31.9901001,35.8791847),zoom: 13);
 var locationService;

 NearMeProvider(){
    requestPerms();
    }

    void requestPerms()async{
    var isEnabled=await Permission.locationWhenInUse.isGranted;
    if(isEnabled){
      log('already has access to location, skipping.');
      locationService = Location();
      await locationService.requestService();
    }
    else {
      await Permission.locationWhenInUse.request();
      notifyListeners();
    }
    }

  onMapReady(GoogleMapController controller) {
    googleMapController=controller;
    notifyListeners();
    
  }

 void  currentLocation() async {

   var currentLocation;

   try {
     currentLocation = await locationService.getLocation();
   } on Exception {
     currentLocation = null;
   }

   googleMapController.animateCamera(CameraUpdate.newCameraPosition(
     CameraPosition(
       bearing: 0,
       target: LatLng(currentLocation.latitude, currentLocation.longitude),
       zoom: 17.0,
     ),
   ));
 }


}