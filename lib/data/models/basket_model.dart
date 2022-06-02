import 'package:graduation_project/data/models/product_model.dart';

class BasketModel {
  String? basketId;
  List<BasketProductModel> products = [];
  int? deliveryMethodId;
  int? shippingPrice;

  BasketModel.fromJson(Map<String, dynamic> json) {
    basketId = json["id"];
    products = List.from(json["items"])
        .map((e) => BasketProductModel.fromJson(e))
        .toList();
  }
}

class BasketProductModel {
  int? id;
  String? name;
  String? brandName;
  String? categoryName;
  String? typeName;
  String? imageUrl;
  int? price;

  BasketProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["productName"];
    imageUrl = json["pictureUrl"].replaceFirst("localhost", "10.0.2.2");
    price = json["price"];
    brandName = "Hats";
    categoryName = json["catgeory"];
  }
}
