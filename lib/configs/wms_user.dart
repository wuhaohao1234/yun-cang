import 'package:wms/models/mine/user_info_model.dart';
import 'package:wms/utils/sp_utils.dart';

class WMSUser {
  static WMSUser _instance;

  UserInfoModel userInfoModel;

  String token;

  int userType; // 用户类型1商家用户2仓管用户

  String agentName; //运营商名称

  String depotName; //仓库名称

  String depotId; //仓库id

  bool depotPower;

  String openId;

  String weChatAccount;

  WMSUser._internal();

  String shopCode;
  factory WMSUser.getInstance() => _getInstance();

  static _getInstance() {
    if (_instance == null) {
      _instance = WMSUser._internal();
      _instance.userInfoModel = UserInfoModel();
      _instance.depotName = null;
    }
    return _instance;
  }

  void logOut() {
    userInfoModel = UserInfoModel();
    token = null;
    userType = null;
    agentName = null;
    depotName = null;
    SPUtils.saveUserInfo(null);
    SPUtils.saveToken(null);
    SPUtils.saveUserType(null);
    SPUtils.saveAgentName(null);
    SPUtils.saveDepotName(null);
    SPUtils.saveDepotPower(null);
    SPUtils.saveOpenId(null);
    SPUtils.saveWeChatAccount(null);
    SPUtils.saveShopCode(null);
  }
}
