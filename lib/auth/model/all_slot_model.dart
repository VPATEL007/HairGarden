// To parse this JSON data, do
//
//     final allSlotDataModel = allSlotDataModelFromJson(jsonString);

import 'dart:convert';

AllSlotDataModel allSlotDataModelFromJson(String str) => AllSlotDataModel.fromJson(json.decode(str));

String allSlotDataModelToJson(AllSlotDataModel data) => json.encode(data.toJson());

class AllSlotDataModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  AllSlotDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory AllSlotDataModel.fromJson(Map<String, dynamic> json) => AllSlotDataModel(
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
  final String? timeSlot;

  Datum({
    this.id,
    this.timeSlot,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    timeSlot: json["timeSlot"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "timeSlot": timeSlot,
  };
}
