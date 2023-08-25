class CountryModel {
  num id;
  String countryName;
  String belongTo;

  CountryModel({
    this.id,
    this.countryName,
    this.belongTo,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
        id: json['id'],
        countryName: json['countryName'],
        belongTo: json['belongTo']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'countryName': countryName,
        'belongTo': belongTo,
      };
}
