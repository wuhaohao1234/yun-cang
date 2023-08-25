// 商品模型
// 扫码查询商品
//需要修改size，skuId

import 'en_shangpin_sku_model.dart';
import 'en_spuid_model.dart';
// import '../en_sku_detail_model.dart';

class ENShangPingModel {
  int spuId;
  dynamic skuId;
  String picturePath;
  String stockCode;
  String brandName;
  num prepareOrderId;
  String commodityName;
  ENShangPinSkuListModel sysPrepareOrderSpuList;
  ENSpuSkuListModel skuList;
  List skuAndSize;

  ENShangPingModel({
    this.spuId,
    this.skuId,
    this.picturePath,
    this.stockCode,
    this.brandName,
    this.prepareOrderId,
    this.skuList,
    this.sysPrepareOrderSpuList,
    this.commodityName,
    this.skuAndSize,
  });

  factory ENShangPingModel.fromJson(Map<String, dynamic> json) {
    return ENShangPingModel(
      spuId: json["spu"]['spuId'],
      picturePath: json["spu"]['picturePath'],
      stockCode: json["spu"]['stockCode'],
      brandName: json["spu"]['brandName'],
      prepareOrderId: json['prepareOrderId'],
      skuList: json['spu']['skuList'],
      // sysPrepareOrderSpuList: json['spu']['sysPrepareOrderSpuList'],
      sysPrepareOrderSpuList: ENShangPinSkuListModel.fromJson(
        {'sysPrepareOrderSpuList': json['spu']['sysPrepareOrderSpuList']},
      ),
      skuId: json['spu']['sysPrepareOrderSpuList'][0]['skuId'],
      commodityName: json['spu']['commodityName'],
      skuAndSize: json['spu']['sysPrepareOrderSpuList']
          .map((v) => {
                'skuId': v['skuId'],
                'size': v['size'] ?? '无尺码',
                'specification': v['specification'] ?? null,
                'skuCode': v['skuCode']
              })
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'spuId': spuId,
        'skuId': skuId,
        'picturePath': picturePath,
        'stockCode': stockCode,
        'brandName': brandName,
        'prepareOrderId': prepareOrderId,
        'skuList': skuList,
        'sysPrepareOrderSpuList': sysPrepareOrderSpuList,
        'commodityName': commodityName,
        'skuAndSize': skuAndSize,
      };
}

class ENShangPingStockModel {
  int spuId;
  String picturePath;
  String stockCode;
  String brandName;
  String commodityName;

  ENShangPingStockModel({
    this.spuId,
    this.picturePath,
    this.stockCode,
    this.brandName,
    this.commodityName,
  });

  factory ENShangPingStockModel.fromJson(Map<String, dynamic> json) {
    return ENShangPingStockModel(
      spuId: json['spuId'],
      picturePath: json['picturePath'],
      stockCode: json['stockCode'],
      brandName: json['brandName'],
      commodityName: json['commodityName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'spuId': spuId,
        'picturePath': picturePath,
        'stockCode': stockCode,
        'brandName': brandName,
        'commodityName': commodityName,
      };
}
