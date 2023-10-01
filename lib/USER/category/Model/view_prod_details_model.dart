class view_prod_details_model {
  bool? status;
  String? message;
  Data? data;

  view_prod_details_model({this.status, this.message, this.data});

  view_prod_details_model.fromJson(Map<String, dynamic> json) {
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
  String? id;
  CategoryName? categoryName;
  CategoryName? subcategoryName;
  String? title;
  String? description;
  String? whatincludes;
  String? image;
  String? regularPrice;
  String? sellPrice;
  String? percent;
  String? duration;
  String? notes;

  Data(
      {this.id,
        this.categoryName,
        this.subcategoryName,
        this.title,
        this.description,
        this.whatincludes,
        this.image,
        this.regularPrice,
        this.sellPrice,
        this.percent,
        this.duration,
        this.notes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    categoryName = json['category_name'] != null
        ? new CategoryName.fromJson(json['category_name'])
        : null;
    subcategoryName = json['subcategory_name'] != null
        ? new CategoryName.fromJson(json['subcategory_name'])
        : null;
    title = json['title'];
    description = json['description'];
    whatincludes = json['whatincludes'];
    image = json['image'];
    regularPrice = json['regular_price'];
    sellPrice = json['sell_price'];
    percent = json['percent'].toString();
    duration = json['duration'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.categoryName != null) {
      data['category_name'] = this.categoryName!.toJson();
    }
    if (this.subcategoryName != null) {
      data['subcategory_name'] = this.subcategoryName!.toJson();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['whatincludes'] = this.whatincludes;
    data['image'] = this.image;
    data['regular_price'] = this.regularPrice;
    data['sell_price'] = this.sellPrice;
    data['percent'] = this.percent;
    data['duration'] = this.duration;
    data['notes'] = this.notes;
    return data;
  }
}

class CategoryName {
  String? name;

  CategoryName({this.name});

  CategoryName.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
