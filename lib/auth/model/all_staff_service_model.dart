// To parse this JSON data, do
//
//     final allStaffServiceModel = allStaffServiceModelFromJson(jsonString);

import 'dart:convert';

AllStaffServiceModel allStaffServiceModelFromJson(String str) => AllStaffServiceModel.fromJson(json.decode(str));

String allStaffServiceModelToJson(AllStaffServiceModel data) => json.encode(data.toJson());

class AllStaffServiceModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  AllStaffServiceModel({
    this.status,
    this.message,
    this.data,
  });

  factory AllStaffServiceModel.fromJson(Map<String, dynamic> json) => AllStaffServiceModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final String? id;
  final String? name;

  Datum({
    this.id,
    this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"].toString(),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
