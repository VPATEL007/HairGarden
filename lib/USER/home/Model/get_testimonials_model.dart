class get_testimonials_model {
  bool? status;
  String? message;
  List<Data>? data;

  get_testimonials_model({this.status, this.message, this.data});

  get_testimonials_model.fromJson(Map<String, dynamic> json) {
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
  String? type;
  String? thumbnail;
  String? url;
  Null? video;
  String? status;
  String? createAt;
  String? updateAt;

  Data(
      {this.id,
        this.type,
        this.thumbnail,
        this.url,
        this.video,
        this.status,
        this.createAt,
        this.updateAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    type = json['type'].toString();
    thumbnail = json['thumbnail'];
    url = json['url'];
    video = json['video'];
    status = json['status'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['thumbnail'] = this.thumbnail;
    data['url'] = this.url;
    data['video'] = this.video;
    data['status'] = this.status;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    return data;
  }
}
