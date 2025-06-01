// ignore_for_file: prefer_typing_uninitialized_variables

class SingleOrderModel {
  int? status;
  Order? order;

  SingleOrderModel({this.status, this.order});

  SingleOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
}

class Order {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? countryId;
  var invoiceLink;
  int? cityId;
  int? userId;
  String? address1;
  String? postalCode;
  int? status;
  String? region;
  String? street;
  String? buildinNumber;
  String? floor;
  String? apartmntNumber;
  String? totalPrice;
  String? totalQuantity;
  String? createdAt;
  List<OrderItems>? orderItems;

  Order(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.invoiceLink,
      this.apartmntNumber,
      this.street,
      this.buildinNumber,
      this.floor,
      this.region,
      this.countryId,
      this.cityId,
      this.userId,
      this.address1,
      this.postalCode,
      this.status,
      this.totalPrice,
      this.totalQuantity,
      this.createdAt,
      this.orderItems});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceLink = json["invoice_id"];
    region = json['region'];
    buildinNumber = json['building_number'];
    street = json['the_street'];
    floor = json['floor'];
    apartmntNumber = json['apartment_number'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    countryId = json['country_id'];
    cityId = json['city_id'];
    userId = json['user_id'];
    address1 = json['address1'];
    postalCode = json['postal_code'];
    status = json['status'];
    totalPrice = json['total_price'];
    totalQuantity = json['total_quantity'];
    createdAt = json['created_at'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
  }
}

class OrderItems {
  int? id;
  int? orderId;
  int? productId;
  int? productHeightId;
  int? productSizeId;
  String? quantity;
  Product? product;
  Height? height;
  Height? size;

  OrderItems(
      {this.id,
      this.orderId,
      this.productId,
      this.productHeightId,
      this.productSizeId,
      this.quantity,
      this.product,
      this.height,
      this.size});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productHeightId = json['product_height_id'];
    productSizeId = json['product_size_id'];
    quantity = json['quantity'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    height = json['height'] != null ? Height.fromJson(json['height']) : null;
    size = json['size'] != null ? Height.fromJson(json['size']) : null;
  }
}

class Product {
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

  Product(
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
      this.sizeGuideId,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
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
    sizeGuideId = json['size_guide_id'];
  }
}

class Height {
  int? id;
  int? quantity;
  int? productId;
  int? sizeId;
  int? heightId;
  Height? height;

  Height(
      {this.id,
      this.quantity,
      this.productId,
      this.sizeId,
      this.heightId,
      this.height});

  Height.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    productId = json['product_id'];
    sizeId = json['size_id'];
    heightId = json['height_id'];
    height = json['height'] != null ? Height.fromJson(json['height']) : null;
  }
}

class HeightData {
  int? id;
  String? name;

  HeightData({this.id, this.name});

  HeightData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class Size {
  int? id;
  int? productId;
  int? sizeId;
  Height? size;

  Size({this.id, this.productId, this.sizeId, this.size});

  Size.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    sizeId = json['size_id'];
    size = json['size'] != null ? Height.fromJson(json['size']) : null;
  }
}

class OrderItemsData {
  int? id;
  int? orderId;
  int? productId;
  int? productHeightId;
  int? productSizeId;
  String? quantity;
  Product? product;
  Height? height;
  Height? size;

  OrderItemsData(
      {this.id,
      this.orderId,
      this.productId,
      this.productHeightId,
      this.productSizeId,
      this.quantity,
      this.product,
      this.height,
      this.size});

  OrderItemsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productHeightId = json['product_height_id'];
    productSizeId = json['product_size_id'];
    quantity = json['quantity'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    height = json['height'] != null ? Height.fromJson(json['height']) : null;
    size = json['size'] != null ? Height.fromJson(json['size']) : null;
  }
}

class SizeData {
  int? id;
  int? productId;
  int? sizeId;
  Height? size;

  SizeData({this.id, this.productId, this.sizeId, this.size});

  SizeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    sizeId = json['size_id'];
    size = json['size'] != null ? Height.fromJson(json['size']) : null;
  }
}
