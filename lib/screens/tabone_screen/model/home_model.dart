// ignore_for_file: prefer_typing_uninitialized_variables

class HomeitemsModel {
  int? status;
  Data? data;

  HomeitemsModel({this.status, this.data});

  HomeitemsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Categories>? categories;
  List<Sliders>? sliders;
  List<NewArrive>? newArrive;
  List<Offers>? offers;
  List<Offers>? reception_products;
  List<BestSell>? bestSell;
  List<Posts>? posts;

  Data(
      {this.categories,
      this.sliders,
      this.newArrive,
      this.offers,
      this.reception_products,
      this.bestSell,
      this.posts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(Sliders.fromJson(v));
      });
    }
    if (json['new_arrive'] != null) {
      newArrive = <NewArrive>[];
      json['new_arrive'].forEach((v) {
        newArrive!.add(NewArrive.fromJson(v));
      });
    }
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(Offers.fromJson(v));
      });
    }
    if (json['reception_products'] != null) {
      reception_products = <Offers>[];
      json['reception_products'].forEach((v) {
        reception_products!.add(Offers.fromJson(v));
      });
    }
    if (json['best_sell'] != null) {
      bestSell = <BestSell>[];
      json['best_sell'].forEach((v) {
        bestSell!.add(BestSell.fromJson(v));
      });
    }
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(Posts.fromJson(v));
      });
    }
  }
}

class Categories {
  int? id;
  String? nameAr;
  String? nameEn;
  String? imageUrl;
  int? type;
  List<CategoriesSub>? categoriesSub;

  Categories(
      {this.id,
      this.nameAr,
      this.nameEn,
      this.imageUrl,
      this.type,
      this.categoriesSub});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    imageUrl = json['image_url'];
    type = json['type'];

    if (json['categories'] != null) {
      categoriesSub = <CategoriesSub>[];
      json['categories'].forEach((v) {
        categoriesSub!.add(CategoriesSub.fromJson(v));
      });
    }
  }
}

class CategoriesSub {
  int? id;
  String? nameAr;
  String? nameEn;
  int? basicCategoryId;

  CategoriesSub({
    this.id,
    this.nameAr,
    this.nameEn,
    this.basicCategoryId,
  });

  CategoriesSub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    basicCategoryId = json['basic_category_id'];
  }
}

class Sliders {
  int? id;
  String? nameAr;
  String? nameEn;
  String? descriptionAr;
  String? descriptionEn;
  String? img;
  String? imgFullPath;

  Sliders(
      {this.id,
      this.nameAr,
      this.nameEn,
      this.descriptionAr,
      this.descriptionEn,
      this.img,
      this.imgFullPath});

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    descriptionAr = json['description_ar'];
    descriptionEn = json['description_en'];
    img = json['img'];
    imgFullPath = json['app_img_full_path'];
  }
}

class NewArrive {
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
  int? availability;

  NewArrive(
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
      this.availability});

  NewArrive.fromJson(Map<String, dynamic> json) {
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
    availability = json['quantity_attribute'];
  }
}

class Posts {
  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionEn1;
  String? descriptionAr1;
  int? appearance;
  String? img1;
  String? img2;

  int? id;

  Posts(
      {titleEn,
      this.titleAr,
      this.descriptionEn,
      this.descriptionAr,
      this.descriptionEn1,
      this.descriptionAr1,
      this.appearance,
      this.img1,
      this.img2,
      this.id});

  Posts.fromJson(Map<String, dynamic> json) {
    titleEn = json['title_en'];
    titleAr = json['title_ar'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    descriptionEn1 = json['description_en1'];
    descriptionAr1 = json['description_ar1'];
    appearance = json['appearance'];
    img1 = json['img1'];
    img2 = json['img2'];

    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title_en'] = titleEn;
    data['title_ar'] = titleAr;
    data['description_en'] = descriptionEn;
    data['description_ar'] = descriptionAr;
    data['description_en1'] = descriptionEn1;
    data['description_ar1'] = descriptionAr1;
    data['appearance'] = appearance;
    data['img1'] = img1;
    data['img2'] = img2;
    data['id'] = id;
    return data;
  }
}

class Offers {
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
  int? availability;

  Offers(
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
      this.availability});

  Offers.fromJson(Map<String, dynamic> json) {
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
    availability = json['quantity_attribute'];
  }
}
class Daza {
  int? id;
  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  int? appearance;
  int? featured;
  int? newarrive;
  int? daza;
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

  Daza(
      {this.id,
      this.titleEn,
      this.titleAr,
      this.descriptionEn,
      this.descriptionAr,
      this.appearance,
      this.featured,
      this.newarrive,
        this.daza,
      this.price,
      this.hasOffer,
      this.beforePrice,
      this.deliveryPeriod,
      this.img,
      this.bestSelling,
      this.basicCategoryId,
      this.categoryId,
      this.sizeGuideId,
      this.availability});

  Daza.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
    titleAr = json['title_ar'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    appearance = json['appearance'];
    featured = json['featured'];
    newarrive = json['new'];
    daza = json['daza'];
    price = json['price'];
    hasOffer = json['has_offer'];
    beforePrice = json['before_price'];
    deliveryPeriod = json['delivery_period'];
    img = json['img'];
    bestSelling = json['best_selling'];
    basicCategoryId = json['basic_category_id'];
    categoryId = json['category_id'];
    sizeGuideId = json['size_guide_id'];
    availability = json['quantity_attribute'];
  }
}

class BestSell {
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
  int? availability;

  BestSell({
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
    this.bestSelling,
    this.basicCategoryId,
    this.categoryId,
    this.sizeGuideId,
    this.availability,
  });

  BestSell.fromJson(Map<String, dynamic> json) {
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
    availability = json['quantity_attribute'];
  }
}
