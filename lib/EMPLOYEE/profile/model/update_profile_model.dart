// To parse this JSON data, do
//
//     final staffProfileDataModel = staffProfileDataModelFromJson(jsonString);

import 'dart:convert';

StaffProfileDataModel staffProfileDataModelFromJson(String str) => StaffProfileDataModel.fromJson(json.decode(str));

String staffProfileDataModelToJson(StaffProfileDataModel data) => json.encode(data.toJson());

class StaffProfileDataModel {
  final bool? status;
  final String? message;
  final int? average;
  final Ratelist? ratelist;
  final Data? data;

  StaffProfileDataModel({
    this.status,
    this.message,
    this.average,
    this.ratelist,
    this.data,
  });

  factory StaffProfileDataModel.fromJson(Map<String, dynamic> json) => StaffProfileDataModel(
    status: json["status"],
    message: json["message"],
    average: json["average"] == null ? null : int.parse(json["average"].toString()),
    ratelist: json["ratelist"] == null ? null : Ratelist.fromJson(json["ratelist"]),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "average": average,
    "ratelist": ratelist?.toJson(),
    "data": data?.toJson(),
  };
}

class Data {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? email;
  final String? gender;
  final String? wallet;
  final String? profile;
  final dynamic referCode;
  final String? cateId;
  final String? profession;
  final String? address;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.gender,
    this.wallet,
    this.profile,
    this.referCode,
    this.cateId,
    this.profession,
    this.address
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    mobile: json["mobile"],
    email: json["email"],
    gender: json["gender"],
    wallet: json["wallet"],
    profile: json["profile"],
    referCode: json["refer_code"],
    cateId: json["cate_id"],
    profession: json["profession"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "mobile": mobile,
    "email": email,
    "gender": gender,
    "wallet": wallet,
    "profile": profile,
    "refer_code": referCode,
    "cate_id": cateId,
    "profession": profession,
    "address": address,
  };
}

class Ratelist {
  final String? excellent;
  final String? good;
  final String? average;
  final String? notGood;
  final String? poor;

  Ratelist({
    this.excellent,
    this.good,
    this.average,
    this.notGood,
    this.poor,
  });

  factory Ratelist.fromJson(Map<String, dynamic> json) => Ratelist(
    excellent: json["Excellent"],
    good: json["Good"],
    average: json["Average"],
    notGood: json["NotGood"],
    poor: json["Poor"],
  );

  Map<String, dynamic> toJson() => {
    "Excellent": excellent,
    "Good": good,
    "Average": average,
    "NotGood": notGood,
    "Poor": poor,
  };
}
