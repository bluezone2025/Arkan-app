// ignore_for_file: prefer_typing_uninitialized_variables

class DeliveryModel {
  int? success;
  var value;
  String? delivery;

  DeliveryModel({this.success, this.value, this.delivery});

  DeliveryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    value = json['value'];
    delivery = json['delivery'];
  }
}
