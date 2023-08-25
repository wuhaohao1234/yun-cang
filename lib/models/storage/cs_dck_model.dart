//客户端临存出库模型
import 'package:wms/models/storage/sku_list_item.dart';

class CsChuKuModel {
  num prepareOrderId;
  String prepareOrderName;
  String mailNo;
  String outStoreName;
  int boxTotal;
  int skusTotal;
  int skuTotal;
  int boxTotalFact;
  String instoreOrderImg;
  String outSkuOrderImg;
  String depotName;

  num wmsOutStoreId; // 出库单单号
  String wmsOutStoreName; // 	出库单单号
  String createTime; // 	出库时间
  String consigneeName; // 收件人名称
  String consigneePhone; // 收件人电话
  String consigneeProvince; // 收件人省
  String consigneeCity; // 收件人市
  String consigneeDistrict; // 收件人区
  String consigneeAddress; // 收件人街道地址
  String logisticsName; //配送方式
  String expressNumber; //
  List<SkuListItem> skuList;

  CsChuKuModel(
      {this.prepareOrderId,
      this.prepareOrderName,
      this.mailNo,
      this.outStoreName,
      this.boxTotal,
      this.skusTotal,
      this.skuTotal,
      this.boxTotalFact,
      this.instoreOrderImg,
      this.depotName,
      this.wmsOutStoreId,
      this.wmsOutStoreName,
      this.createTime,
      this.consigneeName,
      this.consigneePhone,
      this.consigneeProvince,
      this.consigneeCity,
      this.consigneeDistrict,
      this.consigneeAddress,
      this.skuList,
      this.logisticsName,
      this.expressNumber,
      this.outSkuOrderImg});

  factory CsChuKuModel.fromJson(Map<String, dynamic> json) {
    List<SkuListItem> temps;
    if (json['skuList'] != null) {
      temps = [];
      (json['skuList'] as List).forEach((element) {
        temps.add(
          SkuListItem.fromJson(element),
        );
      });
    }
    return CsChuKuModel(
      prepareOrderId: json['prepareOrderId'],
      prepareOrderName: json['prepareOrderName'],
      mailNo: json['mailNo'],
      outStoreName: json['outStoreName'],
      boxTotal: json['boxTotal'],
      skusTotal: json['skusTotal'],
      skuTotal: json['skuTotal'],
      boxTotalFact: json['boxTotalFact'],
      instoreOrderImg: json['instoreOrderImg'],
      depotName: json['depotName'],
      wmsOutStoreId: json['wmsOutStoreId'],
      wmsOutStoreName: json['wmsOutStoreName'],
      createTime: json['createTime'],
      consigneeName: json['consigneeName'],
      consigneePhone: json['consigneePhone'],
      consigneeProvince: json['consigneeProvince'],
      consigneeCity: json['consigneeCity'],
      consigneeDistrict: json['consigneeDistrict'],
      consigneeAddress: json['consigneeAddress'],
      logisticsName: json['logisticsName'],
      expressNumber: json['expressNumber'],
      skuList: temps,
      outSkuOrderImg: json['outSkuOrderImg'],
    );
  }

  Map<String, dynamic> toJson() => {
        'prepareOrderId': prepareOrderId,
        'prepareOrderName': prepareOrderName,
        'mailNo': mailNo,
        'outStoreName': outStoreName,
        'boxTotal': boxTotal,
        'skusTotal': skusTotal,
        'skuTotal': skuTotal,
        'boxTotalFact': boxTotalFact,
        'instoreOrderImg': instoreOrderImg,
        'depotName': depotName,
        'wmsOutStoreId': wmsOutStoreId,
        'wmsOutStoreName': wmsOutStoreName,
        'outTime': createTime,
        'consigneeName': consigneeName,
        'consigneePhone': consigneePhone,
        'consigneeProvince': consigneeProvince,
        'consigneeCity': consigneeCity,
        'consigneeDistrict': consigneeDistrict,
        'consigneeAddress': consigneeAddress,
        'logisticsName': logisticsName,
        'expressNumber': expressNumber,
        'skuList': skuList,
        'outSkuOrderImg': outSkuOrderImg,
      };
}
