// 预备入库单
class ENYbrkModel {
  int id;
  int orderId;
  String orderIdName;
  String mailNo;
  String customerCode;
  int skusTotal;
  int boxTotal;
  String remark;
  String createTime;
  String updateTime;
  String prepareImgUrl;
  String status;
  String logisticsMode;
  num orderOperationalRequirements;
  String inspectionRequirement;
  int boxTotalFact;
  String depotName;
  String ownerlessImg;
  String instoreOrderImg;

  ENYbrkModel(
      {this.id,
      this.orderId,
      this.orderIdName,
      this.mailNo,
      this.customerCode,
      this.skusTotal,
      this.boxTotal,
      this.remark,
      this.createTime,
      this.updateTime,
      this.prepareImgUrl,
      this.status,
      this.logisticsMode,
      this.orderOperationalRequirements,
      this.inspectionRequirement,
      this.boxTotalFact,
      this.depotName,
      this.ownerlessImg,
      this.instoreOrderImg});

  factory ENYbrkModel.fromJson(Map<String, dynamic> json) {
    return ENYbrkModel(
      id: json['id'],
      orderId: json['orderId'],
      orderIdName: json['orderIdName'],
      mailNo: json['mailNo'],
      customerCode: json['customerCode'],
      skusTotal: json['skusTotal'],
      boxTotal: json['boxTotal'],
      remark: json['remark'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      prepareImgUrl: json['prepareImgUrl'],
      status: json['status'],
      logisticsMode: json['logisticsMode'],
      orderOperationalRequirements: json['orderOperationalRequirements'],
      inspectionRequirement: json['inspectionRequirement'],
      boxTotalFact: json['boxTotalFact'],
      depotName: json['depotName'],
      ownerlessImg: json['ownerlessImg'],
      instoreOrderImg: json['instoreOrderImg'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'orderIdName': orderIdName,
        'mailNo': mailNo,
        'customerCode': customerCode,
        'skusTotal': skusTotal,
        'boxTotal': boxTotal,
        'remark': remark,
        'createTime': createTime,
        'updateTime': updateTime,
        'status': status,
        'prepareImgUrl': prepareImgUrl,
        'logisticsMode': logisticsMode,
        'orderOperationalRequirements': orderOperationalRequirements,
        'inspectionRequirement': inspectionRequirement,
        'boxTotalFact': boxTotalFact,
        'depotName': depotName,
        'ownerlessImg': ownerlessImg,
        'instoreOrderImg': instoreOrderImg,
      };
}
