

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/appointment.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/models/patient.dart';

class MyBookingsProvider extends ChangeNotifier{
  List<Appointment> allMyAppointments=[];
  List<Appointment> filteredAppointments=[];

  late final dynamic userType;
  bool loading=true;
  String filterBy='all';

  MyBookingsProvider(BuildContext context){
    init(context);
    userType= context.read<UserProvider>().getCurrentUser();
  }

  void init(BuildContext context)async {
    var user=context.read<UserProvider>().getCurrentUser();
    if(user is Patient) {
      allMyAppointments= await Appointment.getPatientAppointments(user.id);

    }
    else if(user is Doctor)
      {
        allMyAppointments = await Appointment.getDoctorAppointments(user.id);


      }
    loading=false;
    handleAppointments();


  }
  handleAppointments(){
    if(filterBy=='previous')
      {
        filteredAppointments=allMyAppointments.where((element) => element.appointmentState=='previous').toList();
      }
    else if(filterBy=='upcoming')
      {
        filteredAppointments=allMyAppointments.where((element) => element.appointmentState=='upcoming').toList();
      }
    else {
      filteredAppointments=List.from(allMyAppointments);
    }
    notifyListeners();
  }

  setFilter(String s) {
    filterBy=s;
    handleAppointments();

  }

  String getUserName(Appointment e,BuildContext context) {
   if(userType is Doctor) {
     return e.patient!.user.getName(context);
   } else if(userType is Patient) {
     return e.doctor?.getName(context) ?? "--";
   } else {
     return " ";
   }

  }

  void cancelAnAppointment(Appointment appointment,BuildContext context)async {
    var user=context.read<UserProvider>().getCurrentUser();
    showDialog(context: context,barrierDismissible: false, builder: (context) => AppConstants.loadingDialogWidget(),);
  var res= await appointment.cancelAppointment(user);
   if(res is bool && res){
     Navigator.pop(context);
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('appointmentCancelSuccess'.tr())));
     allMyAppointments.remove(appointment);
     filteredAppointments.remove(appointment);
   }
   else if(res is String){
     Navigator.pop(context);
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('appointmentCancelFailed'.tr(args: [res]))));
   }
   notifyListeners();

  }

}