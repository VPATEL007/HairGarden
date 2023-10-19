// To parse this JSON data, do
//
//     final getRewardsModel = getRewardsModelFromJson(jsonString);

import 'dart:convert';

get_rewards_model getRewardsModelFromJson(String str) => get_rewards_model.fromJson(json.decode(str));

String getRewardsModelToJson(get_rewards_model data) => json.encode(data.toJson());

class get_rewards_model {
  bool? status;
  List<Datum>? data;

  get_rewards_model({
    this.status,
    this.data,
  });

  factory get_rewards_model.fromJson(Map<String, dynamic> json) => get_rewards_model(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? receiver;
  String? fullname;
  String? remark;
  String? amount;
  int? isreceiver;
  String? referCode;

  Datum({
    this.receiver,
    this.fullname,
    this.remark,
    this.amount,
    this.isreceiver,
    this.referCode,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    receiver: json["Receiver"],
    fullname: json["Fullname"],
    remark: json["remark"],
    amount: json["amount"],
    isreceiver: json["Isreceiver"],
    referCode: json["ReferCode"],
  );

  Map<String, dynamic> toJson() => {
    "Receiver": receiver,
    "Fullname": fullname,
    "remark": remark,
    "amount": amount,
    "Isreceiver": isreceiver,
    "ReferCode": referCode,
  };
}
