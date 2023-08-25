enum OrderState {
  TO_PAY, //  待支付
  TO_DELIVERY, // 待发货
  TO_RECEIVED, // 已发货
  RECEIVED, // 已收货
  DEAL_FAILURE, // 交易失败
}

enum VerificationCodeType {
  NONE,
  REGISTER,
  LOGIN,
  RESET_PWD,
}

class AppGlobalConfig {
  static const imageType1 = 'brandlogo/'; // 品牌LOGO (一张)
  static const imageType2 = 'spupicture/'; // 商资库商品图片 (最少一张 最多六张)
  static const imageType3 = 'prepareImg/'; // 预入库订单图  (最少一张 最多六张)
  static const imageType4 = 'userIdImg/'; // 用户身份证图片
  static const imageType5 = 'userIcon/'; // 用户头像图片

  static const privacyAgreement =
      'http://120.27.15.182/profile/h5/privacyTreaty.html'; // 隐私政策
  static const userAAgreement =
      'http://120.27.15.182/profile/h5/agreement.html'; // 用户协议
  static const notice = 'http://120.27.15.182/profile/h5/notice.html'; // 用户协议

}
