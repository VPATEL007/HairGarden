class get_profile_info_model {
  bool? status;
  String? message;
  Data? data;

  get_profile_info_model({this.status, this.message, this.data});

  get_profile_info_model.fromJson(Map<String, dynamic> json) {
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
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? wallet;
  String? profile;
  String? referCode;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.mobile,
        this.email,
        this.wallet,
        this.profile,
        this.referCode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    wallet = json['wallet'];
    profile = json['profile'];
    referCode = json['refer_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['wallet'] = this.wallet;
    data['profile'] = this.profile;
    data['refer_code'] = this.referCode;
    return data;
  }
}
