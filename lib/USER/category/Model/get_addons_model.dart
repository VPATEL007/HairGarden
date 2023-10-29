class get_addons_model {
  bool? status;
  String? message;
  List<Data>? data;

  get_addons_model({this.status, this.message, this.data});

  get_addons_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json["data"] == null ? [] : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x)));
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
  String? title;
  String? description;
  String? image;
  String? price;
  String? sellPrice;
  String? percent;
  String? duration;
  String? notes;
  String? status;
  String? createAt;
  String? updateAt;

  Data(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.price,
        this.sellPrice,
        this.percent,
        this.duration,
        this.notes,
        this.status,
        this.createAt,
        this.updateAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    sellPrice = json['sell_price'];
    percent = json['percent'];
    duration = json['duration'];
    notes = json['notes'];
    status = json['status'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['sell_price'] = this.sellPrice;
    data['percent'] = this.percent;
    data['duration'] = this.duration;
    data['notes'] = this.notes;
    data['status'] = this.status;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    return data;
  }
}
