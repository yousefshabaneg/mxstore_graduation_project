class OrderModel {
  int? id;
  String? buyerEmail;
  String? orderDate;
  String? deliveryMethod;
  int? shippingPrice;
  List<OrderItems>? orderItems;
  int? subtotal;
  String? status;
  int? total;

  OrderModel(
      {this.id,
      this.buyerEmail,
      this.orderDate,
      this.deliveryMethod,
      this.shippingPrice,
      this.orderItems,
      this.subtotal,
      this.status,
      this.total});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyerEmail = json['buyerEmail'];
    orderDate = json['orderDate'];
    deliveryMethod = json['deliveryMethod'];
    shippingPrice = json['shippingPrice'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    status = json['status'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buyerEmail'] = this.buyerEmail;
    data['orderDate'] = this.orderDate;
    data['deliveryMethod'] = this.deliveryMethod;
    data['shippingPrice'] = this.shippingPrice;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = this.subtotal;
    data['status'] = this.status;
    data['total'] = this.total;
    return data;
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
    pictureUrl = json['pictureUrl'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['pictureUrl'] = this.pictureUrl;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}
