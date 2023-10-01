class get_staffs_model {
  bool? status;
  String? message;
  List<Data>? data;

  get_staffs_model({this.status, this.message, this.data});

  get_staffs_model.fromJson(Map<String, dynamic> json) {
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
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? profile;
  String? avgRating;
  String? fcmToken;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.mobile,
        this.email,
        this.profile,
        this.avgRating,
        this.fcmToken
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'].toString();
    email = json['email'].toString();
    profile = json['profile'].toString();
    fcmToken = json['fcmToken'].toString();
    avgRating = json['avgRating'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['profile'] = this.profile;
    data['avgRating'] = this.avgRating;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}
