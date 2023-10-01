// To parse this JSON data, do
//
//     final supportChatModel = supportChatModelFromJson(jsonString);

import 'dart:convert';

SupportChatModel supportChatModelFromJson(String str) => SupportChatModel.fromJson(json.decode(str));

String supportChatModelToJson(SupportChatModel data) => json.encode(data.toJson());

class SupportChatModel {
  final bool? status;
  final String? message;
  final Data? data;

  SupportChatModel({
    this.status,
    this.message,
    this.data,
  });

  factory SupportChatModel.fromJson(Map<String, dynamic> json) => SupportChatModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final Userdata? userdata;
  final List<Ticketdatum>? ticketdata;

  Data({
    this.userdata,
    this.ticketdata,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userdata: json["userdata"] == null ? null : Userdata.fromJson(json["userdata"]),
    ticketdata: json["ticketdata"] == null ? [] : List<Ticketdatum>.from(json["ticketdata"]!.map((x) => Ticketdatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userdata": userdata?.toJson(),
    "ticketdata": ticketdata == null ? [] : List<dynamic>.from(ticketdata!.map((x) => x.toJson())),
  };
}

class Ticketdatum {
  final String? by;
  final String? timeago;
  final String? subject;
  final String? message;

  Ticketdatum({
    this.by,
    this.timeago,
    this.subject,
    this.message,
  });

  factory Ticketdatum.fromJson(Map<String, dynamic> json) => Ticketdatum(
    by: json["by"],
    timeago: json["timeago"],
    subject: json["subject"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "by": by,
    "timeago": timeago,
    "subject": subject,
    "message": message,
  };
}

class Userdata {
  final String? username;
  final String? email;
  final String? mobile;

  Userdata({
    this.username,
    this.email,
    this.mobile,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
    username: json["username"],
    email: json["email"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "mobile": mobile,
  };
}
