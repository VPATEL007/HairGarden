class get_subcat_byid_model {
  bool? status;
  String? message;
  String? subCateId;
  List<Data>? data;

  get_subcat_byid_model({this.status, this.message, this.subCateId, this.data});

  get_subcat_byid_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    subCateId = json['sub_cate_id'];
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
    data['sub_cate_id'] = this.subCateId;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? description;
  String? image;

  Data({this.id, this.name, this.description, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}
