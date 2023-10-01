class signin_viaOTP_model {
  bool? status;
  String? message;
  Data? data;

  signin_viaOTP_model({this.status, this.message, this.data});

  signin_viaOTP_model.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? whatsappNumber;
  String? email;
  String? viewPassword;
  String? gender;
  String? profile;
  String? cateId;
  String? otp;
  String? status;
  String? approveStatus;
  String? wallet;
  String? parentId;
  String? referCode;
  String? roleId;
  String? pincode;
  String? address;
  String? createAt;
  String? updatedAt;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.mobile,
        this.whatsappNumber,
        this.email,
        this.viewPassword,
        this.gender,
        this.profile,
        this.cateId,
        this.otp,
        this.status,
        this.approveStatus,
        this.wallet,
        this.parentId,
        this.referCode,
        this.roleId,
        this.pincode,
        this.address,
        this.createAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    whatsappNumber = json['whatsapp_number'];
    email = json['email'];
    viewPassword = json['view_password'];
    gender = json['gender'];
    profile = json['profile'];
    cateId = json['cate_id'];
    otp = json['otp'].toString();
    status = json['status'];
    approveStatus = json['approve_status'];
    wallet = json['wallet'].toString();
    parentId = json['parent_id'].toString();
    referCode = json['refer_code'];
    roleId = json['role_id'];
    pincode = json['pincode'];
    address = json['address'];
    createAt = json['create_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['whatsapp_number'] = this.whatsappNumber;
    data['email'] = this.email;
    data['view_password'] = this.viewPassword;
    data['gender'] = this.gender;
    data['profile'] = this.profile;
    data['cate_id'] = this.cateId;
    data['otp'] = this.otp;
    data['status'] = this.status;
    data['approve_status'] = this.approveStatus;
    data['wallet'] = this.wallet;
    data['parent_id'] = this.parentId;
    data['refer_code'] = this.referCode;
    data['role_id'] = this.roleId;
    data['pincode'] = this.pincode;
    data['address'] = this.address;
    data['create_at'] = this.createAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
