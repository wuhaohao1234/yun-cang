class ENYcdModel {
  String queryFlag;
  String exceptionType;
  String customerCode;
  String exceptionOrderCode;
  num exceptionOrderId;

  ENYcdModel({
    this.queryFlag,
    this.exceptionType,
    this.customerCode,
    this.exceptionOrderCode,
    this.exceptionOrderId,
  });

  factory ENYcdModel.fromJson(Map<String, dynamic> json) {
    return ENYcdModel(
      queryFlag: json['queryFlag'],
      exceptionType: json['exceptionType'],
      customerCode: json['customerCode'],
      exceptionOrderCode: json['exceptionOrderCode'],
      exceptionOrderId: json['exceptionOrderId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'queryFlag': queryFlag,
        'exceptionType': exceptionType,
        'customerCode': customerCode,
        'exceptionOrderCode': exceptionOrderCode,
      };
}
