class AreaModel {
  int id;
  String areaId;
  String areaName;
  String cityId;
  String lng;
  String lat;

  AreaModel({
    this.id,
    this.areaId,
    this.cityId,
    this.areaName,
    this.lng,
    this.lat,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
        id: json['id'],
        areaId: json['areaId'],
        areaName: json['areaName'],
        cityId: json['cityId'],
        lng: json['lng'],
        lat: json['lat']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'areaId': areaId,
        'areaName': areaName,
        'cityId': cityId,
        'lng': lng,
        'lat': lat,
      };
}
