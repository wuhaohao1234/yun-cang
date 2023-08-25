class ChuHuoShipmentDefectModel {
  int id;
  int status;
  double price; //出货列表接口返回 double 类型
  String avatar;
  //增加
  String userCode;
  String depotName;
  int depotId;
  int expiration;
  String barCode;
  String size;
  String picturePath;
  String defectDegree; //出货列表接口返回 int 类型

  ChuHuoShipmentDefectModel(
      {this.id,
      this.status,
      this.price,
      this.avatar,
      this.userCode,
      this.depotId,
      this.depotName,
      this.expiration,
      this.barCode,
      this.size,
      this.picturePath,
      this.defectDegree});

  factory ChuHuoShipmentDefectModel.fromJson(Map<String, dynamic> json) {
    return ChuHuoShipmentDefectModel(
      id: json['id'],
      status: json['status'],
      price: (json['price'] == null ? 0 : json['price']).toDouble(),
      avatar: json['avatar'],
      userCode: json['userCode'],
      depotName: json['depotName'],
      depotId: json['depotId'],
      expiration: json['expiration'],
      barCode: json['barCode'],
      size: json['size'],
      picturePath: json['picturePath'],
      defectDegree: json['defectDegree'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'price': price,
        'avatar': avatar,
        'userCode': userCode,
        'depotName': depotName,
        'depotId': depotId,
        'expiration': expiration,
        'barCode': barCode,
        'size': size,
        'picturePath': picturePath,
        'defectDegree': defectDegree
      };
}
