class CardModel {
  int id;
  String enterpriseName;
  int countryId;
  String currency;
  String receiverAddress;
  String accountName;
  String cardNumber;
  String identificationCode;
  String bankName;
  String userCode;
  String accountType; //0境内，1境外
  String adoptType; //0已开通 1未开通

  CardModel(
      {this.id,
      this.enterpriseName,
      this.countryId,
      this.currency,
      this.receiverAddress,
      this.accountName,
      this.cardNumber,
      this.identificationCode,
      this.bankName,
      this.userCode,
      this.accountType,
      this.adoptType});

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      enterpriseName: json['enterpriseName'],
      countryId: json['countryId'],
      currency: json['currency'],
      receiverAddress: json['receiverAddress'],
      accountName: json['accountName'],
      cardNumber: json['cardNumber'],
      identificationCode: json['identificationCode'],
      bankName: json['bankName'],
      userCode: json['userCode'],
      accountType: json['accountType'],
      adoptType: json['adoptType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'enterpriseName': enterpriseName,
        'countryId': countryId,
        'currency': currency,
        'receiverAddress': receiverAddress,
        'accountName': accountName,
        'cardNumber': cardNumber,
        'identificationCode': identificationCode,
        'bankName': bankName,
        'userCode': userCode,
        'accountType': accountType,
        'adoptType': adoptType,
      };
}
