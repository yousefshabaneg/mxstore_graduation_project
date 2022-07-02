class PaymentModel {
  int? id;
  String? name;

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}
