class KuCunCommodityModel {
  int spuId;
  int depotId;
  String stockCode;
  String commodityName; // 	商品名称
  String color; //	颜色
  String picturePath; //	图片
  String brandName;

  List wmsSkuList;
  int onSaleCount; //在售库存
  int inStoreCount; //可售库存
  int factCount; //总库存
  int lockCount; //锁定库存
  int status; //状态0 正常1瑕疵；
  List skuList; //自行增加，瑕疵尺寸列表；
  int appInStoreCount;
  int bazaarInStoreCount;
  int appOnSaleCount;
  int bazaarOnSaleCount;

  KuCunCommodityModel({
    this.spuId,
    this.depotId,
    this.stockCode,
    this.commodityName,
    this.brandName,
    this.color,
    this.picturePath,
    this.wmsSkuList,
    // this.onSaleCount,
    // this.inStoreCount,
    this.factCount,
    this.lockCount,
    this.status,
    this.skuList,
    this.appInStoreCount,
    this.bazaarInStoreCount,
    this.appOnSaleCount,
    this.bazaarOnSaleCount,
  });

  factory KuCunCommodityModel.fromJson(Map<String, dynamic> json) {
    // List<SizeModel> temp = [];
    // if (json['childrenList'] != null) {
    //   (json['childrenList'] as List).forEach((element) {
    //     temp.add(SizeModel.fromJson(element));
    //   });
    // }
    return KuCunCommodityModel(
      // childrenList: temp,
      spuId: json['spu']['spuId'],
      depotId: json['depotId'],
      stockCode: json['spu']['stockCode'],
      commodityName: json['spu']['commodityName'],
      brandName: json['brandName'],
      color: json['spu']['color'],
      picturePath: json['spu']['picturePath'],
      wmsSkuList: json['spu']['wmsSkuList'],
      // onSaleCount: json['onSaleCount'],
      // inStoreCount: json['inStoreCount'],
      factCount: json['factCount'],
      lockCount: json['lockCount'],
      status: json['status'],
      skuList: json['skuList'],
      appInStoreCount: json['appInStoreCount'],
      bazaarInStoreCount: json['bazaarInStoreCount'],
      appOnSaleCount: json['appOnSaleCount'],
      bazaarOnSaleCount: json['bazaarOnSaleCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'spuId': spuId,
        'depotId': depotId,
        'stockCode': stockCode,
        'commodityName': commodityName,
        'brandName': brandName,
        'color': color,
        'picturePath': picturePath,
        'wmsSkuList': wmsSkuList,
        // 'onSaleCount': onSaleCount,
        // 'inStoreCount': inStoreCount,
        'factCount': factCount,
        'lockCount': lockCount,
        'status': status,
        'skuList': skuList,
        'appInStoreCount': appInStoreCount,
        'bazaarInStoreCount': bazaarInStoreCount,
        'appOnSaleCount': appOnSaleCount,
        'bazaarOnSaleCount': bazaarOnSaleCount,
      };
}
