// 客户端入库单模型
// 查询待理货或待上架订单
class RkdModel {
  String createTime;
  num instoreOrderId;
  String instoreOrderCode;
  num prepareOrderId; // 预约入库id
  String orderIdName;
  String status;
  String customerCode;
  num skusTotal;
  num skusTotalFact;
  String mailNo;

  RkdModel(
      {this.createTime,
      this.instoreOrderId,
      this.instoreOrderCode,
      this.prepareOrderId,
      this.orderIdName,
      this.status,
      this.customerCode,
      this.skusTotal,
      this.skusTotalFact,
      this.mailNo});

  factory RkdModel.fromJson(Map<String, dynamic> json) {
    return RkdModel(
      createTime: json['createTime'],
      instoreOrderId: json['instoreOrderId'],
      instoreOrderCode: json['instoreOrderCode'],
      prepareOrderId: json['prepareOrderId'],
      orderIdName: json['orderIdName'],
      status: json['status'],
      customerCode: json['customerCode'],
      skusTotal: json['skusTotal'],
      skusTotalFact: json['skusTotalFact'],
      mailNo: json['mailNo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'createTime': createTime,
        'instoreOrderId': instoreOrderId,
        'instoreOrderCode': instoreOrderCode,
        'prepareOrderId': prepareOrderId,
        'orderIdName': orderIdName,
        'status': status,
        'customerCode': customerCode,
        'skusTotal': skusTotal,
        'skusTotalFact': skusTotalFact,
        'mailNo': mailNo,
      };
}
