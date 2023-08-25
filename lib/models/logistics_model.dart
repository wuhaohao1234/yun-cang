class LogisticsModel {
  // ignore: non_constant_identifier_names
  String Site; //  快递公司官网
  // ignore: non_constant_identifier_names
  String CourierPhone; // 	快递员电话
  // ignore: non_constant_identifier_names
  String ShipperCode; // 快递公司编码
  // ignore: non_constant_identifier_names
  List<TracesModel> Traces; //事件集合
  String takeTime; // 发货到收货消耗时长 (截止最新轨迹)
  String updateTime; // 快递轨迹信息最新时间
  // ignore: non_constant_identifier_names
  bool Success; // 成功与否
  // ignore: non_constant_identifier_names
  String Reason; // 提示信息
  // ignore: non_constant_identifier_names
  String Name; // 快递公司名称
  // ignore: non_constant_identifier_names
  String Logo; // 快递Logo
  // ignore: non_constant_identifier_names
  String LogisticCode; // 	快递单号
  String
      // ignore: non_constant_identifier_names
      State; // -1 单号或快递公司代码错误 单号或快递公司代码错误 0 暂无轨迹 暂无轨迹 1 快递收件 快递收件 2 在途中 在途中 3 签收 签收 4 问题件 问题件 5 疑难件 疑难件（收件人拒绝签收，地址有误或不能送达派送区域，收费等原因无法正常派送） 6 退件签收 退件签收
  // ignore: non_constant_identifier_names
  String Phone; // 快递公司电话
  // ignore: non_constant_identifier_names
  String Courier; // 	快递员 或 快递站(没有则为空)

  LogisticsModel({
    // ignore: non_constant_identifier_names
    this.Site,
    // ignore: non_constant_identifier_names
    this.CourierPhone,
    // ignore: non_constant_identifier_names
    this.ShipperCode,
    // ignore: non_constant_identifier_names
    this.Traces,
    this.takeTime,
    this.updateTime,
    // ignore: non_constant_identifier_names
    this.Success,
    // ignore: non_constant_identifier_names
    this.Reason,
    // ignore: non_constant_identifier_names
    this.Name,
    // ignore: non_constant_identifier_names
    this.Logo,
    // ignore: non_constant_identifier_names
    this.LogisticCode,
    // ignore: non_constant_identifier_names
    this.State,
    // ignore: non_constant_identifier_names
    this.Phone,
    // ignore: non_constant_identifier_names
    this.Courier,
  });

  factory LogisticsModel.fromJson(Map<String, dynamic> json) {
    List<TracesModel> temps;
    if (json['Traces'] != null) {
      temps = [];
      (json['Traces'] as List).forEach((element) {
        temps.add(TracesModel.fromJson(element));
      });
    }
    return LogisticsModel(
      Site: json['Site'],
      CourierPhone: json['CourierPhone'],
      ShipperCode: json['ShipperCode'],
      Traces: temps,
      takeTime: json['takeTime'],
      updateTime: json['updateTime'],
      Success: json['Success'],
      Reason: json['Reason'],
      Name: json['Name'],
      Logo: json['Logo'],
      LogisticCode: json['LogisticCode'],
      State: json['State'],
      Phone: json['Phone'],
      Courier: json['Courier'],
    );
  }

  Map<String, dynamic> toJson() => {
        'Site': Site,
        'CourierPhone': CourierPhone,
        'ShipperCode': ShipperCode,
        'Traces': Traces,
        'takeTime': takeTime,
        'updateTime': updateTime,
        'Success': Success,
        'Reason': Reason,
        'Name': Name,
        'Logo': Logo,
        'LogisticCode': LogisticCode,
        'State': State,
        'Phone': Phone,
        'Courier': Courier,
      };
}

class TracesModel {
  // ignore: non_constant_identifier_names
  String AcceptStation; // 快递中转站，终点站
  // ignore: non_constant_identifier_names
  String AcceptTime; // 事件时间
  // ignore: non_constant_identifier_names
  TracesModel({this.AcceptStation, this.AcceptTime});

  factory TracesModel.fromJson(Map<String, dynamic> json) {
    return TracesModel(
      AcceptStation: json['AcceptStation'],
      AcceptTime: json['AcceptTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'AcceptStation': AcceptStation,
        'AcceptTime': AcceptTime,
      };
}
