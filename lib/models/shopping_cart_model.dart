import 'package:wms/models/market/market_wares_model.dart';

class ShoppingCartModel {
  MarketWaresModel waresModel;
  int count;

  ShoppingCartModel({this.waresModel, this.count});

  factory ShoppingCartModel.fromJson(Map<String, dynamic> json) {
    return ShoppingCartModel(
      waresModel: MarketWaresModel.fromJson(json['waresModel']),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'waresModel': waresModel.toJson(),
        'count': count,
      };
}
