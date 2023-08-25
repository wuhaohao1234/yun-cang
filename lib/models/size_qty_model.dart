// class SizeQtyModel {
//   String size;
//   int qty;
//   int skuId;
//
//   SizeQtyModel({this.size, this.skuId, this.qty});
//
//   factory SizeQtyModel.fromJson(Map<String, dynamic> json) {
//     return SizeQtyModel(
//       size: json['size'],
//       skuId: json['skuId'],
//       qty: json['qty'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'size': size,
//     'skuId': skuId,
//     'qty': qty,
//   };
// }

// To parse this JSON data, do
//
//     final sizeQtyModel = sizeQtyModelFromJson(jsonString);

import 'dart:convert';

SizeQtyModel sizeQtyModelFromJson(String str) => SizeQtyModel.fromJson(json.decode(str));

String sizeQtyModelToJson(SizeQtyModel data) => json.encode(data.toJson());

class SizeQtyModel {
  SizeQtyModel({
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
  dynamic id;
  dynamic barCode;
  dynamic categoryName;
  dynamic commodityName;
  dynamic brandNameCn;
  String size;
  dynamic color;
  dynamic status;
  dynamic sellStatus;
  dynamic customerCode;
  dynamic imgUrl;
  dynamic picturePath;
  dynamic stockCode;
  int qty;
  dynamic forSaleQty;
  dynamic isForSale;
  dynamic categoryId;
  dynamic brandId;
  dynamic spuId;
  int skuId;
  List<ChildrenList> childrenList;
  dynamic sizeList;

  factory SizeQtyModel.fromJson(Map<String, dynamic> json) => SizeQtyModel(
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
        childrenList: List<ChildrenList>.from(json["childrenList"].map((x) => ChildrenList.fromJson(x))),
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
        "childrenList": List<dynamic>.from(childrenList.map((x) => x.toJson())),
        "sizeList": sizeList,
      };
}

class ChildrenList {
  ChildrenList({
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
    this.selected,
  });

  dynamic searchValue;
  dynamic createBy;
  dynamic createTime;
  dynamic updateBy;
  dynamic updateTime;
  dynamic remark;
  Params params;
  int id;
  dynamic barCode;
  dynamic categoryName;
  dynamic commodityName;
  dynamic brandNameCn;
  String size;
  dynamic color;
  String status;
  dynamic sellStatus;
  dynamic customerCode;
  String imgUrl;
  dynamic picturePath;
  dynamic stockCode;
  dynamic qty;
  dynamic forSaleQty;
  String isForSale;
  dynamic categoryId;
  dynamic brandId;
  dynamic spuId;
  dynamic skuId;
  dynamic childrenList;
  dynamic sizeList;
  bool selected;

  factory ChildrenList.fromJson(Map<String, dynamic> json) => ChildrenList(
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
        selected: json["selected"],
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
        "selected": selected,
      };
}

class Params {
  Params();

  factory Params.fromJson(Map<String, dynamic> json) => Params();

  Map<String, dynamic> toJson() => {};
}
