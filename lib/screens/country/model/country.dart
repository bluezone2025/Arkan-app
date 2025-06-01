// ignore_for_file: prefer_typing_uninitialized_variables

class CountryModel {
  int? status;
  List<Data>? data;

  CountryModel({this.status, this.data});

  CountryModel.fromJson(Map<String, dynamic> json) {
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
  String? code;
  String? countryCode;
  var delivery;
  String? imageUrl;
  int? currencyId;

  Currency? currency;

  Data(
      {this.id,
      this.nameAr,
      this.nameEn,
      this.code,
      this.countryCode,
      this.delivery,
      this.imageUrl,
      this.currencyId,
      this.currency});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    code = json['code'];
    countryCode = json['country_code'];
    delivery = json['delivery'];
    imageUrl = json['image_url'];
    currencyId = json['currency_id'];
    currency =
        json['currency'] != null ? Currency.fromJson(json['currency']) : null;
  }
}

class Currency {
  int? id;
  String? name;
  String? rate;
  String? code;

  Currency({
    this.id,
    this.name,
    this.rate,
    this.code,
  });

  Currency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rate = json['rate'];
    code = json['code'];
  }
}
