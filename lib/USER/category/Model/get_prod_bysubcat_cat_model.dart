class get_prod_bysubcat_cat_model {
  bool? status;
  String? message;
  List<Data>? data;

  get_prod_bysubcat_cat_model({this.status, this.message, this.data});

  get_prod_bysubcat_cat_model.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? description;
  String? image;
  String? regularPrice;
  String? sellPrice;
  String? percent;
  String? cartQty;

  Data(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.regularPrice,
        this.sellPrice,
        this.percent,
        this.cartQty});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    regularPrice = json['regular_price'];
    sellPrice = json['sell_price'];
    percent = json['percent'];
    cartQty = json['cart_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['regular_price'] = this.regularPrice;
    data['sell_price'] = this.sellPrice;
    data['percent'] = this.percent;
    data['cart_qty'] = this.cartQty;
    return data;
  }
}
