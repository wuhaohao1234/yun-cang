class MarketAllDetailModel {
  num spuId;
  String commodityName; // 	商品名称
  String brandNameCn; //	品牌中文名称
  String color; //	颜色
  String picturePath; //	图片
  int qty; //  客户在售库存
  List<SizeModel> childrenList; //  尺码列表
  String stockCode;
  String imgUrl;

  MarketAllDetailModel(
      {this.spuId,
      this.commodityName,
      this.brandNameCn,
      this.color,
      this.picturePath,
      this.qty,
      this.stockCode,
      this.childrenList,
      this.imgUrl});

  factory MarketAllDetailModel.fromJson(Map<String, dynamic> json) {
    List<SizeModel> temp = [];
    if (json['childrenList'] != null) {
      (json['childrenList'] as List).forEach((element) {
        temp.add(SizeModel.fromJson(element));
      });
    }

    return MarketAllDetailModel(
        spuId: json['spuId'],
        commodityName: json['commodityName'],
        brandNameCn: json['brandNameCn'],
        picturePath: json['picturePath'],
        color: json['color'],
        qty: json['qty'],
        stockCode: json['stockCode'],
        imgUrl: json['imgUrl'],
        childrenList: temp);
  }

  Map<String, dynamic> toJson() => {
        'spuId': spuId,
        'commodityName': commodityName,
        'picturePath': picturePath,
        'brandNameCn': brandNameCn,
        'stockCode': stockCode,
        'color': color,
        'qty': qty,
        'imgUrl': imgUrl,
        'childrenList': childrenList.map((v) => v.toJson()).toList(),
      };
}

class SizeModel {
  num skuId;
  String size;
  String specification;
  num qty;
  num price;
  num onSaleCount;
  num status;
  num id;

  SizeModel({
    this.skuId,
    this.size,
    this.specification,
    this.qty,
    this.price,
    this.onSaleCount,
    this.status,
    this.id,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    print('112 ==  ${json.toString()}');
    return SizeModel(
      skuId: json['skuId'],
      size: json['size'],
      specification: json['specification'],
      qty: json['qty'],
      price: json['price'],
      onSaleCount: json['onSaleCount'],
      status: json['status'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'skuId': skuId,
        'size': size,
        'qty': qty,
        'price': price,
        'onSaleCount': onSaleCount,
        'status': status,
        'id': id,
      };
}
