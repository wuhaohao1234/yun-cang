import 'package:wms/models/entrepot/ruku/en_ycd_sku_modle.dart';

class ENYcdDetailModel {
  // 预约入库单号
  String orderIdName;

  // 异常单单号
  String exceptionOrderCode;

  // 异常类型
  String exceptionType; //
  // 	预约数量
  num skusTotal;

  // 客户代码
  String customerCode;
  String mailNo;

  // 实际数量
  num skusTotalFact;

  // 入库单号
  String instoreOrderCode;

  num exceptionOrderId;
  num instoreOrderId;
  num prepareOrderId;

  // 商品信息
  ENYcdSkuDetailModel skuDetai;

  ENYcdDetailModel({
    this.orderIdName,
    this.exceptionOrderCode,
    this.exceptionType,
    this.mailNo,
    this.skusTotal,
    this.customerCode,
    this.skusTotalFact,
    this.instoreOrderCode,
    this.exceptionOrderId,
    this.prepareOrderId,
    this.instoreOrderId,
    this.skuDetai,
  });

  factory ENYcdDetailModel.fromJson(Map<String, dynamic> json) {
    print('22222222 ==  ${json['skuDetai']}');
    return ENYcdDetailModel(
      orderIdName: json['orderIdName'],
      exceptionOrderCode: json['exceptionOrderCode'],
      exceptionType: json['exceptionType'],
      customerCode: json['customerCode'],
      skusTotal: json['skusTotal'],
      skusTotalFact: json['skusTotalFact'],
      mailNo: json['mailNo'],
      instoreOrderCode: json['instoreOrderCode'],
      exceptionOrderId: json['exceptionOrderId'],
      prepareOrderId: json['prepareOrderId'],
      instoreOrderId: json['instoreOrderId'],
      skuDetai: ENYcdSkuDetailModel.fromJson(json['skuDetai']),
    );
  }

  Map<String, dynamic> toJson() => {
        'orderIdName': orderIdName,
        'exceptionOrderCode': exceptionOrderCode,
        'exceptionType': exceptionType,
        'customerCode': customerCode,
        'skusTotal': skusTotal,
        'skusTotalFact': skusTotalFact,
        'exceptionOrderId': exceptionOrderId,
        'instoreOrderId': instoreOrderId,
        'prepareOrderId': prepareOrderId,
        'mailNo': mailNo,
        'instoreOrderCode': instoreOrderCode,
        'skuDetai': skuDetai.toJson(),
      };
}

class ENYcdSkuDetailModel {
  List<ENYcdSkuModle> skus;

  ENYcdSkuDetailModel({
    this.skus,
  });

  factory ENYcdSkuDetailModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    List<ENYcdSkuModle> temp;
    if (json['skus'] != null) {
      temp = [];
      (json['skus'] as List).forEach((element) {
        temp.add(ENYcdSkuModle.fromJson(element));
      });
    }
    return ENYcdSkuDetailModel(
      skus: temp,
    );
  }

  Map<String, dynamic> toJson() => {
        'skus': skus.map((v) => v.toJson()).toList(),
      };
}
