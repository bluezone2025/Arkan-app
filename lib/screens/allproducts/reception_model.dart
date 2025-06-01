// To parse this JSON data, do
//
//     final receptionProductsModel = receptionProductsModelFromJson(jsonString);

import 'dart:convert';

ReceptionProductsModel receptionProductsModelFromJson(String str) => ReceptionProductsModel.fromJson(json.decode(str));

String receptionProductsModelToJson(ReceptionProductsModel data) => json.encode(data.toJson());

class ReceptionProductsModel {
  int status;
  Data data;

  ReceptionProductsModel({
    required this.status,
    required this.data,
  });

  factory ReceptionProductsModel.fromJson(Map<String, dynamic> json) => ReceptionProductsModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Receptions receptions;

  Data({
    required this.receptions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    receptions: Receptions.fromJson(json["receptions"]),
  );

  Map<String, dynamic> toJson() => {
    "receptions": receptions.toJson(),
  };
}

class Receptions {
  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;

  Receptions({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
  });

  factory Receptions.fromJson(Map<String, dynamic> json) => Receptions(
    currentPage: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
  };
}

class Datum {
  int id;
  String titleEn;
  String brandNameAr;
  String brandNameEn;
  String titleAr;
  String descriptionEn;
  String descriptionAr;
  int appearance;
  int featured;
  int datumNew;
  int hasReception;
  int price;
  int hasOffer;
  int beforePrice;
  dynamic deliveryPeriod;
  String img;
  int bestSelling;
  int basicCategoryId;
  int categoryId;
  dynamic sizeGuideId;
  DateTime createdAt;
  DateTime updatedAt;
  int quantityAttribute;
  List<ProductHight> productHights;

  Datum({
    required this.id,
    required this.titleEn,
    required this.brandNameAr,
    required this.brandNameEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.appearance,
    required this.featured,
    required this.datumNew,
    required this.hasReception,
    required this.price,
    required this.hasOffer,
    required this.beforePrice,
    required this.deliveryPeriod,
    required this.img,
    required this.bestSelling,
    required this.basicCategoryId,
    required this.categoryId,
    required this.sizeGuideId,
    required this.createdAt,
    required this.updatedAt,
    required this.quantityAttribute,
    required this.productHights,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    titleEn: json["title_en"],
    brandNameAr: json["brand_name_ar"],
    brandNameEn: json["brand_name_en"],
    titleAr: json["title_ar"],
    descriptionEn: json["description_en"],
    descriptionAr: json["description_ar"],
    appearance: json["appearance"],
    featured: json["featured"],
    datumNew: json["new"],
    hasReception: json["has_reception"],
    price: json["price"],
    hasOffer: json["has_offer"],
    beforePrice: json["before_price"],
    deliveryPeriod: json["delivery_period"],
    img: json["img"],
    bestSelling: json["best_selling"],
    basicCategoryId: json["basic_category_id"],
    categoryId: json["category_id"],
    sizeGuideId: json["size_guide_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    quantityAttribute: json["quantity_attribute"],
    productHights: List<ProductHight>.from(json["product_hights"].map((x) => ProductHight.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title_en": titleEn,
    "brand_name_ar": brandNameAr,
    "brand_name_en": brandNameEn,
    "title_ar": titleAr,
    "description_en": descriptionEn,
    "description_ar": descriptionAr,
    "appearance": appearance,
    "featured": featured,
    "new": datumNew,
    "has_reception": hasReception,
    "price": price,
    "has_offer": hasOffer,
    "before_price": beforePrice,
    "delivery_period": deliveryPeriod,
    "img": img,
    "best_selling": bestSelling,
    "basic_category_id": basicCategoryId,
    "category_id": categoryId,
    "size_guide_id": sizeGuideId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "quantity_attribute": quantityAttribute,
    "product_hights": List<dynamic>.from(productHights.map((x) => x.toJson())),
  };
}

class ProductHight {
  int id;
  int quantity;
  int productId;
  int sizeId;
  int heightId;
  DateTime createdAt;
  DateTime updatedAt;

  ProductHight({
    required this.id,
    required this.quantity,
    required this.productId,
    required this.sizeId,
    required this.heightId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductHight.fromJson(Map<String, dynamic> json) => ProductHight(
    id: json["id"],
    quantity: json["quantity"],
    productId: json["product_id"],
    sizeId: json["size_id"],
    heightId: json["height_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
    "product_id": productId,
    "size_id": sizeId,
    "height_id": heightId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
