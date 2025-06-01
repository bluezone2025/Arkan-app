class SettingModel {
  int? status;
  Data? data;

  SettingModel({this.status, this.data});

  SettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? logo;
  String? footerLogo;
  String? adImage;
  String? facebook;
  String? siteNameAr;
  String? siteNameEn;
  String? email;
  String? twitter;
  String? googlePlus;
  String? youtube;
  String? whatsapp;
  String? instagram;
  String? telegram;
  String? phone;
  int? internationalShipping;
  int? internationalShipping2;
  int? isFreeShop;

  Data({
    this.id,
    this.logo,
    this.footerLogo,
    this.adImage,
    this.facebook,
    this.siteNameAr,
    this.siteNameEn,
    this.email,
    this.twitter,
    this.googlePlus,
    this.youtube,
    this.whatsapp,
    this.instagram,
    this.telegram,
    this.phone,
    this.internationalShipping,
    this.internationalShipping2,
    this.isFreeShop,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    footerLogo = json['footer_logo'];
    adImage = json['ad_image'];
    facebook = json['facebook'];
    siteNameAr = json['site_name_ar'];
    siteNameEn = json['site_name_en'];
    email = json['email'];
    twitter = json['twitter'];
    googlePlus = json['google_plus'];
    youtube = json['youtube'];
    whatsapp = json['whatsapp'];
    instagram = json['instagram'];
    telegram = json['telegram'];
    phone = json['phone'];
    internationalShipping = json['international_shipping'];
    internationalShipping2 = json['international_shipping_2'];
    isFreeShop = json['is_free_shop'];
  }
}
