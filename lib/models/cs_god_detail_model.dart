class CSGodDetailModel {
  // 	条形码
  String barCode;

  // 	SKU码
  String skuCode;

  // 	商品图片
  String imgUrl;

  // 货号图片
  String itemImg;

  // 	状态(0：正常 1：瑕疵)
  String status;

  num id;
  num skuId;

  CSGodDetailModel({
    this.barCode,
    this.skuCode,
    this.imgUrl,
    this.id,
    this.itemImg,
    this.status,
    this.skuId,
  });

  factory CSGodDetailModel.fromJson(Map<String, dynamic> json) {
    print(json.toString());

    return CSGodDetailModel(
      barCode: json['barCode'],
      imgUrl: json['imgUrl'],
      skuCode: json['skuCode'],
      itemImg: json['itemImg'],
      status: json['status'],
      id: json['id'],
      skuId: json['skuId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'barCode': barCode,
    'skuCode': skuCode,
    'imgUrl': imgUrl,
    'itemImg': itemImg,
    'status': status,
    'id': id,
    'skuId': skuId,
  };
}