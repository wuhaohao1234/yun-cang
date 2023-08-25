// 客户端自主仓模型
class ZiZhuCangModel {
  String createTime;

  ZiZhuCangModel({
    this.createTime,
  });

  factory ZiZhuCangModel.fromJson(Map<String, dynamic> json) {
    return ZiZhuCangModel(
      createTime: json['createTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'createTime': createTime,
      };
}
