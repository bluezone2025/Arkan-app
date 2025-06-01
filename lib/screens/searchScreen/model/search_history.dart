class SearchHistoryModel {
  int? status;
  Texts? texts;

  SearchHistoryModel({this.status, this.texts});

  SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    texts = json['texts'] != null ? Texts.fromJson(json['texts']) : null;
  }
}

class Texts {
  List<Data>? data;

  Texts({
    this.data,
  });

  Texts.fromJson(Map<String, dynamic> json) {
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
  String? text;

  Data({this.id, this.text});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }
}
