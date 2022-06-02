import 'package:graduation_project/data/models/comment_model.dart';

class ProductItemModel {
  int? id;
  String? name;
  String? description;
  String? brandName;
  String? categoryName;
  String? typeName;
  String? imageUrl;
  List<String> gallery = [];
  int? price;
  int? oldPrice;
  int? discount;
  int? brandId;
  int? categoryId;
  int? typeId;
  double rating = 5.0;
  int numberInStock = 0;
  List<CommentModel> comments = [];
  Map<String, dynamic> specifications = {};

  ProductItemModel.fromJson(Map<String, dynamic> jsons) {
    id = jsons["id"];
    name = jsons["name"];
    description = jsons["description"];
    imageUrl = jsons["pictureUrl"].replaceFirst("localhost", "10.0.2.2");
    gallery = changeGalleryUrl(jsons['gallery'].cast<String>());
    price = jsons["price"];
    oldPrice = jsons["oldPrice"];
    discount = jsons["discount"];
    categoryId = jsons["categoryId"];
    brandId = jsons["productBrandId"];
    brandName = jsons["productBrand"];
    typeId = jsons["productTypeId"];
    typeName = jsons["productType"];
    categoryName = jsons["category"];
    rating = jsons["rating"] == 0 ? 5 : jsons["rating"].toDouble();
    numberInStock = jsons["numberInStock"];
    specifications = jsons["specifications"];
  }

  List<String> changeGalleryUrl(List<String> gallery) {
    List<String> newGallery = [];
    gallery.forEach((element) {
      newGallery.add(element.replaceFirst("localhost", "10.0.2.2"));
    });
    return newGallery;
  }
}

class ProductsModel {
  int? pageIndex;
  int? pageSize;
  int? count;
  List<ProductItemModel>? products;
  ProductsModel.fromJson(Map<String, dynamic> json) {
    pageIndex = json["pageIndex"];
    pageSize = json["pageSize"];
    count = json["count"];
    products = List.from(json["data"])
        .map((e) => ProductItemModel.fromJson(e))
        .toList();
  }
}
