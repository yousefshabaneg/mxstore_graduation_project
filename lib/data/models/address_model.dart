class AddressModel {
  String? name;
  String? city;
  String? region;
  String? details;
  String? zipCode;
  String? phone;

  AddressModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    city = json["city"];
    region = json["region"];
    details = json["details"];
    zipCode = json["zipCode"];
    phone = json["street"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['city'] = this.city;
    data['region'] = this.region;
    data['details'] = this.details;
    data['zipCode'] = this.zipCode;
    data['street'] = this.phone;
    return data;
  }
}

class RegionModel {
  String? id;
  String? regionNameAr;
  String? regionNameEn;
  RegionModel({this.id, this.regionNameAr, this.regionNameEn});

  RegionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regionNameAr = json['region_name_ar'];
    regionNameEn = json['region_name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['region_name_ar'] = this.regionNameAr;
    data['region_name_en'] = this.regionNameEn;
    return data;
  }
}

class CityModel {
  String? id;
  String? regionId;
  String? cityNameAr;
  String? cityNameEn;

  CityModel({this.id, this.regionId, this.cityNameAr, this.cityNameEn});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regionId = json['region_id'];
    cityNameAr = json['city_name_ar'];
    cityNameEn = json['city_name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['region_id'] = this.regionId;
    data['city_name_ar'] = this.cityNameAr;
    data['city_name_en'] = this.cityNameEn;
    return data;
  }
}
