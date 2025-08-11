// To parse this JSON data, do
//
//     final getAdsModel = getAdsModelFromJson(jsonString);

import 'dart:convert';

import '../../tabone_screen/model/home_model.dart';

GetAdsModel getAdsModelFromJson(String str) => GetAdsModel.fromJson(json.decode(str));

String getAdsModelToJson(GetAdsModel data) => json.encode(data.toJson());

class GetAdsModel {
  int? status;
  List<Ad>? ads;

  GetAdsModel({
    this.status,
    this.ads,
  });

  factory GetAdsModel.fromJson(Map<String, dynamic> json) => GetAdsModel(
    status: json["status"],
    ads: json["data"] == null ? [] : List<Ad>.from(json["data"]!.map((x) => Ad.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": ads == null ? [] : List<dynamic>.from(ads!.map((x) => x.toJson())),
  };
}

class Ad {
  int? id;
  int? productId;
  int? categoryId;
  int? brandId;
  List<Country>? countries;
  dynamic link;
  String? type;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  Ad({
    this.id,
    this.productId,
    this.categoryId,
    this.brandId,
    this.link,
    this.type,
    this.countries,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
    id: json["id"],
    productId: json["product_id"],
    categoryId: json["category_id"],
    brandId: json["brand_id"],
    link: json["link"],
    type: json["type"],
    image: json["image"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    countries: json["countries"] == null ? [] : List<Country>.from(json["countries"]!.map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "category_id": categoryId,
    "brand_id": brandId,
    "link": link,
    "type": type,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
