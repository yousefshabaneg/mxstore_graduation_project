class BrandModel {
  late int id;
  late String name;
  late String image;
  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    image = json["pictureUrl"].replaceFirst("localhost", "10.0.2.2");
  }
}
