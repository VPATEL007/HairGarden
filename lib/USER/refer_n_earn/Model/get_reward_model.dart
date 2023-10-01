class get_rewards_model {
  bool? status;
  String? message;
  List<Data>? data;

  get_rewards_model({this.status, this.message, this.data});

  get_rewards_model.fromJson(Map<String, dynamic> json) {
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
  String? name;
  Null? profile;
  String? amount;
  String? remark;
  String? via;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.name,
        this.profile,
        this.amount,
        this.remark,
        this.via,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    name = json['name'];
    profile = json['profile'];
    amount = json['amount'].toString();
    remark = json['remark'];
    via = json['via'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['profile'] = this.profile;
    data['amount'] = this.amount;
    data['remark'] = this.remark;
    data['via'] = this.via;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
