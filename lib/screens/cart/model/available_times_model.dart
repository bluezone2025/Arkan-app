// To parse this JSON data, do
//
//     final availableTimesModel = availableTimesModelFromJson(jsonString);

import 'dart:convert';

AvailableTimesModel availableTimesModelFromJson(String str) => AvailableTimesModel.fromJson(json.decode(str));

String availableTimesModelToJson(AvailableTimesModel data) => json.encode(data.toJson());

class AvailableTimesModel {
  int status;
  Data data;

  AvailableTimesModel({
    required this.status,
    required this.data,
  });

  factory AvailableTimesModel.fromJson(Map<String, dynamic> json) => AvailableTimesModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  List<DeliveryTime> deliveryTimes;
  Note note;

  Data({
    required this.deliveryTimes,
    required this.note,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    deliveryTimes: List<DeliveryTime>.from(json["delivery_times"].map((x) => DeliveryTime.fromJson(x))),
    note: Note.fromJson(json["note"]),
  );

  Map<String, dynamic> toJson() => {
    "delivery_times": List<dynamic>.from(deliveryTimes.map((x) => x.toJson())),
    "note": note.toJson(),
  };
}

class DeliveryTime {
  int id;
  dynamic beginTime;
  dynamic endTime;
  dynamic createdAt;
  dynamic updatedAt;

  DeliveryTime({
    required this.id,
    required this.beginTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryTime.fromJson(Map<String, dynamic> json) => DeliveryTime(
    id: json["id"],
    beginTime: json["begin_time"],
    endTime: json["end_time"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "begin_time": beginTime,
    "end_time": endTime,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Note {
  int id;
  dynamic note;
  dynamic createdAt;
  dynamic updatedAt;

  Note({
    required this.id,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json["id"],
    note: json["note"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "note": note,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
