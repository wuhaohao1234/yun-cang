/*
*   出库单详情模型
* */
import 'package:wms/models/storage/sku_list_item.dart';

class CkdDetailModel {
  num wmsOutStoreId; // 出库单单号
  String wmsOutStoreName; // 	出库单单号
  String createTime;
  String outTime; // 	出库时间
  String consigneeName; // 收件人名称
  String consigneePhone; // 收件人电话
  String consigneeProvince; // 收件人省
  String consigneeCity; // 收件人市
  String consigneeDistrict; // 收件人区
  String consigneeAddress; // 收件人街道地址
  String expressNumber; // 快递单号
  String pickUpCode; //提货码
  List<SkuListItem> skuList;

  CkdDetailModel({
    this.wmsOutStoreId,
    this.wmsOutStoreName,
    this.createTime,
    this.outTime,
    this.consigneeName,
    this.expressNumber,
    this.pickUpCode,
    this.consigneePhone,
    this.consigneeProvince,
    this.consigneeCity,
    this.consigneeDistrict,
    this.consigneeAddress,
    this.skuList,
  });

  factory CkdDetailModel.fromJson(Map<String, dynamic> json) {
    List<SkuListItem> temps;
    if (json['skuList'] != null) {
      temps = [];
      (json['skuList'] as List).forEach((element) {
        temps.add(
          SkuListItem.fromJson(element),
        );
      });
    }
    return CkdDetailModel(
      wmsOutStoreId: json['wmsOutStoreId'],
      wmsOutStoreName: json['wmsOutStoreName'],
      createTime: json['createTime'],
      outTime: json['outTime'],
      consigneeName: json['consigneeName'],
      consigneePhone: json['consigneePhone'],
      expressNumber: json['expressNumber'],
      pickUpCode: json['pickUpCode'],
      consigneeProvince: json['consigneeProvince'],
      consigneeCity: json['consigneeCity'],
      consigneeDistrict: json['consigneeDistrict'],
      consigneeAddress: json['consigneeAddress'],
      skuList: temps,
    );
  }

  Map<String, dynamic> toJson() => {
        'wmsOutStoreId': wmsOutStoreId,
        'wmsOutStoreName': wmsOutStoreName,
        'createTime': createTime,
        'outTime': outTime,
        'consigneeName': consigneeName,
        'consigneePhone': consigneePhone,
        'consigneeProvince': consigneeProvince,
        'expressNumber': expressNumber,
        'pickUpCode': pickUpCode,
        'consigneeCity': consigneeCity,
        'consigneeDistrict': consigneeDistrict,
        'consigneeAddress': consigneeAddress,
        'skuList': skuList,
      };
}
