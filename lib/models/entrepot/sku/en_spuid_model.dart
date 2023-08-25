// 商品spu模型
class ENSpuSkuListModel {
  List<ENSpuIdModel> sysPrepareOrderSpuList;

  ENSpuSkuListModel({
    this.sysPrepareOrderSpuList,
  });

  factory ENSpuSkuListModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    List<ENSpuIdModel> temp;
    if (json['sysPrepareOrderSpuList'] != null) {
      temp = [];
      (json['sysPrepareOrderSpuList'] as List).forEach((element) {
        temp.add(ENSpuIdModel.fromJson(element));
      });
    }
    return ENSpuSkuListModel(
      sysPrepareOrderSpuList: temp,
    );
  }

  Map<String, dynamic> toJson() => {
        'sysPrepareOrderSpuList':
            sysPrepareOrderSpuList.map((v) => v.toJson()).toList(),
      };
}

class ENSpuIdModel {
  String spuId; // 	商品id
  String skuId; // 	SKU id
  String skuCode; // 	SKU 编码
  String size; // 	SKU码

  ENSpuIdModel({
    this.spuId,
    this.skuId,
    this.skuCode,
    this.size,
  });

  factory ENSpuIdModel.fromJson(Map<String, dynamic> json) {
    print(json.toString());

    return ENSpuIdModel(
      spuId: json['spuId'],
      skuId: json['skuId'],
      skuCode: json['skuCode'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() => {
        'spuId': spuId,
        'skuId': skuId,
        'skuCode': skuCode,
        'size': size,
      };
}
