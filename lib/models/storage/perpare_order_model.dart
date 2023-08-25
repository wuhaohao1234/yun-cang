// 预入库单列表model

class PerpareOrderModel {
  num orderId; // 预入库订单编号

  String orderIdName; // 预入库订单编号
  num prepareOrderId; //预约入库编号
  String prepareOrderCode; //预约入库名称；
  String instoreOrderCode;
  String createTime; // 创建时间
  String customerCode; // 物主代码
  String mailNo; // 物流单号
  num skusTotal; // 物品总数
  num boxTotal; // 	箱数
  num skusTotalFact;
  String status; // 状态(0：待签收 1：认领生成 )
  String remark; // 备注
  String prepareImgUrl; // 图片
  String depotName; //仓库名称,新增
  num depotId;
  num orderOperationalRequirements; //入库要求,新增
  String instoreOrderImg;
  String outSkuOrderImg;
  String prepareOrderName;
  List wmsCommodityInfoVOList;
  String logisticsMode;
  String expressNumber;

  PerpareOrderModel(
      {this.orderId,
      this.orderIdName,
      this.prepareOrderId,
      this.prepareOrderCode,
      this.instoreOrderCode,
      this.createTime,
      this.customerCode,
      this.mailNo,
      this.skusTotal,
      this.boxTotal,
      this.skusTotalFact,
      this.status,
      this.prepareImgUrl,
      this.remark,
      this.depotName,
      this.depotId,
      this.orderOperationalRequirements,
      this.instoreOrderImg,
      this.outSkuOrderImg,
      this.prepareOrderName,
      this.wmsCommodityInfoVOList,
      this.logisticsMode,
      this.expressNumber});

  factory PerpareOrderModel.fromJson(Map<String, dynamic> json) {
    return PerpareOrderModel(
      orderId: json['orderId'],
      orderIdName: json['orderIdName'],
      prepareOrderId: json['prepareOrderId'],
      prepareOrderCode: json['prepareOrderCode'],
      instoreOrderCode: json['instoreOrderCode'],
      customerCode: json['customerCode'],
      createTime: json['createTime'],
      mailNo: json['mailNo'],
      skusTotal: json['skusTotal'],
      skusTotalFact: json['skusTotalFact'],
      boxTotal: json['boxTotal'],
      status: json['status'],
      prepareImgUrl: json['prepareImgUrl'],
      remark: json['remark'],
      depotName: json['depotName'],
      depotId: json['depotId'],
      orderOperationalRequirements: json['orderOperationalRequirements'],
      instoreOrderImg: json['instoreOrderImg'],
      outSkuOrderImg: json['outSkuOrderImg'],
      prepareOrderName: json['prepareOrderName'],
      wmsCommodityInfoVOList: json['wmsCommodityInfoVOList'],
      logisticsMode: json['logisticsMode'],
      expressNumber: json['expressNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'orderIdName': orderIdName,
        'prepareOrderId': prepareOrderId,
        'prepareOrderCode': prepareOrderCode,
        'instoreOrderCode': instoreOrderCode,
        'customerCode': customerCode,
        'createTime': createTime,
        'mailNo': mailNo,
        'skusTotal': skusTotal,
        'skusTotalFact': skusTotalFact,
        'boxTotal': boxTotal,
        'status': status,
        'prepareImgUrl': prepareImgUrl,
        'remark': remark,
        'depotName': depotName,
        'depotId': depotId,
        'orderOperationalRequirements': orderOperationalRequirements,
        'instoreOrderImg': instoreOrderImg,
        'outSkuOrderImg': outSkuOrderImg,
        'prepareOrderName': prepareOrderName,
        'wmsCommodityInfoVOList': wmsCommodityInfoVOList,
        'logisticsMode': logisticsMode,
        'expressNumber': expressNumber,
      };
}
