


import 'dart:convert';

class MedicalCenter {
  final String? createDate;
  final int? id;
  final String? nameAr;
  final String? nameEn;
  final String? descAr;
  final String? descEn;
  final String? phone;
  final String? email;
  final String? addressAr;
  final String? addressEn;
  final String? map;
  final int? status;

  MedicalCenter({
    this.createDate,
    this.id,
    this.nameAr,
    this.nameEn,
    this.descAr,
    this.descEn,
    this.phone,
    this.email,
    this.addressAr,
    this.addressEn,
    this.map,
    this.status,
  });

  factory MedicalCenter.fromRawJson(String str) => MedicalCenter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MedicalCenter.fromJson(Map<String, dynamic> json) => MedicalCenter(
    createDate: json["createDate"],
    id: json["id"],
    nameAr: json["nameAr"],
    nameEn: json["nameEn"],
    descAr: json["descAr"],
    descEn: json["descEn"],
    phone: json["phone"],
    email: json["email"],
    addressAr: json["addressAr"],
    addressEn: json["addressEn"],
    map: json["map"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "createDate": createDate,
    "id": id,
    "nameAr": nameAr,
    "nameEn": nameEn,
    "descAr": descAr,
    "descEn": descEn,
    "phone": phone,
    "email": email,
    "addressAr": addressAr,
    "addressEn": addressEn,
    "map": map,
    "status": status,
  };
}