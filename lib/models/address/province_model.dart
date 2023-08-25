class ProvinceModel {
  num id;
  String provinceId;
  String provinceName;
  String lng;
  String lat;

  ProvinceModel({
    this.id,
    this.provinceId,
    this.provinceName,
    this.lng,
    this.lat,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
        id: json['id'],
        provinceId: json['provinceId'],
        provinceName: json['provinceName'],
        lng: json['lng'],
        lat: json['lat']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'provinceId': provinceId,
        'provinceName': provinceName,
        'lng': lng,
        'lat': lat,
      };
}
