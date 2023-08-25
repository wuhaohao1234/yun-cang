// 出货列表数据

class ChuHuoShipmentModel {
  int id;
  String status;
  double appPrice; //出货列表接口返回 double 类型
  String avatar;
  String skuMaster;
  int count; //出货列表接口返回 int 类型
  List sysPrepareSkuId;
  int sysPrepareSkuIdLength;

  ChuHuoShipmentModel({
    this.id,
    this.status,
    this.appPrice,
    this.avatar,
    this.skuMaster,
    this.count,
    this.sysPrepareSkuId,
    this.sysPrepareSkuIdLength,
  });

  factory ChuHuoShipmentModel.fromJson(Map<String, dynamic> json) {
    return ChuHuoShipmentModel(
      id: json['id'],
      status: json['status'],
      appPrice: (json['appPrice'] == null ? 0 : json['appPrice']).toDouble(),
      avatar: json['avatar'],
      skuMaster: json['skuMaster'],
      count: json['count'],
      sysPrepareSkuId: json['sysPrepareSkuId'],
      sysPrepareSkuIdLength: json['sysPrepareSkuIdLength'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'status': status,
        'appPrice': appPrice,
        'avatar': avatar,
        'skuMaster': skuMaster,
        'count': count,
        'sysPrepareSkuId': sysPrepareSkuId,
        'sysPrepareSkuIdLength': sysPrepareSkuIdLength,
      };
}
