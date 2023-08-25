//客户端出库列表数据模型
class ChuKuModel {
  num wmsOutStoreId;
  String wmsOutStoreName;
  num skuTotal;
  String createTime;
  String depotName; //新增
  String logisticsName; //新增
  int distributionId;
  String expressNumber; //
  String consigneeName; // 收件人名称
  String consigneePhone; // 收件人电话
  String consigneeProvince; // 收件人省
  String consigneeCity; // 收件人市
  String consigneeDistrict; // 收件人区
  String consigneeAddress; // 收件人街道地址
  String outTime;

  ChuKuModel({
    this.wmsOutStoreId,
    this.wmsOutStoreName,
    this.skuTotal,
    this.createTime,
    this.depotName,
    this.logisticsName,
    this.distributionId,
    this.expressNumber,
    this.consigneeName,
    this.consigneePhone,
    this.consigneeProvince,
    this.consigneeCity,
    this.consigneeDistrict,
    this.consigneeAddress,
    this.outTime,
  });

  factory ChuKuModel.fromJson(Map<String, dynamic> json) {
    return ChuKuModel(
      wmsOutStoreId: json['wmsOutStoreId'],
      wmsOutStoreName: json['wmsOutStoreName'],
      skuTotal: json['skuTotal'],
      createTime: json['createTime'],
      depotName: json['depotName'],
      logisticsName: json['logisticsName'],
      distributionId: json['distributionId'],
      expressNumber: json['expressNumber'],
      consigneeName: json['consigneeName'],
      consigneePhone: json['consigneePhone'],
      consigneeProvince: json['consigneeProvince'],
      consigneeCity: json['consigneeCity'],
      consigneeDistrict: json['consigneeDistrict'],
      consigneeAddress: json['consigneeAddress'],
      outTime: json['outTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'wmsOutStoreId': wmsOutStoreId,
        'wmsOutStoreName': wmsOutStoreName,
        'skuTotal': skuTotal,
        'createTime': createTime,
        'depotName': depotName,
        'logisticsName': logisticsName,
        'distributionId': distributionId,
        'expressNumber': expressNumber,
        'consigneeName': consigneeName,
        'consigneePhone': consigneePhone,
        'consigneeProvince': consigneeProvince,
        'consigneeCity': consigneeCity,
        'consigneeDistrict': consigneeDistrict,
        'consigneeAddress': consigneeAddress,
        'outTime': outTime
      };
}
