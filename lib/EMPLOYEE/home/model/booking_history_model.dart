// To parse this JSON data, do
//
//     final bookingHistoryModel = bookingHistoryModelFromJson(jsonString);

import 'dart:convert';

BookingHistoryModel bookingHistoryModelFromJson(String str) =>
    BookingHistoryModel.fromJson(json.decode(str));

String bookingHistoryModelToJson(BookingHistoryModel data) =>
    json.encode(data.toJson());

class BookingHistoryModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  BookingHistoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) =>
      BookingHistoryModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final String? firstName;
  final String? lastName;
  final String? buildingName;
  final String? location;
  final String? pincode;
  final String? bookId;
  final String? timing;
  final String? status;
  final String? bookingDate;
  final String? amount;

  Datum({
    this.firstName,
    this.lastName,
    this.buildingName,
    this.location,
    this.pincode,
    this.bookId,
    this.timing,
    this.status,
    this.bookingDate,
    this.amount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        firstName: json["first_name"],
        lastName: json["last_name"],
        buildingName: json["building_name"],
        location: json["location"],
        pincode: json["pincode"],
        bookId: json["bookID"],
        timing: json["timing"],
        status: json["status"],
        bookingDate: json["booking_date"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "building_name": buildingName,
        "location": location,
        "pincode": pincode,
        "bookID": bookId,
        "timing": timing,
        "status": status,
        "booking_date":bookingDate,
        "amount": amount,
      };
}
