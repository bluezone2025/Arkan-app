// ignore_for_file: prefer_typing_uninitialized_variables

import '../../tabone_screen/model/home_model.dart';

class OffersModel {
  int? status;
  Data? data;

  OffersModel({this.status, this.data});

  OffersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Offers? offers;

  Data({this.offers});

  Data.fromJson(Map<String, dynamic> json) {
    offers = json['offers'] != null ? Offers.fromJson(json['offers']) : null;
  }
}

class Offers {
  int? currentPage;
  List<DataOffers>? dataOffers;
  int? from;
  String? path;
  int? perPage;
  int? to;

  Offers(
      {this.currentPage,
      this.dataOffers,
      this.from,
      this.path,
      this.perPage,
      this.to});

  Offers.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      dataOffers = <DataOffers>[];
      json['data'].forEach((v) {
        dataOffers!.add(DataOffers.fromJson(v));
      });
    }

    from = json['from'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
  }
}

class DataOffers {
  int? id;
  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
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
  String? createdAt;
  String? updatedAt;
  int? availability;
  List<Country>? countries;

  DataOffers({
    this.id,
    this.titleEn,
    this.titleAr,
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
    this.countries,
    this.bestSelling,
    this.basicCategoryId,
    this.categoryId,
    this.sizeGuideId,
    this.createdAt,
    this.updatedAt,
    this.availability,
  });

  DataOffers.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    availability = json['quantity_attribute'];
  }
}
