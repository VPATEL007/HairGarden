// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  NotificationModel({
    this.status,
    this.message,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
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
  final String? name;
  final String? slug;
  final String? title;
  final String? message;
  final String? image;

  Datum({
    this.name,
    this.slug,
    this.title,
    this.message,
    this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    slug: json["slug"],
    title: json["title"],
    message: json["message"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "slug": slug,
    "title": title,
    "message": message,
    "image": image,
  };
}
