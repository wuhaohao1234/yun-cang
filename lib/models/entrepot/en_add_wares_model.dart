class ENAddWaresModel{

  String orderId;
  String barCode;
  String skuCode;
  String itemImg;
  String imgUrl;
  int status;
  ENAddWaresModel({
    this.orderId,
    this.barCode,
    this.skuCode,
    this.itemImg,
    this.imgUrl,
    this.status
});

  factory ENAddWaresModel.fromJson(Map<String, dynamic> json) {
    return ENAddWaresModel(
      orderId: json['orderId'],
      barCode: json['barCode'],
      skuCode: json['skuCode'],
      itemImg: json['itemImg'],
      imgUrl: json['imgUrl'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'barCode': barCode,
    'skuCode': skuCode,
    'itemImg': itemImg,
    'imgUrl': imgUrl,
    'status': status,
  };

}