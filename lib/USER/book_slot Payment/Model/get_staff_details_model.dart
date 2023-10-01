class get_staff_details_model {
  bool? status;
  String? message;
  String? name;
  String? profile;
  String? average;
  Ratelist? ratelist;
  List<Data>? data;

  get_staff_details_model(
      {this.status,
        this.message,
        this.name,
        this.profile,
        this.average,
        this.ratelist,
        this.data});

  get_staff_details_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    name = json['name'];
    profile = json['profile'];
    average = json['average'];
    ratelist = json['ratelist'] != null
        ? new Ratelist.fromJson(json['ratelist'])
        : null;
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
    data['name'] = this.name;
    data['profile'] = this.profile;
    data['average'] = this.average;
    if (this.ratelist != null) {
      data['ratelist'] = this.ratelist!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ratelist {
  String? excellent;
  String? good;
  String? average;
  String? notGood;
  String? poor;

  Ratelist({this.excellent, this.good, this.average, this.notGood, this.poor});

  Ratelist.fromJson(Map<String, dynamic> json) {
    excellent = json['Excellent'];
    good = json['Good'];
    average = json['Average'];
    notGood = json['NotGood'];
    poor = json['Poor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Excellent'] = this.excellent;
    data['Good'] = this.good;
    data['Average'] = this.average;
    data['NotGood'] = this.notGood;
    data['Poor'] = this.poor;
    return data;
  }
}

class Data {
  String? id;
  String? staffId;
  String? userId;
  String? username;
  String? userimage;
  String? ratings;
  String? createdAt;

  Data(
      {this.id,
        this.staffId,
        this.userId,
        this.username,
        this.userimage,
        this.ratings,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffId = json['staff_id'];
    userId = json['user_id'];
    username = json['username'];
    userimage = json['userimage'];
    ratings = json['ratings'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['staff_id'] = this.staffId;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['userimage'] = this.userimage;
    data['ratings'] = this.ratings;
    data['created_at'] = this.createdAt;
    return data;
  }
}
