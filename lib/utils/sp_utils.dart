import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wms/models/mine/user_info_model.dart';

class SPUtils {
  static Future<bool> saveUserInfo(UserInfoModel userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userInfo == null) {
      return prefs.remove('userInfo');
    }
    return prefs.setString('userInfo', convert.jsonEncode(userInfo));
  }

  static Future<UserInfoModel> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfoModel userInfo = UserInfoModel.fromJson(
      convert.jsonDecode(
        prefs.get('userInfo'),
      ),
    );
    return userInfo;
  }

  static Future<bool> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token == null) return prefs.remove('token');
    return await prefs.setString('token', token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      return null;
    }
    String token = prefs.getString('token');
    return token;
  }

  static Future<bool> saveUserType(int userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userType == null) {
      return prefs.remove('userType');
    }
    return await prefs.setInt('userType', userType);
  }

  static Future<int> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('userType') == null) {
      return null;
    }
    return prefs.getInt('userType');
  }

  static Future<bool> saveAgentName(String agentName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (agentName == null) {
      return prefs.remove('agentName');
    }
    return await prefs.setString('agentName', agentName);
  }

  static Future<String> getAgentName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('agentName') == null) {
      return null;
    }
    String agentName = prefs.getString('agentName');
    return agentName;
  }

  static Future<bool> saveDepotName(String depotName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (depotName == null) {
      return prefs.remove('depotName');
    }
    print("用户仓库信息($depotName)保存成功");
    return await prefs.setString('depotName', depotName);
  }

  static Future<String> getDepotName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('depotName') == null) {
      return null;
    }
    String depotName = prefs.getString('depotName');
    return depotName;
  }

  static Future<bool> saveDepotPower(bool depotPower) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (depotPower == null) {
      return prefs.remove('depotName');
    }
    print("用户仓库权限信息($depotPower)保存成功");
    return await prefs.setBool('depotPower', depotPower);
  }

  static Future<bool> getDepotPower() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('depotPower') == null) {
      return null;
    }
    bool depotPower = prefs.getBool('depotPower');
    return depotPower;
  }

  static Future<bool> saveOpenId(String openId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (openId == null) {
      return prefs.remove('openId');
    }
    print("用户仓库权限信息($openId)保存成功");
    return await prefs.setString('openId', openId);
  }

  static Future<String> getOpenId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('openId') == null) {
      return null;
    }
    String openId = prefs.getString('openId');
    return openId;
  }

  static Future<bool> saveWeChatAccount(String weChatAccount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (weChatAccount == null) {
      return prefs.remove('weChatAccount');
    }
    print("用户微信号($weChatAccount)保存成功");
    return await prefs.setString('weChatAccount', weChatAccount);
  }

  static Future<String> getWeChatAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('weChatAccount') == null) {
      return null;
    }
    String weChatAccount = prefs.getString('weChatAccount');
    return weChatAccount;
  }

  static Future<bool> saveShopCode(String shopCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (shopCode == null) {
      return prefs.remove('shopCode');
    }
    print("用户仓库权限信息($shopCode)保存成功");
    return await prefs.setString('shopCode', shopCode);
  }

  static Future<String> getShopCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('shopCode') == null) {
      return null;
    }
    String shopCode = prefs.getString('shopCode');
    return shopCode;
  }

  static Future<bool> setIsFirst(bool isFirst ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('isFirst', isFirst);
  }

  static Future<bool> getIsFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isFirst') == null) {
      return true;
    }
    bool isFirst = prefs.getBool('isFirst');
    return isFirst;
  }
}
