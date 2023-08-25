class CityModel {
  int id;
  String cityId;
  String cityName;
  String provinceId;
  String lng;
  String lat;

  CityModel({
    this.id,
    this.cityId,
    this.cityName,
    this.provinceId,
    this.lng,
    this.lat,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
        id: json['id'],
        cityId: json['cityId'],
        cityName: json['cityName'],
        provinceId: json['provinceId'],
        lng: json['lng'],
        lat: json['lat']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cityId': cityId,
        'cityName': cityName,
        'provinceId': provinceId,
        'lng': lng,
        'lat': lat,
      };
}
