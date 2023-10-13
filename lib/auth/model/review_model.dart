// To parse this JSON data, do
//
//     final staffRatingModel = staffRatingModelFromJson(jsonString);

import 'dart:convert';

StaffRatingModel staffRatingModelFromJson(String str) => StaffRatingModel.fromJson(json.decode(str));

String staffRatingModelToJson(StaffRatingModel data) => json.encode(data.toJson());

class StaffRatingModel {
  final bool? status;
  final String? message;
  final String? name;
  final dynamic profile;
  final String? average;
  final Ratelist? ratelist;
  final List<Datum>? data;

  StaffRatingModel({
    this.status,
    this.message,
    this.name,
    this.profile,
    this.average,
    this.ratelist,
    this.data,
  });

  factory StaffRatingModel.fromJson(Map<String, dynamic> json) => StaffRatingModel(
    status: json["status"],
    message: json["message"],
    name: json["name"],
    profile: json["profile"],
    average: json["average"],
    ratelist: json["ratelist"] == null ? null : Ratelist.fromJson(json["ratelist"]),
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "name": name,
    "profile": profile,
    "average": average,
    "ratelist": ratelist?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final String? id;
  final String? staffId;
  final String? userId;
  final String? username;
  final dynamic userimage;
  final String? ratings;
  final String? remark;
  final DateTime? createdAt;

  Datum({
    this.id,
    this.staffId,
    this.userId,
    this.username,
    this.userimage,
    this.ratings,
    this.remark,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    staffId: json["staff_id"],
    userId: json["user_id"],
    username: json["username"],
    userimage: json["userimage"],
    ratings: json["ratings"],
    remark: json["remark"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "staff_id": staffId,
    "user_id": userId,
    "username": username,
    "userimage": userimage,
    "ratings": ratings,
    "remark": remark,
    "created_at": createdAt?.toIso8601String(),
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
