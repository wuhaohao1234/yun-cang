// 集市模块-集市在售-商品详情-出货列表数据

class ShipmentModel {
  String status;
  String appPrice;
  String skuMaster;
  String count;
  

  ShipmentModel({
    this.status,
    this.appPrice,
    this.skuMaster,
    this.count,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      status: json['status'],
      appPrice: json['appPrice'],
      skuMaster: json['skuMaster'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'appPrice': appPrice,
        'skuMaster': skuMaster,
        'count': count,
      };
}
