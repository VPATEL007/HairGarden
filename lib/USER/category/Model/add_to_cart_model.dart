class add_to_cart_model {
  bool? status;
  String? message;

  add_to_cart_model({this.status, this.message});

  add_to_cart_model.fromJson(Map<String, dynamic> json) {
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
