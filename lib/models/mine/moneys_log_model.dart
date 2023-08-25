class MoneysLogModel {
  num id;
  String createTime;
  String remark;
  String sendId; //发送者id
  String sendUserCode; //发送者客户代码
  String getId; // 获得者id
  String getUserCode; // 获得者客户代码
  num moneyType; // /** 流水标志 0:支出 1:收入 2:提现*/
  String orderNo; // 订单号
  num money; // 金额

  MoneysLogModel({
    this.id,
    this.createTime,
    this.sendId,
    this.sendUserCode,
    this.getId,
    this.remark,
    this.getUserCode,
    this.moneyType,
    this.orderNo,
    this.money,
  });

  factory MoneysLogModel.fromJson(Map<String, dynamic> json) {
    return MoneysLogModel(
      id: json['id'],
      createTime: json['createTime'],
      remark: json['remark'],
      sendId: json['sendId'],
      sendUserCode: json['sendUserCode'],
      getId: json['getId'],
      getUserCode: json['getUserCode'],
      moneyType: json['moneyType'],
      orderNo: json['orderNo'],
      money: json['money'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sendId': sendId,
        'remark': remark,
        'createTime': createTime,
        'sendUserCode': sendUserCode,
        'getId': getId,
        'getUserCode': getUserCode,
        'moneyType': moneyType,
        'orderNo': orderNo,
        'money': money,
      };
}
