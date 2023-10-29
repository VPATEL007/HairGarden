// To parse this JSON data, do
//
//     final getStaffDataModel = getStaffDataModelFromJson(jsonString);

import 'dart:convert';

GetStaffDataModel getStaffDataModelFromJson(String str) => GetStaffDataModel.fromJson(json.decode(str));

String getStaffDataModelToJson(GetStaffDataModel data) => json.encode(data.toJson());

class GetStaffDataModel {
  bool? status;
  String? message;
  int? average;
  Ratelist? ratelist;
  Data? data;

  GetStaffDataModel({
    this.status,
    this.message,
    this.average,
    this.ratelist,
    this.data,
  });

  factory GetStaffDataModel.fromJson(Map<String, dynamic> json) => GetStaffDataModel(
    status: json["status"],
    message: json["message"],
    average: json["average"],
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
  int? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? gender;
  String? wallet;
  dynamic profile;
  dynamic referCode;
  String? address;
  String? cateId;

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
    this.address,
    this.cateId,
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
    address: json["address"],
    cateId: json["cate_id"],
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
    "address": address,
    "cate_id": cateId,
  };
}

class Ratelist {
  String? excellent;
  String? good;
  String? average;
  String? notGood;
  String? poor;

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
