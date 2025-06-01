// ignore_for_file: prefer_typing_uninitialized_variables

class FatorrahModel {
  int? status;
  Order? order;

  FatorrahModel({this.status, this.order});

  FatorrahModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
}

class Order {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? region;
  String? thePlot;
  String? theAvenue;
  String? theStreet;
  String? buildingNumber;
  String? floor;
  String? apartmentNumber;
  String? postalCode;
  var invoiceId;
  int? status;
  String? totalPrice;
  String? totalQuantity;
  String? createdAt;
  Country? country;
  City? city;
  List<OrderItems>? orderItems;

  Order(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.region,
      this.thePlot,
      this.theAvenue,
      this.theStreet,
      this.buildingNumber,
      this.floor,
      this.apartmentNumber,
      this.postalCode,
      this.invoiceId,
      this.status,
      this.totalPrice,
      this.totalQuantity,
      this.createdAt,
      this.country,
      this.city,
      this.orderItems});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    region = json['region'];
    thePlot = json['the_plot'];
    theAvenue = json['the_avenue'];
    theStreet = json['the_street'];
    buildingNumber = json['building_number'];
    floor = json['floor'];
    apartmentNumber = json['apartment_number'];
    postalCode = json['postal_code'];
    invoiceId = json['invoice_id'];
    status = json['status'];
    totalPrice = json['total_price'];
    totalQuantity = json['total_quantity'];
    createdAt = json['created_at'];
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
  }
}

class Country {
  int? id;
  String? nameAr;
  String? nameEn;

  Country({this.id, this.nameAr, this.nameEn});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
  }
}

class City {
  int? id;
  String? nameAr;
  String? nameEn;

  City({this.id, this.nameAr, this.nameEn});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
  }
}

class OrderItems {
  String? quantity;
  Product? product;

  OrderItems({this.quantity, this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }
}

class Product {
  String? img;

  Product({this.img});

  Product.fromJson(Map<String, dynamic> json) {
    img = json['img'];
  }
}
