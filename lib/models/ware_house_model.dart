class WareHouseModel {
  int nowNum; //	今日入仓
  int num; // 	库存总数
  int outNum; // 今日出仓总数

  WareHouseModel({
    this.nowNum,
    this.num,
    this.outNum,
  });

  factory WareHouseModel.fromJson(Map<String, dynamic> json) {
    return WareHouseModel(
      nowNum: json['nowNum'],
      num: json['num'],
      outNum: json['outNum'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nowNum': nowNum,
        'num': num,
        'outNum': outNum,
      };
}
