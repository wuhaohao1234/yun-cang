class ENCommodityModel {
  num spuId;
  String spuCode;
  String picturePath; //	图片
  String vendor;
  String articleNumber;
  String stockCode;
  String commodityName; // 	商品名称
  String color; //	颜色
  num categoryId;
  String categoryName;
  num brandId;
  String brandName;
  num sizeTemplateId;
  String sizeTemplateName;
  String status;
  String remark;
  List skuList; //skuList
  String nation;
  String customerCode;
  String detail;
  String wmsCategory;
  String declareGoodsName;
  String skuCode;
  String depotPostion;
  List sysPrepareOrderSpuList; //sysPrepareOrderSpuList

  ENCommodityModel({
    this.spuId,
    this.spuCode,
    this.picturePath,
    this.vendor,
    this.articleNumber,
    this.stockCode,
    this.commodityName,
    this.color,
    this.categoryId,
    this.categoryName,
    this.brandName,
    this.brandId,
    this.sizeTemplateId,
    this.sizeTemplateName,
    this.status,
    this.remark,
    this.skuList,
    this.nation,
    this.customerCode,
    this.detail,
    this.wmsCategory,
    this.declareGoodsName,
    this.skuCode,
    this.depotPostion,
    this.sysPrepareOrderSpuList,
  });

  factory ENCommodityModel.fromJson(Map<String, dynamic> json) {
    // List<SizeModel> temp = [];
    // if (json['childrenList'] != null) {
    //   (json['childrenList'] as List).forEach((element) {
    //     temp.add(SizeModel.fromJson(element));
    //   });
    // }
    return ENCommodityModel(
      // childrenList: temp,
      spuId: json['spuId'],
      spuCode: json['spuCode'],
      picturePath: json['picturePath'],
      vendor: json['vendor'],
      articleNumber: json['articleNumber'],
      stockCode: json['stockCode'],
      commodityName: json['commodityName'],
      color: json['color'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      brandId: json['brandId'],
      brandName: json['brandName'],
      sizeTemplateId: json['sizeTemplateId'],
      sizeTemplateName: json['sizeTemplateName'],
      status: json['status'],
      remark: json['remark'],
      skuList: json['skuList'],
      nation: json['nation'],
      customerCode: json['customerCode'],
      detail: json['detail'],
      wmsCategory: json['wmsCategory'],
      declareGoodsName: json['declareGoodsName'],
      skuCode: json['skuCode'],
      depotPostion: json['depotPostion'],
      sysPrepareOrderSpuList: json['sysPrepareOrderSpuList'],
    );
  }

  Map<String, dynamic> toJson() => {
        // 'childrenList': childrenList.map((v) => v.toJson()).toList(),
        'spuId': spuId,
        'spuCode': spuCode,
        'picturePath': picturePath,
        'vendor': vendor,
        'articleNumber': articleNumber,
        'stockCode': stockCode,
        'commodityName': commodityName,
        'color': color,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'brandId': brandId,
        'brandName': brandName,
        'sizeTemplateId': sizeTemplateId,
        'sizeTemplateName': sizeTemplateName,
        'status': status,
        'remark': remark,
        'skuList': skuList,
        'nation': nation,
        'customerCode': customerCode,
        'detail': detail,
        'wmsCategory': wmsCategory,
        'declareGoodsName': declareGoodsName,
        'skuCode': skuCode,
        'depotPostion': depotPostion,
        'sysPrepareOrderSpuList':
            sysPrepareOrderSpuList.map((v) => v.toJson()).toList(),
      };
}

class SizeModel {
  num skuId;
  String size;
  num qty;
  num price;

  SizeModel({
    this.skuId,
    this.size,
    this.qty,
    this.price,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    print('112 ==  ${json.toString()}');
    return SizeModel(
      skuId: json['skuId'],
      size: json['size'],
      qty: json['qty'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {
        'skuId': skuId,
        'size': size,
        'qty': qty,
        'price': price,
      };
}
