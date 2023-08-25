class InventoryCategorysModel {
  int categoryId;
  String categoryName;
  int qty;
  int spuId;

  InventoryCategorysModel({this.categoryId, this.spuId, this.categoryName, this.qty});

  factory InventoryCategorysModel.fromJson(Map<String, dynamic> json) {
    return InventoryCategorysModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      qty: json['qty'],
      spuId: json['spuId'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'categoryId': categoryId,
        'categoryName': categoryName,
        'qty': qty,
        'spuId': spuId,
      };
}
