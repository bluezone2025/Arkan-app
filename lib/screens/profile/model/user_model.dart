class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }
}
