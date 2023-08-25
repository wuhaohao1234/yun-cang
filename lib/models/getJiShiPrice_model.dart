// To parse this JSON data, do
//
//     final getJiShiPriceModel = getJiShiPriceModelFromJson(jsonString);

import 'dart:convert';

GetJiShiPriceModel getJiShiPriceModelFromJson(String str) => GetJiShiPriceModel.fromJson(json.decode(str));

String getJiShiPriceModelToJson(GetJiShiPriceModel data) => json.encode(data.toJson());

class GetJiShiPriceModel {
  GetJiShiPriceModel({
    this.searchValue,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.params,
    this.id,
    this.skuId,
    this.skuName,
    this.batchMakePlan,
    this.batchNo,
    this.skuQty,
    this.skuRemark,
    this.source,
    this.productQuality,
    this.validityDate,
    this.produceDate,
    this.count,
    this.imgUrl,
    this.vendor,
    this.barCode,
    this.status,
    this.skuQtyFact,
    this.isInStorage,
    this.perfectStatus,
    this.skuCode,
    this.itemImg,
    this.instoreOrderId,
    this.exceptionOrderId,
    this.itemCode,
    this.size,
    this.outStoreOrderId,
    this.isForSale,
    this.appPrice,
    this.dwPrice,
    this.inOrder,
    this.skuMaster,
    this.coeSkuId,
    this.tradeCountry,
  });

  dynamic searchValue;
  dynamic createBy;
  dynamic createTime;
  dynamic updateBy;
  dynamic updateTime;
  dynamic remark;
  Params params;
  dynamic id;
  int skuId;
  dynamic skuName;
  dynamic batchMakePlan;
  dynamic batchNo;
  dynamic skuQty;
  dynamic skuRemark;
  dynamic source;
  dynamic productQuality;
  dynamic validityDate;
  dynamic produceDate;
  dynamic count;
  dynamic imgUrl;
  dynamic vendor;
  dynamic barCode;
  String status;
  dynamic skuQtyFact;
  dynamic isInStorage;
  dynamic perfectStatus;
  dynamic skuCode;
  dynamic itemImg;
  dynamic instoreOrderId;
  dynamic exceptionOrderId;
  dynamic itemCode;
  String size;
  dynamic outStoreOrderId;
  dynamic isForSale;
  num appPrice;
  num dwPrice;
  dynamic inOrder;
  String skuMaster;
  dynamic coeSkuId;
  dynamic tradeCountry;

  factory GetJiShiPriceModel.fromJson(Map<String, dynamic> json) => GetJiShiPriceModel(
        searchValue: json["searchValue"],
        createBy: json["createBy"],
        createTime: json["createTime"],
        updateBy: json["updateBy"],
        updateTime: json["updateTime"],
        remark: json["remark"],
        params: Params.fromJson(json["params"]),
        id: json["id"],
        skuId: json["skuId"],
        skuName: json["skuName"],
        batchMakePlan: json["batchMakePlan"],
        batchNo: json["batchNo"],
        skuQty: json["skuQty"],
        skuRemark: json["skuRemark"],
        source: json["source"],
        productQuality: json["productQuality"],
        validityDate: json["validityDate"],
        produceDate: json["produceDate"],
        count: json["count"],
        imgUrl: json["imgUrl"],
        vendor: json["vendor"],
        barCode: json["barCode"],
        status: json["status"],
        skuQtyFact: json["skuQtyFact"],
        isInStorage: json["isInStorage"],
        perfectStatus: json["perfectStatus"],
        skuCode: json["skuCode"],
        itemImg: json["itemImg"],
        instoreOrderId: json["instoreOrderId"],
        exceptionOrderId: json["exceptionOrderId"],
        itemCode: json["itemCode"],
        size: json["size"],
        outStoreOrderId: json["outStoreOrderId"],
        isForSale: json["isForSale"],
        appPrice: json["appPrice"],
        dwPrice: json["dwPrice"],
        inOrder: json["inOrder"],
        skuMaster: json["skuMaster"],
        coeSkuId: json["coeSkuId"],
        tradeCountry: json["tradeCountry"],
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
        "skuId": skuId,
        "skuName": skuName,
        "batchMakePlan": batchMakePlan,
        "batchNo": batchNo,
        "skuQty": skuQty,
        "skuRemark": skuRemark,
        "source": source,
        "productQuality": productQuality,
        "validityDate": validityDate,
        "produceDate": produceDate,
        "count": count,
        "imgUrl": imgUrl,
        "vendor": vendor,
        "barCode": barCode,
        "status": status,
        "skuQtyFact": skuQtyFact,
        "isInStorage": isInStorage,
        "perfectStatus": perfectStatus,
        "skuCode": skuCode,
        "itemImg": itemImg,
        "instoreOrderId": instoreOrderId,
        "exceptionOrderId": exceptionOrderId,
        "itemCode": itemCode,
        "size": size,
        "outStoreOrderId": outStoreOrderId,
        "isForSale": isForSale,
        "appPrice": appPrice,
        "dwPrice": dwPrice,
        "inOrder": inOrder,
        "skuMaster": skuMaster,
        "coeSkuId": coeSkuId,
        "tradeCountry": tradeCountry,
      };
}

class Params {
  Params();

  factory Params.fromJson(Map<String, dynamic> json) => Params();

  Map<String, dynamic> toJson() => {};
}
