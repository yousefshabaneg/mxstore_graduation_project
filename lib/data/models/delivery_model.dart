class DeliveryModel {
  int? id;
  String? shortName;
  String? description;
  String? deliveryTime;
  double? price;

  DeliveryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    shortName = json["shortName"];
    description = json["deliveryTime"];
    deliveryTime = json["description"];
    price = json["price"];
  }
}
