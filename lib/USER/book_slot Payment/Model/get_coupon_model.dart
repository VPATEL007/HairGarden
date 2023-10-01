class get_coupon_model {
  bool? status;
  String? message;
  Data? data;

  get_coupon_model({this.status, this.message, this.data});

  get_coupon_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? redeempercent;

  Data({this.redeempercent});

  Data.fromJson(Map<String, dynamic> json) {
    redeempercent = json['redeempercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['redeempercent'] = this.redeempercent;
    return data;
  }
}
