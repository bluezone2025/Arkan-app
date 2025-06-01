class AllinfoModel {
  int? status;
  List<Data>? data;

  AllinfoModel({this.status, this.data});

  AllinfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  String? pageTitleAr;
  String? pageTitleEn;

  Data({this.id, this.pageTitleAr, this.pageTitleEn});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageTitleAr = json['page_title_ar'];
    pageTitleEn = json['page_title_en'];
  }
}
