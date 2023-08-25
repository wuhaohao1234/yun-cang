// 待理货详情model
import '../en_sku_detail_model.dart';

class ENRkdDetailModel {
  // 预约入库单编号
  num orderId;

  // 入库时间
  String createTime;

  // 入库单单号
  String inStoreOrderName;

  // 	预约数量
  num skusTotal;

  // 客户代码
  String customerCode;

  // 实际数量
  num skusTotalFact;

  // 预约图片
  String prepareImgUrl;

  // 入库图片
  String instoreOrderImg;

  //入库状态（0：临时保存；1：已提交）
  String status;

  // 商品信息
  ENSkuDetailModel skuDetail;

  ENRkdDetailModel({
    this.orderId,
    this.createTime,
    this.inStoreOrderName,
    this.skusTotal,
    this.customerCode,
    this.prepareImgUrl,
    this.instoreOrderImg,
    this.skuDetail,
    this.skusTotalFact,
    this.status,
  });

  factory ENRkdDetailModel.fromJson(Map<String, dynamic> json) {
    return ENRkdDetailModel(
      createTime: (json['createTime'] as String)?.substring(0, 19),
      orderId: json['orderId'],
      inStoreOrderName: json['inStoreOrderName'],
      skusTotal: json['skusTotal'],
      customerCode: json['customerCode'],
      prepareImgUrl: json['prepareImgUrl'],
      instoreOrderImg: json['instoreOrderImg'],
      status: json['instoreOrderStatus'],
      skusTotalFact: json['skusTotalFact'],
      skuDetail: ENSkuDetailModel.fromJson(json['skuDetail']),
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'createTime': createTime,
        'inStoreOrderName': inStoreOrderName,
        'skusTotal': skusTotal,
        'customerCode': customerCode,
        'prepareImgUrl': prepareImgUrl,
        'instoreOrderImg': instoreOrderImg,
        'skusTotalFact': skusTotalFact,
        'instoreOrderStatus': status,
        'skuDetail': skuDetail.toJson(),
      };
}
