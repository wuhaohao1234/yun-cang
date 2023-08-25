//入库模型
class ENRkdModel {
  num instoreOrderId; //入库单id
  num orderId;
  String instoreOrderCode; //入库单编号
  num prepareOrderId; //预约入库单id
  num boxTotal; //预约箱数
  num skusTotalFact; //实际总数
  num skusTotal; //预约总数
  num boxTotalFact; //实际箱数
  String instoreOrderImg;
  num orderOperationalRequirements; //
  num spuNumber;

  // 上架部分特有
  String depotPosition;
  String userCode;
  String createTime;
  String mailNo;

  ENRkdModel({
    this.instoreOrderCode,
    this.orderId,
    this.createTime,
    this.boxTotal,
    this.skusTotalFact,
    this.skusTotal,
    this.boxTotalFact,
    this.instoreOrderId,
    this.prepareOrderId,
    this.instoreOrderImg,
    this.orderOperationalRequirements,
    this.mailNo,
    // 上架
    this.depotPosition,
    this.userCode,
    this.spuNumber,
  });

  factory ENRkdModel.fromJson(Map<String, dynamic> json) {
    return ENRkdModel(
      instoreOrderCode: json['instoreOrderCode'],
      createTime: json['createTime'],
      orderId: json['orderId'],
      mailNo: json['mailNo'],
      instoreOrderId: json['instoreOrderId'],
      instoreOrderImg: json['instoreOrderImg'],
      prepareOrderId: json['prepareOrderId'],

      skusTotal: json['skusTotal'],
      boxTotalFact: json['boxTotalFact'].runtimeType == String
          ? int.parse(json['boxTotalFact'])
          : json['boxTotalFact'],
      skusTotalFact: json['skusTotalFact'],
      boxTotal: json['boxTotal'],
      orderOperationalRequirements: json['orderOperationalRequirements'],
      // 上架
      depotPosition: json['depotPosition'],
      userCode: json['userCode'],
      spuNumber: json['spuNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'instoreOrderCode': instoreOrderCode,
        'mailNo': mailNo,
        'orderId': orderId,
        'createTime': createTime,
        'skusTotalFact': skusTotalFact,
        'boxTotal': boxTotal,
        'skusTotal': skusTotal,
        'boxTotalFact': boxTotalFact,
        'instoreOrderId': instoreOrderId,
        'prepareOrderId': prepareOrderId,
        'instoreOrderImg': instoreOrderImg,
        'orderOperationalRequirements': orderOperationalRequirements,
        // 上架
        'depotPosition': depotPosition,
        'userCode': userCode,
        'spuNumber': spuNumber,
      };
}

// ComodityModel
class ComodityModel {
  num spuId; //入库单id
  String spuCode;
  String picturePath;
  String stockCode;
  String commodityName;
  bool bidAcrossBorders;

  ComodityModel({
    this.spuId,
    this.spuCode,
    this.picturePath,
    this.stockCode,
    this.commodityName,
    this.bidAcrossBorders,
  });

  factory ComodityModel.fromJson(Map<String, dynamic> json) {
    return ComodityModel(
      spuId: json['spuId'],
      spuCode: json['spuCode'],
      picturePath: json['picturePath'],
      stockCode: json['stockCode'],
      commodityName: json['commodityName'],
      bidAcrossBorders: json['bidAcrossBorders'],
    );
  }

  Map<String, dynamic> toJson() => {
        'spuId': spuId,
        'spuCode': spuCode,
        'picturePath': picturePath,
        'stockCode': stockCode,
        'commodityName': commodityName,
        'bidAcrossBorders': bidAcrossBorders,
      };
}
