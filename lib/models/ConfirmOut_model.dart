// To parse this JSON data, do
//
//     final confirmOutModel = confirmOutModelFromJson(jsonString);

import 'dart:convert';

ConfirmOutModel confirmOutModelFromJson(String str) => ConfirmOutModel.fromJson(json.decode(str));

String confirmOutModelToJson(ConfirmOutModel data) => json.encode(data.toJson());

class ConfirmOutModel {
  ConfirmOutModel({
    this.searchValue,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.params,
    this.id,
    this.barCode,
    this.categoryName,
    this.commodityName,
    this.brandNameCn,
    this.size,
    this.color,
    this.status,
    this.sellStatus,
    this.customerCode,
    this.imgUrl,
    this.picturePath,
    this.stockCode,
    this.qty,
    this.forSaleQty,
    this.isForSale,
    this.categoryId,
    this.brandId,
    this.spuId,
    this.skuId,
    this.childrenList,
    this.sizeList,
  });

  dynamic searchValue;
  dynamic createBy;
  dynamic createTime;
  dynamic updateBy;
  dynamic updateTime;
  dynamic remark;
  Params params;
  int id;
  String barCode;
  dynamic categoryName;
  String commodityName;
  String brandNameCn;
  String size;
  dynamic color;
  String status;
  dynamic sellStatus;
  dynamic customerCode;
  dynamic imgUrl;
  dynamic picturePath;
  dynamic stockCode;
  dynamic qty;
  dynamic forSaleQty;
  dynamic isForSale;
  dynamic categoryId;
  dynamic brandId;
  dynamic spuId;
  dynamic skuId;
  dynamic childrenList;
  dynamic sizeList;

  factory ConfirmOutModel.fromJson(Map<String, dynamic> json) => ConfirmOutModel(
        searchValue: json["searchValue"],
        createBy: json["createBy"],
        createTime: json["createTime"],
        updateBy: json["updateBy"],
        updateTime: json["updateTime"],
        remark: json["remark"],
        params: Params.fromJson(json["params"]),
        id: json["id"],
        barCode: json["barCode"],
        categoryName: json["categoryName"],
        commodityName: json["commodityName"],
        brandNameCn: json["brandNameCn"],
        size: json["size"],
        color: json["color"],
        status: json["status"],
        sellStatus: json["sellStatus"],
        customerCode: json["customerCode"],
        imgUrl: json["imgUrl"],
        picturePath: json["picturePath"],
        stockCode: json["stockCode"],
        qty: json["qty"],
        forSaleQty: json["forSaleQty"],
        isForSale: json["isForSale"],
        categoryId: json["categoryId"],
        brandId: json["brandId"],
        spuId: json["spuId"],
        skuId: json["skuId"],
        childrenList: json["childrenList"],
        sizeList: json["sizeList"],
      );

  Map<String, dynamic> toJson() => {
        "searchValue": searchValue,
        "createBy": createBy,
        "createTime": createTime,
        "updateBy": updateBy,
        "updateTime": updateTime,
        "remark": remark,
        "params": params.toJson(),
        "id": id,
        "barCode": barCode,
        "categoryName": categoryName,
        "commodityName": commodityName,
        "brandNameCn": brandNameCn,
        "size": size,
        "color": color,
        "status": status,
        "sellStatus": sellStatus,
        "customerCode": customerCode,
        "imgUrl": imgUrl,
        "picturePath": picturePath,
        "stockCode": stockCode,
        "qty": qty,
        "forSaleQty": forSaleQty,
        "isForSale": isForSale,
        "categoryId": categoryId,
        "brandId": brandId,
        "spuId": spuId,
        "skuId": skuId,
        "childrenList": childrenList,
        "sizeList": sizeList,
      };
}

class Params {
  Params();

  factory Params.fromJson(Map<String, dynamic> json) => Params();

  Map<String, dynamic> toJson() => {};
}
