// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  int status;
  List<Notifications> notify;

  NotificationsModel({
    required this.status,
    required this.notify,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    status: json["status"],
    notify: List<Notifications>.from(json["data"].map((x) => Notifications.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(notify.map((x) => x.toJson())),
  };
}

class Notifications {
  int id;
  dynamic type;
  dynamic typeId;
  dynamic titleAr;
  dynamic titleEn;
  dynamic bodyAr;
  dynamic bodyEn;
  dynamic image;
  dynamic createdAt;

  Notifications({
    required this.id,
    required this.type,
    required this.typeId,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.image,
    required this.createdAt,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    id: json["id"],
    type: json["type"],
    typeId: json["type_id"],
    titleAr: json["title_ar"],
    titleEn: json["title_en"],
    bodyAr: json["body_ar"],
    bodyEn: json["body_en"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "type_id": typeId,
    "title_ar": titleAr,
    "title_en": titleEn,
    "body_ar": bodyAr,
    "body_en": bodyEn,
    "image": image,
    "created_at": createdAt.toIso8601String(),
  };
}
