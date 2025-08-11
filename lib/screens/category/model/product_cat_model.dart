// ignore_for_file: prefer_typing_uninitialized_variables

import '../../tabone_screen/model/home_model.dart';

class CategoryProductModel {
  int? status;
  int? countItems;
  Data? data;

  CategoryProductModel({this.status, this.countItems, this.data});

  CategoryProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    countItems = json['countItems'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Category? category;
  List<Products>? products;

  Data({this.category, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }
}

class Category {
  int? id;
  String? nameAr;
  String? nameEn;
  int? basicCategoryId;

  Category({
    this.id,
    this.nameAr,
    this.nameEn,
    this.basicCategoryId,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    basicCategoryId = json['basic_category_id'];
  }
}

class Products {
  int? id;
  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  int? appearance;
  int? featured;
  int? newarrive;
  List<Country>? countries;
  var price;
  int? hasOffer;
  var beforePrice;
  var deliveryPeriod;
  String? img;
  int? bestSelling;
  int? basicCategoryId;
  int? categoryId;
  int? sizeGuideId;
  int? availability;

  Products({
    this.id,
    this.titleEn,
    this.titleAr,
    this.countries,
    this.descriptionEn,
    this.descriptionAr,
    this.appearance,
    this.featured,
    this.newarrive,
    this.price,
    this.hasOffer,
    this.beforePrice,
    this.deliveryPeriod,
    this.img,
    this.bestSelling,
    this.basicCategoryId,
    this.categoryId,
    this.sizeGuideId,
    this.availability,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
    titleAr = json['title_ar'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    appearance = json['appearance'];
    featured = json['featured'];
    newarrive = json['new'];
    price = json['price'];
    hasOffer = json['has_offer'];
    beforePrice = json['before_price'];
    deliveryPeriod = json['delivery_period'];
    img = json['img'];
    countries = json["countries"] == null ? [] : List<Country>.from(json["countries"]!.map((x) => Country.fromJson(x)));
    bestSelling = json['best_selling'];
    basicCategoryId = json['basic_category_id'];
    categoryId = json['category_id'];
    sizeGuideId = json['size_guide_id'];
    availability = json['quantity_attribute'];
  }
}
