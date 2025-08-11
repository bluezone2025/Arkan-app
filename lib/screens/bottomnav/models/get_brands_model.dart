// To parse this JSON data, do
//
//     final getBrandsModel = getBrandsModelFromJson(jsonString);

import 'dart:convert';

import '../../tabone_screen/model/home_model.dart';

GetBrandsModel getBrandsModelFromJson(String str) => GetBrandsModel.fromJson(json.decode(str));

String getBrandsModelToJson(GetBrandsModel data) => json.encode(data.toJson());

class GetBrandsModel {
  int? status;
  Brands? brands;

  GetBrandsModel({
    this.status,
    this.brands,
  });

  factory GetBrandsModel.fromJson(Map<String, dynamic> json) => GetBrandsModel(
    status: json["status"],
    brands: json["data"] == null ? null : Brands.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": brands?.toJson(),
  };
}

class Brands {
  List<Brand>? discountsBrands;
  List<Brand>? normalBrands;

  Brands({
    this.discountsBrands,
    this.normalBrands,
  });

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
    discountsBrands: json["discounts_brands"] == null ? [] : List<Brand>.from(json["discounts_brands"]!.map((x) => Brand.fromJson(x))),
    normalBrands: json["normal_brands"] == null ? [] : List<Brand>.from(json["normal_brands"]!.map((x) => Brand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "discounts_brands": discountsBrands == null ? [] : List<dynamic>.from(discountsBrands!.map((x) => x.toJson())),
    "normal_brands": normalBrands == null ? [] : List<dynamic>.from(normalBrands!.map((x) => x.toJson())),
  };
}

class Brand {
  int? id;
  String? nameAr;
  String? nameEn;
  String? logo;
  List<Country>? countries;
  String? arkanPercentage;
  String? brandPercentage;
  int? productsCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? email;
  String? phone;
  int? hasDiscount;
  int? discountPercentage;
  int? startDiscountRange;
  int? endDiscountRange;

  Brand({
    this.id,
    this.nameAr,
    this.nameEn,
    this.logo,
    this.countries,
    this.arkanPercentage,
    this.brandPercentage,
    this.productsCount,
    this.createdAt,
    this.updatedAt,
    this.email,
    this.phone,
    this.hasDiscount,
    this.discountPercentage,
    this.startDiscountRange,
    this.endDiscountRange,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    logo: json["logo"],
    arkanPercentage: json["arkan_percentage"],
    brandPercentage: json["brand_percentage"],
    productsCount: json["products_count"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    countries: json["countries"] == null ? [] : List<Country>.from(json["countries"]!.map((x) => Country.fromJson(x))),
    email: json["email"],
    phone: json["phone"],
    hasDiscount: json["has_discount"],
    discountPercentage: json["discount_percentage"],
    startDiscountRange: json["start_discount_range"],
    endDiscountRange: json["end_discount_range"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_ar": nameAr,
    "name_en": nameEn,
    "logo": logo,
    "arkan_percentage": arkanPercentage,
    "brand_percentage": brandPercentage,
    "products_count": productsCount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "email": email,
    "phone": phone,
    "has_discount": hasDiscount,
    "discount_percentage": discountPercentage,
    "start_discount_range": startDiscountRange,
    "end_discount_range": endDiscountRange,
  };
}
