class SingleProductColorModel {
  int? status;
  List<Data>? data;

  SingleProductColorModel({this.status, this.data});

  SingleProductColorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  int? heightId;
  int? quantity;
  String? name;

  Data({this.id, this.heightId, this.quantity, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heightId = json['height_id'];
    quantity = json['quantity'];
    name = json['name'];
  }
}
