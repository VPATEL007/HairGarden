class get_address_model {
  bool? status;
  String? message;
  List<Data>? data;

  get_address_model({this.status, this.message, this.data});

  get_address_model.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? location;
  String? pincode;
  String? buildingName;
  String? locality;
  String? latitude;
  String? longitude;
  String? isDefault;
  String? createAt;
  String? updateAt;

  Data(
      {this.id,
        this.userId,
        this.location,
        this.pincode,
        this.buildingName,
        this.locality,
        this.latitude,
        this.longitude,
        this.isDefault,
        this.createAt,
        this.updateAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    location = json['location'];
    pincode = json['pincode'];
    buildingName = json['building_name'];
    locality = json['locality'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDefault = json['isDefault'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['location'] = this.location;
    data['pincode'] = this.pincode;
    data['building_name'] = this.buildingName;
    data['locality'] = this.locality;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isDefault'] = this.isDefault;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    return data;
  }
}
