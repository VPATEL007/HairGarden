class get_time_slots_model {
  bool? status;
  String? message;
  List<Data>? data;

  get_time_slots_model({this.status, this.message, this.data});

  get_time_slots_model.fromJson(Map<String, dynamic> json) {
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
  String? timeSlot;

  Data({this.id, this.timeSlot});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    timeSlot = json['timeSlot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timeSlot'] = this.timeSlot;
    return data;
  }
}
