// 无主单Model
class WzdModel {
  String orderIdName;
  String mailNo;
  num id;
  
  String createTime;
  String ownerlessImg;
  String depotName;

  WzdModel(
      {this.orderIdName,
      this.mailNo,
      this.id,
      this.createTime,
      this.ownerlessImg,
      this.depotName});

  factory WzdModel.fromJson(Map<String, dynamic> json) {
    return WzdModel(
        id: json['id'],
        createTime: json['createTime'],
        mailNo: json['mailNo'],
        orderIdName: json['orderIdName'],
        ownerlessImg: json['ownerlessImg'],
        depotName: json['depotName']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createTime': createTime,
        'mailNo': mailNo,
        'orderIdName': orderIdName,
        'ownerlessImg': ownerlessImg,
        'depotName': depotName
      };
}
