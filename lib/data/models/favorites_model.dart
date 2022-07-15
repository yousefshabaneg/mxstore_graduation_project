import 'product_model.dart';

class ChangeFavoritesModel {
  bool? status;
  String? message;
  ProductItemModel? product;
  ChangeFavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    product = ProductItemModel.fromJson(json["product"]);
  }
}
