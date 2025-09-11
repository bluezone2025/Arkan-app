// To parse this JSON data, do
//
//     final getBrandProductsModel = getBrandProductsModelFromJson(jsonString);

import 'dart:convert';

import '../../tabone_screen/model/home_model.dart';

GetBrandProductsModel getBrandProductsModelFromJson(String str) => GetBrandProductsModel.fromJson(json.decode(str));

String getBrandProductsModelToJson(GetBrandProductsModel data) => json.encode(data.toJson());

class GetBrandProductsModel {
  int? status;
  int? countItems;
  BrandProducts? brandProducts;

  GetBrandProductsModel({
    this.status,
    this.countItems,
    this.brandProducts,
  });

  factory GetBrandProductsModel.fromJson(Map<String, dynamic> json) => GetBrandProductsModel(
    status: json["status"],
    countItems: json["countItems"],
    brandProducts: json["data"] == null ? null : BrandProducts.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "countItems": countItems,
    "data": brandProducts?.toJson(),
  };
}

class BrandProducts {
  Brand? brand;
  List<Product>? products;

  BrandProducts({
    this.brand,
    this.products,
  });

  factory BrandProducts.fromJson(Map<String, dynamic> json) => BrandProducts(
    brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "brand": brand?.toJson(),
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Brand {
  int? id;
  String? nameAr;
  String? nameEn;
  String? logo;
  String? cover;
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
  List<Product>? products;

  Brand({
    this.id,
    this.nameAr,
    this.nameEn,
    this.logo,
    this.cover,
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
    this.products,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    logo: json["logo"],
    cover: json["cover"],
    arkanPercentage: json["arkan_percentage"],
    brandPercentage: json["brand_percentage"],
    productsCount: json["products_count"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    email: json["email"],
    phone: json["phone"],
    hasDiscount: json["has_discount"],
    discountPercentage: json["discount_percentage"],
    startDiscountRange: json["start_discount_range"],
    endDiscountRange: json["end_discount_range"],
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_ar": nameAr,
    "name_en": nameEn,
    "logo": logo,
    "cover": cover,
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
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Product {
  int? id;
  String? titleEn;
  String? brandNameAr;
  String? brandNameEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  List<Country>? countries;
  dynamic appearance;
  dynamic featured;
  dynamic productNew;
  dynamic hasReception;
  dynamic price;
  dynamic hasOffer;
  dynamic beforePrice;
  dynamic deliveryPeriod;
  String? img;
  dynamic bestSelling;
  dynamic basicCategoryId;
  dynamic categoryId;
  dynamic sizeGuideId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic brandId;
  dynamic quantityAttribute;
  List<ProductHight>? productHights;

  Product({
    this.id,
    this.titleEn,
    this.brandNameAr,
    this.brandNameEn,
    this.titleAr,
    this.descriptionEn,
    this.descriptionAr,
    this.appearance,
    this.featured,
    this.productNew,
    this.hasReception,
    this.price,
    this.hasOffer,
    this.beforePrice,
    this.deliveryPeriod,
    this.img,
    this.bestSelling,
    this.basicCategoryId,
    this.categoryId,
    this.sizeGuideId,
    this.createdAt,
    this.updatedAt,
    this.brandId,
    this.countries,
    this.quantityAttribute,
    this.productHights,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    titleEn: json["title_en"],
    brandNameAr: json["brand_name_ar"],
    brandNameEn: json["brand_name_en"],
    titleAr: json["title_ar"],
    descriptionEn: json["description_en"],
    descriptionAr: json["description_ar"],
    appearance: json["appearance"],
    featured: json["featured"],
    productNew: json["new"],
    countries: json["countries"] == null ? [] : List<Country>.from(json["countries"]!.map((x) => Country.fromJson(x))),
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    brandId: json["brand_id"],
    quantityAttribute: json["quantity_attribute"],
    productHights: json["product_hights"] == null ? [] : List<ProductHight>.from(json["product_hights"]!.map((x) => ProductHight.fromJson(x))),
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
    "new": productNew,
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
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "brand_id": brandId,
    "quantity_attribute": quantityAttribute,
    "product_hights": productHights == null ? [] : List<dynamic>.from(productHights!.map((x) => x.toJson())),
  };
}

class ProductHight {
  int? id;
  int? quantity;
  int? productId;
  int? sizeId;
  int? heightId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductHight({
    this.id,
    this.quantity,
    this.productId,
    this.sizeId,
    this.heightId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductHight.fromJson(Map<String, dynamic> json) => ProductHight(
    id: json["id"],
    quantity: json["quantity"],
    productId: json["product_id"],
    sizeId: json["size_id"],
    heightId: json["height_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
    "product_id": productId,
    "size_id": sizeId,
    "height_id": heightId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
