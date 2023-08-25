/// Create by bigv on 21-7-20
/// Description:  api: ExceptionListDetailModel
/// /user/api/prepareOrder/selectExceptionSkuSendBack
/// 选择瑕疵瑕商品返回数据
import 'dart:convert';

SelectExceptionSkuSendBack exceptionListDetailModelFromJson(String str) =>
    SelectExceptionSkuSendBack.fromJson(json.decode(str));

String exceptionListDetailModelToJson(SelectExceptionSkuSendBack data) => json.encode(data.toJson());

class SelectExceptionSkuSendBack {
  SelectExceptionSkuSendBack({
    this.searchValue,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.params,
    this.id,
    this.barCode,
    this.size,
    this.color,
    this.commodityName,
    this.brandNameCn,
    this.imgUrl,
  });

  dynamic searchValue;
  dynamic createBy;
  String createTime;
  dynamic updateBy;
  dynamic updateTime;
  dynamic remark;
  dynamic params;
  int id;
  String barCode;
  String size;
  String color;
  String commodityName;
  String brandNameCn;
  String imgUrl;

  factory SelectExceptionSkuSendBack.fromJson(Map<String, dynamic> json) => SelectExceptionSkuSendBack(
        searchValue: json["searchValue"],
        createBy: json["createBy"],
        createTime: json["createTime"],
        updateBy: json["updateBy"],
        updateTime: json["updateTime"],
        remark: json["remark"],
        params: json["params"],
        id: json["id"],
        barCode: json["barCode"],
        size: json["size"],
        color: json["color"],
        commodityName: json["commodityName"],
        brandNameCn: json["brandNameCn"],
        imgUrl: json["imgUrl"],
      );

  Map<String, dynamic> toJson() => {
        "searchValue": searchValue,
        "createBy": createBy,
        "createTime": createTime,
        "updateBy": updateBy,
        "updateTime": updateTime,
        "remark": remark,
        "params": params,
        "id": id,
        "barCode": barCode,
        "size": size,
        "color": color,
        "commodityName": commodityName,
        "brandNameCn": brandNameCn,
        "imgUrl": imgUrl,
      };
}
