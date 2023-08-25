//客户端出库单列表数据模型
class CSYckdModel {
  num wmsOutStoreId; // 出库单id
  String wmsOutStoreName; // 出库单单号
  String expressNumber; // 物流单号
  num skuTotal; // 物品数量
  String outTime; // 出库日期
  String depotName; //

  CSYckdModel(
      {this.wmsOutStoreId,
      this.wmsOutStoreName,
      this.expressNumber,
      this.skuTotal,
      this.outTime,
      this.depotName});

  factory CSYckdModel.fromJson(Map<String, dynamic> json) {
    return CSYckdModel(
      wmsOutStoreId: json['wmsOutStoreId'],
      wmsOutStoreName: json['wmsOutStoreName'],
      expressNumber: json['expressNumber'],
      skuTotal: json['skuTotal'],
      outTime: json['outTime'],
      depotName: json['depotName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'wmsOutStoreId': wmsOutStoreId,
        'wmsOutStoreName': wmsOutStoreName,
        'expressNumber': expressNumber,
        'skuTotal': skuTotal,
        'outTime': outTime,
        'depotName': depotName,
      };
}
