class UserInfoModel {
  int userId; // 用户ID
  String userCode; // 用户客户代码
  String nickName; // 用户昵称
  int userType; // 用户类型
  String email; // 手机号码
  String phoneNum; // 手机号码
  String payPassword;
  String sex; // 用户性别（0男 1女 2未知）
  String avatar; // 头像地址
  String delFlag; // 删除标志（0代表存在 2代表删除）
  String loginModel; // 最后登陆手机型号
  String loginDate; // 最后登录时间
  String cardName; // 身份证姓名
  String cardNum; // 身份证号码
  String cardJust; // 身份证正面照片
  String cardBack; // 身份证反面照片
  String cardTake; // 手持身份证照片
  String cardTerm; // 身份证有效期
  String createTime; // 注册时间

  UserInfoModel({
    this.userId,
    this.userCode,
    this.nickName,
    this.payPassword,
    this.userType,
    this.email,
    this.phoneNum,
    this.sex,
    this.avatar,
    this.delFlag,
    this.loginModel,
    this.loginDate,
    this.cardName,
    this.cardNum,
    this.cardJust,
    this.cardBack,
    this.cardTake,
    this.cardTerm,
    this.createTime,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      userId: json['userId'],
      userCode: json['userCode'],
      nickName: json['nickName'],
      payPassword: json['payPassword'],
      userType: json['userType'],
      email: json['email'],
      phoneNum: json['phoneNum'],
      sex: json['sex'],
      avatar: json['avatar'],
      delFlag: json['delFlag'],
      loginModel: json['loginModel'],
      loginDate: json['loginDate'],
      cardName: json['cardName'],
      cardNum: json['cardNum'],
      cardJust: json['cardJust'],
      cardBack: json['cardBack'],
      cardTake: json['cardTake'],
      cardTerm: json['cardTerm'],
      createTime: json['createTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userCode': userCode,
        'payPassword': payPassword,
        'nickName': nickName,
        'userType': userType,
        'email': email,
        'phoneNum': phoneNum,
        'sex': sex,
        'avatar': avatar,
        'delFlag': delFlag,
        'loginModel': loginModel,
        'loginDate': loginDate,
        'cardName': cardName,
        'cardNum': cardNum,
        'cardJust': cardJust,
        'cardBack': cardBack,
        'cardTake': cardTake,
        'cardTerm': cardTerm,
        'createTime': createTime,
      };
}
