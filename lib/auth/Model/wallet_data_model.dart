// To parse this JSON data, do
//
//     final walletDataModel = walletDataModelFromJson(jsonString);

import 'dart:convert';

WalletDataModel walletDataModelFromJson(String str) => WalletDataModel.fromJson(json.decode(str));

String walletDataModelToJson(WalletDataModel data) => json.encode(data.toJson());

class WalletDataModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  WalletDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory WalletDataModel.fromJson(Map<String, dynamic> json) => WalletDataModel(
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
  final String? userId;
  final String? amount;
  final String? remark;
  final dynamic amountStatus;
  final DateTime? date;

  Datum({
    this.userId,
    this.amount,
    this.remark,
    this.amountStatus,
    this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["user_id"].toString(),
    amount: json["amount"].toString(),
    remark: json["remark"],
    amountStatus: json["amount_status"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "amount": amount,
    "remark": remark,
    "amount_status": amountStatus,
    "date": date?.toIso8601String(),
  };
}
