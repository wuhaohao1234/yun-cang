// 出库单模型
class ENFenJianModel {
  int outOrderId;
  String outStoreName;
  String tenantUserCode;
  String consigneeName;
  String logisticsName;
  int spuNumber;
  int totalSku;
  int sortingSpuNumber;
  int sortingTotalSku;
  int temporaryExistenceType; //0临存出库单 1 正常出库单
  ENFenJianModel(
      {this.outOrderId,
      this.outStoreName,
      this.logisticsName,
      this.tenantUserCode,
      this.consigneeName,
      this.spuNumber,
      this.totalSku,
      this.sortingSpuNumber,
      this.sortingTotalSku,
      this.temporaryExistenceType});

  factory ENFenJianModel.fromJson(Map<String, dynamic> json) {
    return ENFenJianModel(
      outOrderId: json['outOrderId'],
      outStoreName: json['outStoreName'],
      logisticsName: json['logisticsName'],
      tenantUserCode: json['tenantUserCode'],
      consigneeName: json['consigneeName'],
      spuNumber: json['spuNumber'],
      totalSku: json['totalSku'],
      sortingSpuNumber: json['sortingSpuNumber'],
      sortingTotalSku: json['sortingTotalSku'],
      temporaryExistenceType: json['temporaryExistenceType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'outOrderId': outOrderId,
        'outStoreName': outStoreName,
        'logisticsName': logisticsName,
        'tenantUserCode': tenantUserCode,
        'consigneeName': consigneeName,
        'spuNumber': spuNumber,
        'totalSku': totalSku,
        'sortingSpuNumber': sortingSpuNumber,
        'sortingTotalSku': sortingTotalSku,
        'temporaryExistenceType': temporaryExistenceType,
      };
}
