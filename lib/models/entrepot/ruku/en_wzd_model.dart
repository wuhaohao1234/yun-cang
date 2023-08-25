class ENWzdModel {
  num id;
  String mailNo;
  String orderIdName;
  String ownerlessImg;
  String createTime;
  String depotName;

  ENWzdModel({
    this.orderIdName,
    this.mailNo,
    this.id,
    this.ownerlessImg,
    this.createTime,
    this.depotName,
  });

  factory ENWzdModel.fromJson(Map<String, dynamic> json) {
    return ENWzdModel(
      id: json['id'],
      orderIdName: json['orderIdName'],
      mailNo: json['mailNo'],
      ownerlessImg: json['ownerlessImg'],
      createTime: json['createTime'],
      depotName: json['depotName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mailNo': mailNo,
        'orderIdName': orderIdName,
        'ownerlessImg': ownerlessImg,
        'createTime': createTime,
        'depotName': depotName,
      };
}
