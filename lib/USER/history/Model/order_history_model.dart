class order_history_model {
  bool? status;
  String? message;
  List<Data>? data;

  order_history_model({this.status, this.message, this.data});

  order_history_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? paymentId;
  String? orderId;
  String? paymentType;
  String? paymentStatus;
  String? price;
  String? slotName;
  String? bookingDate;
  String? bookingId;
  String? pincode;
  String? status;
  Staffdata? staffdata;
  List<ItemList>? itemList;

  Data(
      {this.id,
        this.paymentId,
        this.orderId,
        this.paymentType,
        this.paymentStatus,
        this.price,
        this.slotName,
        this.bookingDate,
        this.bookingId,
        this.pincode,
        this.status,
        this.staffdata,
        this.itemList});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    paymentId = json['payment_id'].toString();
    orderId = json['orderId'.toString()];
    paymentType = json['paymentType'];
    paymentStatus = json['payment_status'];
    price = json['price'];
    slotName = json['slot_name'];
    bookingDate = json['booking_date'];
    bookingId = json['booking_id'].toString();
    pincode = json['pincode'].toString();
    status = json['status'];
    staffdata = json['staffdata'] != null
        ? new Staffdata.fromJson(json['staffdata'])
        : null;
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payment_id'] = this.paymentId;
    data['orderId'] = this.orderId;
    data['paymentType'] = this.paymentType;
    data['payment_status'] = this.paymentStatus;
    data['price'] = this.price;
    data['slot_name'] = this.slotName;
    data['booking_date'] = this.bookingDate;
    data['booking_id'] = this.bookingId;
    data['pincode'] = this.pincode;
    data['status'] = this.status;
    if (this.staffdata != null) {
      data['staffdata'] = this.staffdata!.toJson();
    }
    if (this.itemList != null) {
      data['itemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Staffdata {
  String? staffId;
  String? staffName;
  String? profile;

  Staffdata({this.staffId, this.staffName, this.profile});

  Staffdata.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    staffName = json['staff_name'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['staff_name'] = this.staffName;
    data['profile'] = this.profile;
    return data;
  }
}

class ItemList {
  String? id;
  String? bookingId;
  String? price;
  String? finalPrice;
  String? qty;
  String? title;

  ItemList(
      {this.id,
        this.bookingId,
        this.price,
        this.finalPrice,
        this.qty,
        this.title});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    price = json['price'];
    finalPrice = json['final_price'];
    qty = json['qty'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['price'] = this.price;
    data['final_price'] = this.finalPrice;
    data['qty'] = this.qty;
    data['title'] = this.title;
    return data;
  }
}
