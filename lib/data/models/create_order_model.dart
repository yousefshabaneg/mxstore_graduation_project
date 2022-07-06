class CreateOrderModel {
  int? id;
  String? buyerEmail;
  String? orderDate;
  List<CreateOrderItem>? orderItems;
  int? subtotal;
  int? status;

  CreateOrderModel(
      {this.buyerEmail,
      this.orderDate,
      this.orderItems,
      this.subtotal,
      this.status,
      this.id});

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    buyerEmail = json['buyerEmail'];
    orderDate = json['orderDate'];
    if (json['orderItems'] != null) {
      orderItems = <CreateOrderItem>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new CreateOrderItem.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buyerEmail'] = this.buyerEmail;
    data['orderDate'] = this.orderDate;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = this.subtotal;
    data['status'] = this.status;
    data['id'] = this.id;
    return data;
  }
}

class CreateOrderItem {
  ItemOrdered? itemOrdered;
  int? price;
  int? quantity;
  int? id;

  CreateOrderItem({this.itemOrdered, this.price, this.quantity, this.id});

  CreateOrderItem.fromJson(Map<String, dynamic> json) {
    itemOrdered = json['itemOrdered'] != null
        ? new ItemOrdered.fromJson(json['itemOrdered'])
        : null;
    price = json['price'];
    quantity = json['quantity'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.itemOrdered != null) {
      data['itemOrdered'] = this.itemOrdered!.toJson();
    }
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['id'] = this.id;
    return data;
  }
}

class ItemOrdered {
  int? productItemId;
  String? productName;
  String? pictureUrl;

  ItemOrdered({this.productItemId, this.productName, this.pictureUrl});

  ItemOrdered.fromJson(Map<String, dynamic> json) {
    productItemId = json['productitemId'];
    productName = json['productName'];
    pictureUrl = "https://10.0.2.2:5001/${json['pictureUrl']}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productitemId'] = this.productItemId;
    data['productName'] = this.productName;
    data['pictureUrl'] = this.pictureUrl;
    return data;
  }
}
