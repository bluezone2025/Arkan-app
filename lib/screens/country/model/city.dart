class CityModel {
  int? status;
  List<Data>? data;

  CityModel({this.status, this.data});

  CityModel.fromJson(Map<String, dynamic> json) {
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
  String? nameAr;
  String? nameEn;
  String? delivery;
  String? deliveryPeriod;
  int? countryId;

  Data({
    this.id,
    this.nameAr,
    this.nameEn,
    this.delivery,
    this.deliveryPeriod,
    this.countryId,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    delivery = json['delivery'];
    deliveryPeriod = json['delivery_period'];
    countryId = json['country_id'];
  }
}
