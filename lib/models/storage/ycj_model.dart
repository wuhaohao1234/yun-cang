// 异常件Model
class YcjModel {
  String createTime;
  num exceptionOrderId;
  String exceptionOrderCode;
  num prepareOrderId;
  String orderIdName;
  String exceptionType;
  String customerCode;
  String mailNo;
  String queryFlag;
  String depotName;

  YcjModel({
    this.createTime,
    this.exceptionOrderId,
    this.exceptionOrderCode,
    this.prepareOrderId,
    this.exceptionType,
    this.customerCode,
    this.orderIdName,
    this.mailNo,
    this.queryFlag,
    this.depotName,
  });

  factory YcjModel.fromJson(Map<String, dynamic> json) {
    return YcjModel(
      createTime: json['createTime'],
      exceptionOrderId: json['exceptionOrderId'],
      exceptionOrderCode: json['exceptionOrderCode'],
      prepareOrderId: json['prepareOrderId'],
      exceptionType: json['exceptionType'],
      orderIdName: json['orderIdName'],
      mailNo: json['mailNo'],
      queryFlag: json['queryFlag'],
      depotName: json['depotName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'createTime': createTime,
        'exceptionOrderId': exceptionOrderId,
        'exceptionOrderCode': exceptionOrderCode,
        'prepareOrderId': prepareOrderId,
        'exceptionType': exceptionType,
        'orderIdName': orderIdName,
        'mailNo': mailNo,
        'queryFlag': queryFlag,
        'depotName': depotName,
      };
}
