//入库模型
class ENOrderCountModel {
  String daishangjia; //待上架
  String dailihuo; //待理货
  String daishouhuo; //待收货
  String lincun; //临存

  ENOrderCountModel(
      {this.daishangjia, this.dailihuo, this.daishouhuo, this.lincun});

  factory ENOrderCountModel.fromJson(Map<String, dynamic> json) {
    return ENOrderCountModel(
      daishangjia: json['待上架'],
      dailihuo: json['待理货'],
      daishouhuo: json['待收货'],
      lincun: json['临存'],
    );
  }

  Map<String, dynamic> toJson() => {
        'daishangjia': daishangjia,
        'dailihuo': dailihuo,
        'daishouhuo': daishouhuo,
        'lincun': lincun,
      };
}
