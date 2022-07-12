import 'package:graduation_project/data/models/address_model.dart';

class OrderModel {
  int? id;
  String? orderId;
  String? buyerEmail;
  String? orderDate;
  String? deliveryMethod;
  int? shippingPrice;
  AddressModel? shipToAddress;
  List<OrderItems>? orderItems;
  int? subtotal;
  String? status;
  String? shipping;
  int? total;

  OrderModel(
      {this.id,
      this.buyerEmail,
      this.orderDate,
      this.deliveryMethod,
      this.shippingPrice,
      this.orderItems,
      this.orderId,
      this.subtotal,
      this.shipping,
      this.status,
      this.total});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    buyerEmail = json['buyerEmail'];
    shipping = json['shipping'];
    orderDate = json['orderDate'];
    deliveryMethod = json['deliveryMethod'];
    shippingPrice = json['shippingPrice'].toInt();
    shipToAddress = json['shipToAddress'] != null
        ? new AddressModel.fromJson(json['shipToAddress'])
        : null;
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    subtotal = json['subtotal'].toInt();
    status = json['status'];
    total = json['total'].toInt();
  }
}

class OrderItems {
  int? productId;
  String? productName;
  String? pictureUrl;
  int? price;
  int? quantity;

  OrderItems(
      {this.productId,
      this.productName,
      this.pictureUrl,
      this.price,
      this.quantity});

  OrderItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    pictureUrl = json['pictureUrl'].replaceFirst("localhost", "10.0.2.2");
    price = json['price'].toInt();
    quantity = json['quantity'];
  }
}
