// 商品详情
class ENWaresModel {
  num id;
  String skuCode;
  String barCode;
  String itemImg; //货号图片
  String imgUrl; //商品图片
  String status;

  ENWaresModel({
    this.id,
    this.skuCode,
    this.barCode,
    this.itemImg,
    this.imgUrl,
    this.status,
  });

  factory ENWaresModel.fromJson(Map<String, dynamic> json) {
    return ENWaresModel(
      id: json['id'],
      skuCode: json['skuCode'],
      barCode: json['barCode'],
      itemImg: json['itemImg'],
      imgUrl: json['imgUrl'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'skuCode': skuCode,
        'barCode': barCode,
        'itemImg': itemImg,
        'imgUrl': imgUrl,
        'status': status,
      };
}
