class MineInfoModel {

  String recipients;
  String phone;
  String addressCN;
  String addressEN;

  MineInfoModel({
    this.recipients,
    this.phone,
    this.addressCN,
    this.addressEN
  });

  factory MineInfoModel.fromJson(Map<String,dynamic> json){

    return MineInfoModel(
      recipients: json['recipients'],
      phone: json['phone'],
      addressCN: json['addressCN'],
      addressEN: json['addressEN'],
    );
  }

  Map<String, dynamic> toJson() => {
    'recipients': recipients,
    'phone': phone,
    'addressEN': addressEN,
    'addressCN': addressCN,
  };

}