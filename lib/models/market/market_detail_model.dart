//商品详情-获取当前尺码与在售库存
class MarketDetailModel {
  num onSaleCount;
  List<SizeListModel> marketSizeList; //  尺码列表

  MarketDetailModel({this.onSaleCount, this.marketSizeList});

  factory MarketDetailModel.fromJson(Map<String, dynamic> json) {
    List<SizeListModel> temp = [];
    if (json['marketSizeList'] != null) {
      (json['marketSizeList'] as List).forEach((element) {
        temp.add(SizeListModel.fromJson(element));
      });
    }

    return MarketDetailModel(onSaleCount: json['onSaleCount'], marketSizeList: temp);
  }

  Map<String, dynamic> toJson() => {
        'onSaleCount': onSaleCount,
        'marketSizeList': marketSizeList?.map((v) => v.toJson())?.toList(),
      };
}

class SizeListModel {
  String storeIdStr;
  String size;
  String specification;
  num sellerCount;

  SizeListModel({
    this.storeIdStr,
    this.size,
    this.specification,
    this.sellerCount,
  });

  factory SizeListModel.fromJson(Map<String, dynamic> json) {
    print('112 ==  ${json.toString()}');
    return SizeListModel(
      storeIdStr: json['storeIdStr'],
      size: json['size'],
      specification: json['specification'],
      sellerCount: json['sellerCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'storeIdStr': storeIdStr,
        'size': size,
        'sellerCount': sellerCount,
      };
}
