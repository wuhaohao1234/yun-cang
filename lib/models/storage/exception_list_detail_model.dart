/// Create by bigv on 21-7-19
/// Description:  api: ExceptionListDetailModel
/// /user/api/prepareOrder/exceptionListDetail/{exceptionOrderId}
/// 查询异常单详情
import 'dart:convert';
import 'sku_list_item.dart';

ExceptionListDetailModel exceptionListDetailModelFromJson(String str) =>
    ExceptionListDetailModel.fromJson(json.decode(str));

String exceptionListDetailModelToJson(ExceptionListDetailModel data) =>
    json.encode(data.toJson());

class ExceptionListDetailModel {
  ExceptionListDetailModel({
    this.searchValue,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.params,
    this.exceptionOrderId,
    this.exceptionOrderCode,
    this.instoreOrderId,
    this.instoreOrderCode,
    this.prepareOrderId,
    this.orderIdName,
    this.exceptionType,
    this.customerCode,
    this.skusTotal,
    this.skusTotalFact,
    this.mailNo,
    this.skuDetai,
    this.queryFlag,
    this.depotName,
  });

  dynamic searchValue;
  dynamic createBy;
  String createTime;
  dynamic updateBy;
  dynamic updateTime;
  dynamic remark;
  Params params;
  int exceptionOrderId;
  String exceptionOrderCode;
  dynamic instoreOrderId;
  String instoreOrderCode;
  dynamic prepareOrderId;
  String orderIdName;
  String exceptionType;
  String customerCode;
  int skusTotal;
  dynamic skusTotalFact;
  String mailNo;
  SkuDetai skuDetai;
  String queryFlag;
  String depotName;

  factory ExceptionListDetailModel.fromJson(Map<String, dynamic> json) =>
      ExceptionListDetailModel(
        searchValue: json["searchValue"],
        createBy: json["createBy"],
        createTime: json["createTime"],
        updateBy: json["updateBy"],
        updateTime: json["updateTime"],
        remark: json["remark"],
        params: Params.fromJson(json["params"]),
        exceptionOrderId: json["exceptionOrderId"],
        exceptionOrderCode: json["exceptionOrderCode"],
        instoreOrderId: json["instoreOrderId"],
        instoreOrderCode: json["instoreOrderCode"],
        prepareOrderId: json["prepareOrderId"],
        orderIdName: json["orderIdName"],
        exceptionType: json["exceptionType"],
        customerCode: json["customerCode"],
        skusTotal: json["skusTotal"],
        skusTotalFact: json["skusTotalFact"],
        mailNo: json["mailNo"],
        skuDetai: SkuDetai.fromJson(json["skuDetai"]),
        queryFlag: json["queryFlag"],
        depotName: json["depotName"],
      );

  Map<String, dynamic> toJson() => {
        "searchValue": searchValue,
        "createBy": createBy,
        "createTime": createTime,
        "updateBy": updateBy,
        "updateTime": updateTime,
        "remark": remark,
        "params": params.toJson(),
        "exceptionOrderId": exceptionOrderId,
        "exceptionOrderCode": exceptionOrderCode,
        "instoreOrderId": instoreOrderId,
        "instoreOrderCode": instoreOrderCode,
        "prepareOrderId": prepareOrderId,
        "orderIdName": orderIdName,
        "exceptionType": exceptionType,
        "customerCode": customerCode,
        "skusTotal": skusTotal,
        "skusTotalFact": skusTotalFact,
        "mailNo": mailNo,
        "skuDetai": skuDetai.toJson(),
        "queryFlag": queryFlag,
        "depotName": depotName,
      };
}

class Params {
  Params();

  factory Params.fromJson(Map<String, dynamic> json) => Params();

  Map<String, dynamic> toJson() => {};
}

class SkuDetai {
  SkuDetai({
    this.skus,
  });

  List<SkuListItem> skus;

  factory SkuDetai.fromJson(Map<String, dynamic> json) => SkuDetai(
        skus: json["skus"] == null
            ? null
            : List<SkuListItem>.from(
                json["skus"].map((x) => SkuListItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "skus": skus == null
            ? null
            : List<dynamic>.from(skus.map((x) => x.toJson())),
      };
}

// class Skus {
//   Skus(
//       {this.imgUrl,
//       this.status,
//       this.size,
//       this.skuName,
//       this.selected = false,
//       this.skuId,
//       this.color,
//       this.barCode,
//       this.id});

//   String imgUrl;
//   String status;
//   String size;
//   String skuName;
//   bool selected;
//   int skuId;
//   int id;
//   String color;
//   String barCode;

//   factory Skus.fromJson(Map<String, dynamic> json) => Skus(
//         imgUrl: json["imgUrl"],
//         status: json["status"],
//         size: json["size"],
//         skuName: json["skuName"],
//         selected: json["selected"],
//         id: json["id"],
//         skuId: json["skuId"],
//         color: json["color"],
//         barCode: json["barCode"],
//       );

//   Map<String, dynamic> toJson() => {
//         "imgUrl": imgUrl,
//         "status": status,
//         "size": size,
//         "skuName": skuName,
//         "selected": selected,
//         "id": id,
//         "skuId": skuId,
//         "color": color,
//         "barCode": barCode,
//       };
// }
