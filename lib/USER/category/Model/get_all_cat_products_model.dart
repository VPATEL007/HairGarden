class get_all_cat_products_model {
  bool? status;
  String? message;
  List<Data>? data;

  get_all_cat_products_model({this.status, this.message, this.data});

  get_all_cat_products_model.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? blades;
  String? image;
  List<ServiceCategoryData>? serviceCategoryData;

  Data({this.id, this.name, this.blades, this.image, this.serviceCategoryData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    blades = json['blades'];
    image = json['image'];
    if (json['serviceCategoryData'] != null) {
      serviceCategoryData = <ServiceCategoryData>[];
      json['serviceCategoryData'].forEach((v) {
        serviceCategoryData!.add(new ServiceCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['blades'] = this.blades;
    data['image'] = this.image;
    if (this.serviceCategoryData != null) {
      data['serviceCategoryData'] =
          this.serviceCategoryData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceCategoryData {
  String? subcatId;
  String? subcatName;
  String? subcateImage;
  List<SubcateProduct>? subcateProduct;

  ServiceCategoryData(
      {this.subcatId, this.subcatName, this.subcateImage, this.subcateProduct});

  ServiceCategoryData.fromJson(Map<String, dynamic> json) {
    subcatId = json['subcat_id'].toString();
    subcatName = json['subcat_name'];
    subcateImage = json['subcate_image'];
    if (json['subcate_product'] != null) {
      subcateProduct = <SubcateProduct>[];
      json['subcate_product'].forEach((v) {
        subcateProduct!.add(new SubcateProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcat_id'] = this.subcatId;
    data['subcat_name'] = this.subcatName;
    data['subcate_image'] = this.subcateImage;
    if (this.subcateProduct != null) {
      data['subcate_product'] =
          this.subcateProduct!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubcateProduct {
  String? id;
  String? categoryId;
  String? title;
  String? description;
  String? image;
  String? price;
  String? sellPrice;
  String? percent;
  String? cartQty;

  SubcateProduct(
      {this.id,
        this.categoryId,
        this.title,
        this.description,
        this.image,
        this.price,
        this.sellPrice,
        this.percent,
        this.cartQty});

  SubcateProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    categoryId = json['category_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    sellPrice = json['sell_price'];
    percent = json['percent'].toString();
    cartQty = json['cart_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['sell_price'] = this.sellPrice;
    data['percent'] = this.percent;
    data['cart_qty'] = this.cartQty;
    return data;
  }
}
