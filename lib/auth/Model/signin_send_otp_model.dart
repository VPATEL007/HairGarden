class signin_send_otp_model {
  bool? status;
  String? message;

  signin_send_otp_model({this.status, this.message});

  signin_send_otp_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
