class CommentModel {
  int? productId;
  String? name;
  double? rating;
  String? date;
  String? comment;

  CommentModel.fromJson(Map<String, dynamic> json) {
    productId = json["productId"];
    rating = json["rating"].toDouble();
    name = json["userName"];
    date = json["commentDate"];
    comment = json["commentDescription"].trim();
  }
}
