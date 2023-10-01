// To parse this JSON data, do
//
//     final allTicketModel = allTicketModelFromJson(jsonString);

import 'dart:convert';

AllTicketModel allTicketModelFromJson(String str) => AllTicketModel.fromJson(json.decode(str));

String allTicketModelToJson(AllTicketModel data) => json.encode(data.toJson());

class AllTicketModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  AllTicketModel({
    this.status,
    this.message,
    this.data,
  });

  factory AllTicketModel.fromJson(Map<String, dynamic> json) => AllTicketModel(
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
  final String? subject;
  final String? description;
  final String? users;
  final String? attachment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;

  Datum({
    this.id,
    this.subject,
    this.description,
    this.users,
    this.attachment,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"].toString(),
    subject: json["subject"],
    description: json["description"],
    users: json["users"],
    attachment: json["attachment"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subject": subject,
    "description": description,
    "users": users,
    "attachment": attachment,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
  };
}
