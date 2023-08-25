class WMSCheckUtil {
  /// 手机号校验
  static bool isPhoneNumber(String string) {
    // RegExp mobile = RegExp(r"(0|86|17951)?(1[0-9][0-9])[0-9]{8}");
    RegExp mobile = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

    return mobile.hasMatch(string);
  }

  ///登录密码：8~20位数字和字符组合
  static bool isLoginPassword(String string) {
    RegExp payPasswordRe =
        new RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,20}\$');
    return payPasswordRe.hasMatch(string);
  }

  ///身份证号：
  static bool isIdentifyCode(String string) {
    RegExp identifyCodeRe = new RegExp(
        r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
    return identifyCodeRe.hasMatch(string);
  }
}
