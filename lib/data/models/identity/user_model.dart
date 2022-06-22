class UserModel {
  String? name;
  String? email;
  String? token;
  String? phone;
  String? basketId;

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json["dispalyName"];
    email = json["email"];
    token = json["token"];
    phone = json["phoneNumber"];
    basketId = json["userBasketId"];
  }
}
