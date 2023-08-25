// 在售列表model

class OnSaleCommodityModel {
  String depotName; //仓库名称,新增
  num depotId;
  String size;
  String specification;
  String color;
  String brandNameCn;
  num saleCount;
  String updateTime;
  String picturePath;
  String commodityName;
  String stringStoreIds;
  String stringdepotId;
  num resalePrice;
  int spuId;

  OnSaleCommodityModel(
      {this.depotName,
      this.depotId,
      this.size,
      this.specification,
      this.color,
      this.brandNameCn,
      this.saleCount,
      this.updateTime,
      this.picturePath,
      this.commodityName,
      this.stringStoreIds,
      this.stringdepotId,
      this.resalePrice,
      this.spuId});

  factory OnSaleCommodityModel.fromJson(Map<String, dynamic> json) {
    return OnSaleCommodityModel(
      depotName: json['depotName'],
      depotId: json['depotId'],
      size: json['size'],
      specification: json['specification'],
      color: json['color'],
      brandNameCn: json['brandNameCn'],
      saleCount: json['saleCount'],
      updateTime: json['updateTime'],
      picturePath: json['picturePath'],
      commodityName: json['commodityName'],
      stringStoreIds: json['stringStoreIds'],
      stringdepotId: json['stringdepotId'],
      resalePrice: json['resalePrice'],
      spuId: json['spuId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'depotName': depotName,
        'depotId': depotId,
        'size': size,
        'specification': specification,
        'color': color,
        'brandNameCn': brandNameCn,
        'saleCount': saleCount,
        'updateTime': updateTime,
        'picturePath': picturePath,
        'commodityName': commodityName,
        'stringStoreIds': stringStoreIds,
        'stringdepotId': stringdepotId,
        'resalePrice': resalePrice,
        'spuId': spuId
      };
}
