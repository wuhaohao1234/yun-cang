// 商品sku模型
class ENShangPinSkuListModel {
  List<ENShangPinSkuModel> sysPrepareOrderSpuList;

  ENShangPinSkuListModel({
    this.sysPrepareOrderSpuList,
  });

  factory ENShangPinSkuListModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    List<ENShangPinSkuModel> temp;
    if (json['sysPrepareOrderSpuList'] != null) {
      temp = [];
      (json['sysPrepareOrderSpuList'] as List).forEach((element) {
        temp.add(ENShangPinSkuModel.fromJson(element));
      });
    }
    return ENShangPinSkuListModel(
      sysPrepareOrderSpuList: temp,
    );
  }

  Map<String, dynamic> toJson() => {
        'sysPrepareOrderSpuList':
            sysPrepareOrderSpuList.map((v) => v.toJson()).toList(),
      };
}

class ENShangPinSkuModel {
  int spuId; // 	商品id
  int skuId; // 	SKU id
  String spuFlaw; // 	状态(0：正常 1：瑕疵)
  String skuCode; // 	SKU 编码
  String snCode; // 	SKU码
  String defectiveImg; // 瑕疵图片
  String size;

  ENShangPinSkuModel({
    this.spuId,
    this.skuId,
    this.spuFlaw,
    this.skuCode,
    this.snCode,
    this.defectiveImg,
    this.size,
  });

  factory ENShangPinSkuModel.fromJson(Map<String, dynamic> json) {
    print(json.toString());

    return ENShangPinSkuModel(
      spuId: json['spuId'],
      skuId: json['skuId'],
      spuFlaw: json['spuFlaw'],
      skuCode: json['skuCode'],
      snCode: json['snCode'],
      defectiveImg: json['defectiveImg'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() => {
        'spuId': spuId,
        'skuId': skuId,
        'spuFlaw': spuFlaw,
        'skuCode': skuCode,
        'snCode': snCode,
        'defectiveImg': defectiveImg,
        'size': size,
      };
}
