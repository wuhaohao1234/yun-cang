import 'market_all_detail_model.dart';

class ChuHuoShipmentNormalModel {
  int id;
  String status;
  double appPrice; //出货列表接口返回 double 类型
  String avatar;
  num stockCount;
  String skuMaster;
  int count; //出货列表接口返回 int 类型
  List sysPrepareSkuId;
  int sysPrepareSkuIdLength;
  List<SysPrepareSkuListItem> sysPrepareSkuList;
  //增加
  String userCode;
  num previewPrice;
  String depotName;
  int depotId;
  int expiration;
  List<SizeModel> sizeList;

  ChuHuoShipmentNormalModel(
      {this.id,
      this.status,
      this.appPrice,
      this.avatar,
      this.skuMaster,
      this.count,
      this.sysPrepareSkuId,
      this.sysPrepareSkuIdLength,
      this.sysPrepareSkuList,
      this.userCode,
      this.previewPrice,
      this.depotId,
      this.depotName,
      this.expiration,
      this.sizeList});

  factory ChuHuoShipmentNormalModel.fromJson(Map<String, dynamic> json) {
    List<SysPrepareSkuListItem> sysPrepareSkuListTmp;
    if (json['sysPrepareSkuList'] != null) {
      sysPrepareSkuListTmp = [];
      (json['sysPrepareSkuList'] as List).forEach((element) {
        sysPrepareSkuListTmp.add(SysPrepareSkuListItem.fromJson(element));
      });
    }

    List<SizeModel> sizeListTmp;
    if (json['sizeList'] != null) {
      sizeListTmp = [];
      (json['sizeList'] as List).forEach((element) {
        sizeListTmp.add(SizeModel.fromJson(element));
      });
    }
    return ChuHuoShipmentNormalModel(
      id: json['id'],
      status: json['status'],
      appPrice: (json['appPrice'] == null ? 0 : json['appPrice']).toDouble(),
      avatar: json['avatar'],
      skuMaster: json['skuMaster'],
      count: json['count'],
      sysPrepareSkuId: json['sysPrepareSkuId'],
      sysPrepareSkuIdLength: json['sysPrepareSkuIdLength'],
      sysPrepareSkuList: sysPrepareSkuListTmp,
      userCode: json['userCode'],
      previewPrice: json['previewPrice'],
      depotName: json['depotName'],
      depotId: json['depotId'],
      expiration: json['expiration'],
      sizeList: sizeListTmp,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'appPrice': appPrice,
        'avatar': avatar,
        'skuMaster': skuMaster,
        'count': count,
        'sysPrepareSkuId': sysPrepareSkuId,
        'sysPrepareSkuIdLength': sysPrepareSkuIdLength,
        'userCode': userCode,
        'previewPrice': previewPrice,
        'depotName': depotName,
        'depotId': depotId,
        'expiration': expiration,
        'sizeList': sizeList,
      };
}

class SysPrepareSkuListItem {
  num id;
  String barCode;
  String imgUrl;
  bool selected;
  SysPrepareSkuListItem({this.id, this.barCode, this.imgUrl, this.selected});
  factory SysPrepareSkuListItem.fromJson(Map<String, dynamic> json) {
    return SysPrepareSkuListItem(
        id: json['id'],
        barCode: json['barCode'],
        imgUrl: json['imgUrl'],
        selected: false);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'barCode': barCode,
        'imgUrl': imgUrl,
        'selected': selected,
      };
}
