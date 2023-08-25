class SkuListItem {
  num id;
  String commodityName; // 编号
  String brandNameCn; // 商品名称
  String barCode; // 品牌中文名称
  String specification;
  String size; // 条形码
  String imgUrl; // 图片
  String color; // 颜色
  String status; // 状态(0：正常 1：瑕疵)
  int skuNumber;
  String skuName;
  bool selected;
  int skuId;

  String itemImg;

  SkuListItem({
    this.id,
    this.commodityName,
    this.brandNameCn,
    this.barCode,
    this.imgUrl,
    this.size,
    this.specification,
    this.color,
    this.status,
    this.skuNumber,
    this.skuName,
    this.selected = false,
    this.skuId,
    this.itemImg,
  });

  factory SkuListItem.fromJson(Map<String, dynamic> json) {
    return SkuListItem(
      id: json['id'],
      commodityName: json['commodityName'],
      brandNameCn: json['brandNameCn'],
      barCode: json['barCode'],
      size: json['size'],
      specification: json['specification'],
      imgUrl: json['imgUrl'],
      color: json['color'],
      status: json['status'],
      skuNumber: json['skuNumber'],
      skuName: json["skuName"],
      selected: json["selected"],
      skuId: json["skuId"],
      itemImg: json["itemImg"],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'commodityName': commodityName,
        'brandNameCn': brandNameCn,
        'barCode': barCode,
        'size': size,
        'specification': specification,
        'imgUrl': imgUrl,
        'color': color,
        'status': status,
        'skuNumber': skuNumber,
        "skuName": skuName,
        "selected": selected,
        "skuId": skuId,
        "itemImg": itemImg,
      };
}
