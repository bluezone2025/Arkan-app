class CopounModel {
  int? status;
  Data? data;

  CopounModel({this.status, this.data});

  CopounModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? code;
  int? percentage;

  Data({
    this.id,
    this.code,
    this.percentage,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    percentage = json['percentage'];
  }
}
