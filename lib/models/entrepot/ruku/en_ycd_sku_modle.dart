class ENYcdSkuModle {
  num id;
  String imgUrl;
  String skuName;
  String size;
  String status;

  ENYcdSkuModle({
    this.id,
    this.imgUrl,
    this.skuName,
    this.size,
    this.status,
  });

  factory ENYcdSkuModle.fromJson(Map<String, dynamic> json) {
    return ENYcdSkuModle(
      id: json['id'],
      imgUrl: json['imgUrl'],
      skuName: json['skuName'],
      size: json['size'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'skuName': skuName,
        'imgUrl': imgUrl,
        'size': size,
        'status': status,
      };
}
