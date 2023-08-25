// 订单模型
class ENOrderModel {
  int orderId;
  String orderIdName;
  String mailNo;
  String customerCode;
  int skusTotal;
  int boxTotal;
  String remark;
  String createTime;
  String prepareImgUrl;
  String status;
  String logisticsMode;
  num orderOperationalRequirements;
  num instoreOrderId; //入库单id
  String instoreOrderCode; //入库单编号
  num prepareOrderId; //预约入库单id
  num skusTotalFact; //实际总数

  num boxTotalFact; //实际箱数
  String instoreOrderImg;

  // 上架部分特有
  String depotPosition;
  String userCode;

  ENOrderModel({
    this.orderId,
    this.orderIdName,
    this.mailNo,
    this.customerCode,
    this.skusTotal,
    this.boxTotal,
    this.remark,
    this.createTime,
    this.prepareImgUrl,
    this.status,
    this.logisticsMode,
    this.orderOperationalRequirements,
    this.instoreOrderCode,
    this.skusTotalFact,
    this.instoreOrderId,
    this.prepareOrderId,
    this.instoreOrderImg,
    this.boxTotalFact,
    // 上架
    this.depotPosition,
    this.userCode,
  });

  factory ENOrderModel.fromJson(Map<String, dynamic> json) {
    return ENOrderModel(
      orderId: json['orderId'],
      orderIdName: json['orderIdName'],
      mailNo: json['mailNo'],
      customerCode: json['customerCode'],
      skusTotal: json['skusTotal'],
      boxTotal: json['boxTotal'],
      remark: json['remark'],
      createTime: json['createTime'],
      prepareImgUrl: json['prepareImgUrl'],
      status: json['status'],
      logisticsMode: json['logisticsMode'],
      orderOperationalRequirements: json['orderOperationalRequirements'],
      instoreOrderCode: json['instoreOrderCode'],
      skusTotalFact: json['skusTotalFact'],
      instoreOrderId: json['instoreOrderId'],
      instoreOrderImg: json['instoreOrderImg'],
      prepareOrderId: json['prepareOrderId'],

      boxTotalFact: json['boxTotalFact'].runtimeType == String
          ? int.parse(json['boxTotalFact'])
          : json['boxTotalFact'],
      // 上架
      depotPosition: json['depotPosition'],
      userCode: json['userCode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'orderIdName': orderIdName,
        'mailNo': mailNo,
        'customerCode': customerCode,
        'skusTotal': skusTotal,
        'boxTotal': boxTotal,
        'remark': remark,
        'createTime': createTime,
        'status': status,
        'prepareImgUrl': prepareImgUrl,
        'logisticsMode': logisticsMode,
        'orderOperationalRequirements': orderOperationalRequirements,
        'instoreOrderCode': instoreOrderCode,
        'skusTotalFact': skusTotalFact,
        'instoreOrderId': instoreOrderId,
        'prepareOrderId': prepareOrderId,
        'instoreOrderImg': instoreOrderImg,

        'boxTotalFact': boxTotalFact,
        // 上架
        'depotPosition': depotPosition,
        'userCode': userCode,
      };
}
