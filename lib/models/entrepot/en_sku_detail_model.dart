class ENSkuDetailModel {
  List<ENSkusModel> skus;

  ENSkuDetailModel({
    this.skus,
  });

  factory ENSkuDetailModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    List<ENSkusModel> temp;
    if (json['skus'] != null) {
      temp = [];
      (json['skus'] as List).forEach((element) {
        temp.add(ENSkusModel.fromJson(element));
      });
    }
    return ENSkuDetailModel(
      skus: temp,
    );
  }

  Map<String, dynamic> toJson() => {
        'skus': skus.map((v) => v.toJson()).toList(),
      };
}

class ENSkusModel {
  num id;
  num skuId;
  num agentId;
  num depotId;
  String skuCode; // 	SKU码
  String barCode; // 	条形码
  num skuQty;
  num count;
  String imgUrl; // 	商品图片
  String status; // 	状态(0：正常 1：瑕疵)
  String snCode; //分拣snCode；
  num sortingSkuNumber; //分拣number;
  String warehousingOrderCode;

  ENSkusModel(
      {this.id,
      this.skuId,
      this.agentId,
      this.depotId,
      this.skuCode,
      this.barCode,
      this.skuQty,
      this.count,
      this.imgUrl,
      this.status,
      this.snCode,
      this.sortingSkuNumber,
      this.warehousingOrderCode});

  factory ENSkusModel.fromJson(Map<String, dynamic> json) {
    print(json.toString());

    return ENSkusModel(
      id: json['id'],
      skuId: json['skuId'],
      agentId: json['agentId'],
      depotId: json['depotId'],
      skuCode: json['skuCode'],
      barCode: json['barCode'],
      skuQty: json['skuQty'],
      count: json['count'],
      imgUrl: json['imgUrl'],
      status: json['status'],
      snCode: json['snCode'],
      sortingSkuNumber: json['sortingSkuNumber'],
      warehousingOrderCode: json['warehousingOrderCode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'skuId': skuId,
        'agentId': agentId,
        'depotId': depotId,
        'skuCode': skuCode,
        'barCode': barCode,
        'skuQty': skuQty,
        'count': count,
        'imgUrl': imgUrl,
        'status': status,
        'snCode': snCode,
        'sortingSkuNumber': sortingSkuNumber,
        'warehousingOrderCode': warehousingOrderCode,
      };
}
