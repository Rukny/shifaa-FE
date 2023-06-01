import 'dart:convert';
import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/models/user.dart';
import 'package:shifaa/utils/apiPaths.dart';
import 'package:shifaa/utils/local_storage.dart';
import 'package:shifaa/utils/restService.dart';

class Patient {

  final int id;
  final int status;
  final User user;

  Patient({

    required this.id,
    required this.status,
    required this.user,
  });

  factory Patient.fromRawJson(String str) => Patient.fromJson(json.decode(str));
  factory Patient.fromRawJsonLogin(String str) => Patient.fromJson(json.decode(str)['object']);

  String toRawJson() => json.encode(toJson());

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(

    id: json["id"],
    status: json["status"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {

    "id": id,
    "status": status,
    "user": user.toJson(),
  };

  static login(String email, String password)async{

    var res= await RestApiService.post(ApiPaths.login,{'email':email,'password':password});
    if(res.statusCode == 201 || res.statusCode==200){
      log('login api res ${res.body}');
      if(jsonDecode(res.body)['type']=='patient')
     return Patient.fromRawJsonLogin(res.body);
      if(jsonDecode(res.body)['type']=='doctor')
        return Doctor.fromRawJson(res.body);
    } else {
      log('doLogin res ${res.statusCode} ${res.body}');
       return jsonDecode(res.body)['message'];

    }
  }

  static register(Map<String, dynamic> body) async {
    log('Register');

    var res=await RestApiService.post(ApiPaths.patientsRegister, body );

    if(res.statusCode==201){

    return Patient.fromRawJson(res.body);
    }
      if(res.statusCode>204){
        return res.body;
      }
    }

  static getPatient() async{
    var patient;
    var pid=await LocalStorage.retrieveValue('patientId');
    var uid=await LocalStorage.retrieveValue('userId');
    log('pid is ${pid} uid ${uid}');

    if(pid!=null  ){
      var res=await RestApiService.post(ApiPaths.getPatient, {'patientId':pid});
      log('patient is ${res.body}');
      patient=Patient.fromRawJson(res.body);
      log('got patient in init UserProvider');
     return patient;
    } else {
      log('pid is null');
    }
  }

  static Future patchUser(Map body) async{
    var res=await RestApiService.patch(ApiPaths.patients,body);
    log('patch patient res ${res.statusCode} ${res.body}');

    if(res.statusCode==200 || res.statusCode==201){
      return true;
    }
   else return jsonDecode(res.body)['message'];
  }



}
