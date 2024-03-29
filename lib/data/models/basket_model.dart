import 'product_model.dart';

class BasketModel {
  String? basketId;
  List<BasketProductModel> products = [];
  int deliveryMethodId = 1;
  int shippingPrice = 0;
  String? clientSecret;
  String? paymentIntentId;

  BasketModel({
    this.basketId,
    required this.products,
    required this.deliveryMethodId,
    this.clientSecret,
    this.paymentIntentId,
    required this.shippingPrice,
  });

  BasketModel.fromJson(Map<String, dynamic> json) {
    basketId = json["id"];
    products = List.from(json["items"])
        .map((e) => BasketProductModel.fromJson(e))
        .toList();
    clientSecret = json["clientSecret"];
    paymentIntentId = json["paymentIntentId"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.basketId;
    if (this.products.isNotEmpty) {
      data['items'] = this.products.map((v) => v.toJson()).toList();
    }
    data['deliveryMethodId'] = this.deliveryMethodId;
    data['clientSecret'] = this.clientSecret;
    data['paymentIntentId'] = this.paymentIntentId;
    data['shippingPrice'] = this.shippingPrice;
    return data;
  }

  BasketModel copyWith() {
    final List<BasketProductModel> newProducts = [];
    products.forEach((p) {
      newProducts.add(p.copyWith());
    });
    return new BasketModel(
      products: newProducts,
      deliveryMethodId: deliveryMethodId,
      basketId: basketId,
      shippingPrice: shippingPrice,
      paymentIntentId: paymentIntentId,
      clientSecret: clientSecret,
    );
  }
}

class BasketProductModel {
  int? id;
  String? name;
  String? brandName;
  String? categoryName;
  String? typeName;
  String? imageUrl;
  int quantity = 1;
  int? price;

  BasketProductModel(
      {this.id,
      this.name,
      this.price,
      this.quantity = 1,
      this.imageUrl,
      this.brandName,
      this.typeName,
      this.categoryName});

  BasketProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["productName"];
    imageUrl = json["pictureUrl"].replaceFirst("localhost", "10.0.2.2");
    price = json["price"];
    brandName = json["brand"];
    categoryName = json["catgeory"];
    quantity = json["quantity"];
    typeName = json["type"];
  }

  BasketProductModel.mapProductToBasket(ProductItemModel product,
      {int quantity = 1}) {
    id = product.id;
    name = product.name;
    imageUrl = product.imageUrl;
    price = product.price;
    brandName = product.brandName;
    typeName = product.typeName;
    categoryName = product.categoryName;
    this.quantity = quantity;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['pictureUrl'] = this.imageUrl?.replaceFirst("10.0.2.2", "localhost");
    data['brand'] = this.brandName;
    data['type'] = this.typeName;
    data['catgeory'] = this.categoryName;
    return data;
  }

  BasketProductModel copyWith() {
    return new BasketProductModel(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      imageUrl: imageUrl,
      brandName: brandName,
      typeName: typeName,
      categoryName: categoryName,
    );
  }
}
