// 出库单模型
class ENChuCangModel {
  num wmsOutStoreId;
  String wmsOutStoreName;
  String consigneeName;
  String logisticsName;
  String mailNo;
  String expressNumber;
  num sortingSpuNumber;
  num sortingTotalSku;
  String outOrderImg;
  String outSKuOrderImg;
  num skuTotal;
  num distributionId;
  num boxTotalFact;

  ENChuCangModel(
      {this.wmsOutStoreId,
      this.wmsOutStoreName,
      this.logisticsName,
      this.consigneeName,
      this.expressNumber,
      this.mailNo,
      this.sortingSpuNumber,
      this.sortingTotalSku,
      this.outOrderImg,
      this.outSKuOrderImg,
      this.skuTotal,
      this.distributionId,
      this.boxTotalFact});

  factory ENChuCangModel.fromJson(Map<String, dynamic> json) {
    return ENChuCangModel(
      wmsOutStoreId: json['wmsOutStoreId'],
      wmsOutStoreName: json['wmsOutStoreName'],
      logisticsName: json['logisticsName'],
      consigneeName: json['consigneeName'],
      mailNo: json['mailNo'],
      expressNumber: json['expressNumber'],
      sortingSpuNumber: json['sortingSpuNumber'],
      sortingTotalSku: json['sortingTotalSku'],
      outOrderImg: json['outOrderImg'],
      outSKuOrderImg: json['outSkuOrderImg'],
      skuTotal: json['skuTotal'],
      distributionId: json['distributionId'],
      boxTotalFact: json['boxTotalFact'],
    );
  }

  Map<String, dynamic> toJson() => {
        'wmsOutStoreId': wmsOutStoreId,
        'wmsOutStoreName': wmsOutStoreName,
        'logisticsName': logisticsName,
        'consigneeName': consigneeName,
        'mailNo': mailNo,
        'expressNumber': expressNumber,
        'sortingSpuNumber': sortingSpuNumber,
        'sortingTotalSku': sortingTotalSku,
        'outOrderImg': outOrderImg,
        'outSkuOrderImg': outSKuOrderImg,
        'skuTotal': skuTotal,
        'distributionId': distributionId,
        'boxTotalFact': boxTotalFact,
      };
}
