// ignore_for_file: prefer_typing_uninitialized_variables

class AllOrdersModel {
  int? status;
  List<Orders>? orders;

  AllOrdersModel({this.status, this.orders});

  AllOrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }
}

class Orders {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? countryId;
  int? cityId;
  int? userId;
  String? address1;
  String? postalCode;
  String? address2;
  int? status;
  int? cash;
  String? totalPrice;
  String? totalQuantity;
  String? createdAt;
  List<Products>? products;

  Orders(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.countryId,
      this.cityId,
      this.userId,
      this.address1,
      this.postalCode,
      this.address2,
      this.status,
      this.cash,
      this.totalPrice,
      this.totalQuantity,
      this.createdAt,
      this.products});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    countryId = json['country_id'];
    cityId = json['city_id'];
    userId = json['user_id'];
    address1 = json['address1'];
    postalCode = json['postal_code'];
    address2 = json['address2'];
    status = json['status'];
    cash = json['cash'];
    createdAt = json['created_at'];
    totalPrice = json['total_price'];
    totalQuantity = json['total_quantity'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
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
  var price;
  int? hasOffer;
  var beforePrice;
  var deliveryPeriod;
  String? img;
  int? bestSelling;
  int? basicCategoryId;
  int? categoryId;
  Pivot? pivot;

  Products(
      {this.id,
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
      this.bestSelling,
      this.basicCategoryId,
      this.categoryId,
      this.pivot});

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
    bestSelling = json['best_selling'];
    basicCategoryId = json['basic_category_id'];
    categoryId = json['category_id'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }
}

class Pivot {
  int? orderId;
  int? productId;
  String? quantity;
  int? productHeightId;
  int? productSizeId;

  Pivot(
      {this.orderId,
      this.productId,
      this.quantity,
      this.productHeightId,
      this.productSizeId});

  Pivot.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    productHeightId = json['product_height_id'];
    productSizeId = json['product_size_id'];
  }
}
