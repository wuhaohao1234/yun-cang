class MarketWaresModel {
  int spuId;
  String commodityName; // 	商品名称
  String brandNameCn; //	品牌中文名称
  String color; //	颜色
  String picturePath; //	图片
  num qty; //  客户在售库存
  List sizeList; //  尺码列表
  String stockCode; // 货号
  num previewPrice;
  int payerNumber;

  int id;
  String size;
  String status;
  String imgUrl;
  String isForSale;
  bool selected;
  String barCode;
  int categoryId;

  String spuCode;
  String vendor;
  String articleNumber;
  String brandName;
  String remark;
  String nation;
  String customsCode;
  String detail;
  String categoryName;
  String appPicturePath;
  bool bidAcrossBorders;

  MarketWaresModel({
    this.spuId,
    this.commodityName,
    this.brandNameCn,
    this.color,
    this.picturePath,
    this.qty,
    this.sizeList,
    this.stockCode,
    this.previewPrice,
    this.payerNumber,
    this.id,
    this.size,
    this.status,
    this.imgUrl,
    this.isForSale,
    this.selected,
    this.barCode,
    this.categoryId,
    this.spuCode,
    this.vendor,
    this.articleNumber,
    this.brandName,
    this.remark,
    this.nation,
    this.customsCode,
    this.detail,
    this.categoryName,
    this.appPicturePath,
    this.bidAcrossBorders,
  });

  factory MarketWaresModel.fromJson(Map<String, dynamic> json) {
    return MarketWaresModel(
      spuId: json['spuId'],
      commodityName: json['commodityName'],
      brandNameCn: json['brandNameCn'],
      picturePath: json['picturePath'],
      color: json['color'],
      qty: json['qty'],
      sizeList: json['sizeList'],
      stockCode: json['stockCode'],
      previewPrice: json['previewPrice'],
      payerNumber: json['payerNumber'],
      id: json["id"],
      size: json["size"],
      status: json["status"],
      imgUrl: json["imgUrl"],
      isForSale: json["isForSale"],
      selected: json["selected"],
      barCode: json["barCode"],
      categoryId: json["categoryId"],
      spuCode: json["spuCode"],
      vendor: json["vendor"],
      articleNumber: json["articleNumber"],
      brandName: json["brandName"],
      remark: json["remark"],
      nation: json["nation"],
      customsCode: json["customsCode"],
      detail: json["detail"],
      categoryName: json["categoryName"],
      appPicturePath: json["appPicturePath"],
      bidAcrossBorders: json["bidAcrossBorders"],
    );
  }

  Map<String, dynamic> toJson() => {
        'spuId': spuId,
        'commodityName': commodityName,
        'picturePath': picturePath,
        'brandNameCn': brandNameCn,
        'color': color,
        'qty': qty,
        'sizeList': sizeList,
        'stockCode': stockCode,
        'previewPrice': previewPrice,
        'payerNumber': payerNumber,
        "id": id,
        "size": size,
        "status": status,
        "imgUrl": imgUrl,
        "isForSale": isForSale,
        "selected": selected,
        "barCode": barCode,
        "categoryId": categoryId,
        'spuCode': spuCode,
        'vendor': vendor,
        'articleNumber': articleNumber,
        'brandName': brandName,
        'remark': remark,
        'nation': nation,
        'customsCode': customsCode,
        'detail': detail,
        'categoryName': categoryName,
        'appPicturePath': appPicturePath,
        'bidAcrossBorders': bidAcrossBorders,
      };
}
