class CommentModel {
  int? productId;
  String? name;
  double? rating;
  String? date;
  String? userId;
  String? comment;

  CommentModel.fromJson(Map<String, dynamic> json) {
    productId = json["productId"];
    rating = json["rating"].toDouble();
    name = json["userName"];
    date = json["commentDate"];
    userId = json["userId"];
    comment = json["commentDescription"].trim();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentDescription'] = this.comment;
    data['productId'] = this.productId;
    data['rating'] = this.rating;
    data['userName'] = this.name;
    return data;
  }
}
