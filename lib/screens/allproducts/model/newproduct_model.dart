// ignore_for_file: prefer_typing_uninitialized_variables, prefer_collection_literals

import '../../tabone_screen/model/home_model.dart';

class NewproductModel {
  int? status;
  Data? data;

  NewproductModel({this.status, this.data});

  NewproductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;

    return data;
  }
}

class Data {
  NewArrivals? newArrivals;

  Data({this.newArrivals});

  Data.fromJson(Map<String, dynamic> json) {
    newArrivals = json['new_arrivals'] != null
        ? NewArrivals.fromJson(json['new_arrivals'])
        : null;
  }
}

class NewArrivals {
  int? currentPage;
  List<DataItems>? dataItems;
  int? from;
  String? path;
  int? perPage;
  int? to;

  NewArrivals(
      {this.currentPage,
      this.dataItems,
      this.from,
      this.path,
      this.perPage,
      this.to});

  NewArrivals.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      dataItems = <DataItems>[];
      json['data'].forEach((v) {
        dataItems!.add(DataItems.fromJson(v));
      });
    }
    from = json['from'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
  }
}

class DataItems {
  int? id;
  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  List<Country>? countries;
  int? appearance;
  int? featured;
  int? newarrive;
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

  DataItems({
    this.id,
    this.titleEn,
    this.titleAr,
    this.descriptionEn,
    this.descriptionAr,
    this.appearance,
    this.featured,
    this.countries,
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

  DataItems.fromJson(Map<String, dynamic> json) {
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
