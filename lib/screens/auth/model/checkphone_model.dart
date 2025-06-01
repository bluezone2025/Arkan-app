class CheckPhoneModel {
  String? message;
  Data? data;

  CheckPhoneModel({this.message, this.data});

  CheckPhoneModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? status;
  int? userId;

  Data({this.status, this.userId});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
  }
}
