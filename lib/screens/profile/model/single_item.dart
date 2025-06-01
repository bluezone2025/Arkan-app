class SingleItemModel {
  int? status;
  Data? data;

  SingleItemModel({this.status, this.data});

  SingleItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? pageTitleAr;
  String? pageTitleEn;
  String? pageDetailsAr;
  String? pageDetailsEn;
  String? image;
  String? video;

  Data(
      {this.id,
      this.pageTitleAr,
      this.pageTitleEn,
      this.pageDetailsAr,
      this.pageDetailsEn,
      this.image,
      this.video});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageTitleAr = json['page_title_ar'];
    pageTitleEn = json['page_title_en'];
    pageDetailsAr = json['page_details_ar'];
    pageDetailsEn = json['page_details_en'];
    image = json['image'];
    video = json['video'];
  }
}
