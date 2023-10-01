class get_cart_model {
  bool? status;
  String? message;
  int? total;
  List<Data>? data;

  get_cart_model({this.status, this.message, this.total, this.data});

  get_cart_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
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
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? deviceId;
  String? categoryId;
  String? serviceCateId;
  String? title;
  String? qty;
  String? price;
  String? finalPrice;
  List<ExtraInclude>? extraInclude;
  String? type;
  String? image;
  String? createAt;
  String? updateAt;

  Data(
      {this.id,
        this.userId,
        this.deviceId,
        this.categoryId,
        this.serviceCateId,
        this.title,
        this.qty,
        this.price,
        this.finalPrice,
        this.extraInclude,
        this.type,
        this.image,
        this.createAt,
        this.updateAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    deviceId = json['device_id'];
    categoryId = json['category_id'];
    serviceCateId = json['service_cate_id'].toString();
    title = json['title'];
    qty = json['qty'];
    price = json['price'];
    finalPrice = json['final_price'];
    if (json['extra_include'] != null) {
      extraInclude = <ExtraInclude>[];
      json['extra_include'].forEach((v) {
        extraInclude!.add(new ExtraInclude.fromJson(v));
      });
    }
    type = json['type'];
    image = json['image'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['device_id'] = this.deviceId;
    data['category_id'] = this.categoryId;
    data['service_cate_id'] = this.serviceCateId;
    data['title'] = this.title;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['final_price'] = this.finalPrice;
    if (this.extraInclude != null) {
      data['extra_include'] =
          this.extraInclude!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['image'] = this.image;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    return data;
  }
}

class ExtraInclude {
  String? title;

  ExtraInclude({this.title});

  ExtraInclude.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    return data;
  }
}
