// import 'package:debug_overlay/debug_overlay.dart';
import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class AppConfig {
  static const useDebugOverlay =
      false; // if you want to use debug overlay, change this to true
  static const versionNumber = 242;
  static const versionName = 'v2.4.2';
  static const pageSize = 10; //测试用,后面改成10,
  //正式
  static const wechatAppId = "wx77c67f6083a38369";
  static const wechatOriginalId = "gh_9acbcaefe886";
  static const wechatAppSecret = "c465f7779adbe8e9360cebc2fee6b4d2";

  static const universalLink = "https://unipay.topyuncang.com/app/";
  static const alipayAppId = "2021003127692704"; //支付宝分配给开发者的应用 ID
  static const alipayPid = "2088241373545710"; //签约的支付宝账号对应的支付宝唯一用户号
  static const alipayUrl =
      "https://cloud1-0gl9hb6e80f0dd06-1311751833.tcloudbaseapp.com/alipayJump.html"; //支付宝跳转的静态页面

  static const testUsers = ["15103861501", "15544467210"]; //测试用的手机号,
  static const themeColor = Color(0xff36D2BA);
}
