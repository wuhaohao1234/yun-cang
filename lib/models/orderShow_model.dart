// To parse this JSON data, do
//
//     final orderShowModel = orderShowModelFromJson(jsonString);

import 'dart:convert';

OrderShowModel orderShowModelFromJson(String str) =>
    OrderShowModel.fromJson(json.decode(str));

String orderShowModelToJson(OrderShowModel data) => json.encode(data.toJson());

class OrderShowModel {
  OrderShowModel({
    // this.userName,
    // this.userPhone,
    // this.province,
    // this.city,
    // this.area,
    // this.address,
    // this.zipCode,
    this.tenantUserCode,
    this.unitPrice,
    this.notes,
    this.selected,
    this.wmsUserOrderDetailsList,
  });

  // String userName;
  // String userPhone;
  // String province;
  // String city;
  // String area;
  // String address;
  // String zipCode;
  String tenantUserCode;
  String unitPrice;
  String notes;
  bool selected;
  List<WmsUserOrderDetailsList> wmsUserOrderDetailsList;

  factory OrderShowModel.fromJson(Map<String, dynamic> json) => OrderShowModel(
        // userName: json["userName"],
        // userPhone: json["userPhone"],
        // province: json["province"],
        // city: json["city"],
        // area: json["area"],
        // address: json["address"],
        // zipCode: json["zipCode"],
        tenantUserCode: json["tenantUserCode"],
        unitPrice: json["unitPrice"],
        notes: json["notes"],
        selected: json["selected"],
        wmsUserOrderDetailsList: List<WmsUserOrderDetailsList>.from(
            json["wmsUserOrderDetailsList"]
                .map((x) => WmsUserOrderDetailsList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "userName": userName,
        // "userPhone": userPhone,
        // "province": province,
        // "city": city,
        // "area": area,
        // "address": address,
        // "zipCode": zipCode,
        "tenantUserCode": tenantUserCode,
        "unitPrice": unitPrice,
        "notes": notes,
        "selected": selected,
        "wmsUserOrderDetailsList":
            List<dynamic>.from(wmsUserOrderDetailsList.map((x) => x.toJson())),
      };
}

class WmsUserOrderDetailsList {
  WmsUserOrderDetailsList({
    this.skuId,
    this.sysPrepareSkuIds,
    this.sysPrepareSkuIdLength,
    this.productName,
    this.commodityName,
    this.size,
    this.color,
    this.count,
    this.picturePath,
    this.brandNameCn,
    this.stockCode,
    this.appPrice,
  });

  int skuId;
  List<dynamic> sysPrepareSkuIds;
  int sysPrepareSkuIdLength;
  String productName;
  String commodityName;
  String size;
  String color;
  int count;
  String picturePath;
  String brandNameCn;
  String stockCode;
  double appPrice;

  factory WmsUserOrderDetailsList.fromJson(Map<String, dynamic> json) =>
      WmsUserOrderDetailsList(
        skuId: json["skuId"],
        sysPrepareSkuIds:
            List<dynamic>.from(json["sysPrepareSkuIds"].map((x) => x)),
        sysPrepareSkuIdLength: json["sysPrepareSkuIdLength"],
        productName: json["product_name"],
        commodityName: json["commodityName"],
        size: json["size"],
        color: json["color"],
        count: json["count"],
        picturePath: json["picturePath"],
        brandNameCn: json["brandNameCn"],
        stockCode: json["stockCode"],
        appPrice: json["appPrice"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "skuId": skuId,
        "sysPrepareSkuIds": List<dynamic>.from(sysPrepareSkuIds.map((x) => x)),
        "product_name": productName,
        "sysPrepareSkuIdLength": sysPrepareSkuIdLength,
        "commodityName": commodityName,
        "size": size,
        "color": color,
        "count": count,
        "picturePath": picturePath,
        "brandNameCn": brandNameCn,
        "stockCode": stockCode,
        "appPrice": appPrice,
      };
}
