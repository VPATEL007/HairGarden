class book_service_model {
  bool? status;
  String? message;
  String? bookingstatus;
  String? bookingId;
  String? staffType;
  StaffData? staffData;
  List<Itemdetails>? itemdetails;
  String? price;
  String? slotName;

  book_service_model(
      {this.status,
        this.message,
        this.bookingstatus,
        this.bookingId,
        this.staffType,
        this.staffData,
        this.itemdetails,
        this.price,
        this.slotName});

  book_service_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    bookingstatus = json['bookingstatus'];
    bookingId = json['booking_id'].toString();
    staffType = json['staff_type'];
    staffData = json['staff_data'] != null
        ? new StaffData.fromJson(json['staff_data'])
        : null;
    if (json['itemdetails'] != null) {
      itemdetails = <Itemdetails>[];
      json['itemdetails'].forEach((v) {
        itemdetails!.add(new Itemdetails.fromJson(v));
      });
    }
    price = json['price'].toString();
    slotName = json['slot_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['bookingstatus'] = this.bookingstatus;
    data['booking_id'] = this.bookingId;
    data['staff_type'] = this.staffType;
    if (this.staffData != null) {
      data['staff_data'] = this.staffData!.toJson();
    }
    if (this.itemdetails != null) {
      data['itemdetails'] = this.itemdetails!.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['slot_name'] = this.slotName;
    return data;
  }
}

class StaffData {
  String? staffId;
  String? staffName;
  String? profile;
  String? avgRating;

  StaffData({this.staffId, this.staffName, this.profile, this.avgRating});

  StaffData.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'].toString();
    staffName = json['staff_name'];
    profile = json['profile'].toString();
    avgRating = json['avgRating'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['staff_name'] = this.staffName;
    data['profile'] = this.profile;
    data['avgRating'] = this.avgRating;
    return data;
  }
}

class Itemdetails {
  String? id;
  String? bookingId;
  String? serviceId;
  String? price;
  String? finalPrice;
  String? qty;
  String? title;
  String? createAt;
  String? updateAt;
  String? type;

  Itemdetails(
      {this.id,
        this.bookingId,
        this.serviceId,
        this.price,
        this.finalPrice,
        this.qty,
        this.title,
        this.createAt,
        this.updateAt,
        this.type});

  Itemdetails.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    bookingId = json['booking_id'].toString();
    serviceId = json['service_id'].toString();
    price = json['price'].toString();
    finalPrice = json['final_price'].toString();
    qty = json['qty'].toString();
    title = json['title'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['service_id'] = this.serviceId;
    data['price'] = this.price;
    data['final_price'] = this.finalPrice;
    data['qty'] = this.qty;
    data['title'] = this.title;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    data['type'] = this.type;
    return data;
  }
}
