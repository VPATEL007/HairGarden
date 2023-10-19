// To parse this JSON data, do
//
//     final get_address_model = get_address_modelFromJson(jsonString);

import 'dart:convert';

get_address_model get_address_modelFromJson(String str) => get_address_model.fromJson(json.decode(str));

String get_address_modelToJson(get_address_model data) => json.encode(data.toJson());

class get_address_model {
  bool? status;
  String? message;
  List<Datum>? data;

  get_address_model({
    this.status,
    this.message,
    this.data,
  });

  factory get_address_model.fromJson(Map<String, dynamic> json) => get_address_model(
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
  String? id;
  String? userId;
  String? location;
  String? pincode;
  String? buildingName;
  String? area;
  String? locality;
  String? latitude;
  String? longitude;
  String? isDefault;
  DateTime? createAt;
  DateTime? updateAt;

  Datum({
    this.id,
    this.userId,
    this.location,
    this.pincode,
    this.buildingName,
    this.area,
    this.locality,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.createAt,
    this.updateAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"].toString(),
    userId: json["user_id"].toString(),
    location: json["location"],
    pincode: json["pincode"],
    buildingName: json["building_name"],
    area: json["area"],
    locality: json["locality"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    isDefault: json["isDefault"],
    createAt: json["create_at"] == null ? null : DateTime.parse(json["create_at"]),
    updateAt: json["update_at"] == null ? null : DateTime.parse(json["update_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "location": location,
    "pincode": pincode,
    "building_name": buildingName,
    "area": area,
    "locality": locality,
    "latitude": latitude,
    "longitude": longitude,
    "isDefault": isDefault,
    "create_at": createAt?.toIso8601String(),
    "update_at": updateAt?.toIso8601String(),
  };
}
