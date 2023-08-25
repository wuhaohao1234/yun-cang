class WalletAccountModel {
  num shopMoney; //店铺余额
  num warehouseMoney; //仓储余额
  num bond; //	保证金余额
  num serviceMoney;
  num territoryMoney;
  num frozenMoney;
  num abroadMoney;
  String userCode; //客户号
  num id;

  WalletAccountModel({
    this.shopMoney,
    this.warehouseMoney,
    this.bond,
    this.serviceMoney,
    this.territoryMoney,
    this.frozenMoney,
    this.abroadMoney,
    this.userCode,
    this.id,
  });

  factory WalletAccountModel.fromJson(Map<String, dynamic> json) {
    return WalletAccountModel(
      shopMoney: json['shopMoney'],
      warehouseMoney: json['warehouseMoney'],
      bond: json['bond'],
      serviceMoney: json['serviceMoney'],
      territoryMoney: json['territoryMoney'],
      frozenMoney: json['frozenMoney'],
      abroadMoney: json['abroadMoney'],
      userCode: json['userCode'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'shopMoney': shopMoney,
        'warehouseMoney': warehouseMoney,
        'bond': bond,
        'serviceMoney': serviceMoney,
        'territoryMoney': territoryMoney,
        'frozenMoney': frozenMoney,
        'abroadMoney': abroadMoney,
        'userCode': userCode,
        'id': id,
      };
}
