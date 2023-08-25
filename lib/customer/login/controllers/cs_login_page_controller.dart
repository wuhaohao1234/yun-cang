import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/customer/login/pages/cs_register_page.dart';
import 'package:wms/customer/login/pages/cs_retrieve_pwd_page.dart';
import 'package:wms/customer/main/cs_main_page.dart';
import 'package:wms/customer/others/webview_page.dart';
import 'package:wms/entrepot/pages/en_main_page.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/sp_utils.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/utils/wms_check_util.dart';

import '../../../views/dialog/statement_widget.dart';
import '../../common.dart';

class CSLoginPageController extends GetxController {
  final String phone;

  TextEditingController phoneController;
  TextEditingController pwdController;

  var areaCode = '86'.obs;
  var checkedPrivacy = false.obs;
  CSLoginPageController(this.phone);

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    pwdController = TextEditingController();
    if (phone != null) {
      phoneController.text = phone;
    }
  }

  // 登录按钮点击事件处理
  void onTopLoginBtnHandle() {
    if (!checkInput()) return;
    if (!checkPrivacy()) {
      Get.to(StatementWidget(),opaque: false,duration: Duration(milliseconds: 50));
      // ToastUtil.showMessage(message: '请先阅读并勾选用户协议');
      return;
    }
    requestLogin();
  }

  // 校验输入
  bool checkInput() {
    if (phoneController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入手机号');
      return false;
    }

    if (pwdController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入密码');
      return false;
    }

    // 校验手机号
    if (!WMSCheckUtil.isPhoneNumber(phoneController.text) &&
        areaCode.value == '86') {
      ToastUtil.showMessage(message: '手机号格式错误');
      return false;
    }
    // 校验密码
    // if(!WMSCheckUtil.isLoginPassword(pwdController.text)){
    //   ToastUtil.showMessage(message: '登录密码格式错误');
    //   return false ;
    // }

    return true;
  }

  bool checkPrivacy() {
    return checkedPrivacy.value;
  }

  setPrivacyValue(e) {
    this.checkedPrivacy.value = e;
  }

  // 发送登录请求
  void requestLogin() {
    EasyLoadingUtil.showLoading();
    HttpServices.requestLogin(
        phoneNum: phoneController.text,
        password: pwdController.text,
        loginType: 1,
        success: (data) {
          // EasyLoadingUtil.hidden();
          print('login and save');
          // print(data['depotName']);

          WMSUser.getInstance().token = data['token'];
          WMSUser.getInstance().userType = data['userType'];
          WMSUser.getInstance().agentName = data['agentName'];
          WMSUser.getInstance().depotName = data['depotName'];
          WMSUser.getInstance().depotId = data['depotId'].toString();
          WMSUser.getInstance().depotPower = data['depotPower'];
          WMSUser.getInstance().openId = data['openId'];
          WMSUser.getInstance().weChatAccount = data['weChatAccount'];
          WMSUser.getInstance().shopCode = data['shopCode'];
          SPUtils.saveToken(data['token']);
          SPUtils.saveUserType(data['userType']);
          SPUtils.saveAgentName(data['agentName']);
          SPUtils.saveDepotName(data['depotName']);
          SPUtils.saveDepotPower(data['depotPower']);
          SPUtils.saveOpenId(data['openId']);
          SPUtils.saveOpenId(data['weChatAccount']);
          SPUtils.saveShopCode(data['shopCode']);
          print('getInstance ${WMSUser.getInstance().depotName}');
          requestUserInfo();
          // _jumpToCSMainPage();
        },
        error: (e) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: e.message);
        });
  }

  // 获取用户信息请求
  void requestUserInfo() {
    HttpServices.requestGetUserInfo(
      success: (data) {
        EasyLoadingUtil.hidden();
        print(data.toString());
        WMSUser.getInstance().userInfoModel = data;
        SPUtils.saveUserInfo(data);
        _jumpToCSMainPage();
      },
      error: (e) {
        EasyLoadingUtil.hidden();
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: e.message);
      },
    );
  }

  // 跳转到客户端主页
  void _jumpToCSMainPage() {
    if (WMSUser.getInstance().userType == 1) {
      Get.offAll(CSMainPage());
    } else if (WMSUser.getInstance().userType == 2) {
      Get.offAll(ENMainPage());
    }
  }

  // 跳转到客户端找回密码页面
  void onTapReterievePwdBtnHandel() {
    Get.to(() => CSRetrievePwdPage());
  }

  // 跳转注册页面
  void onTapRegisterBtnHandle() {
    Get.to(() => CSRegisterPage());
  }

  // 打开用户协议页面
  void onTapUserAgreementBtnHandle() {
    Get.to(
      () => WebviewPage(
        url: AppGlobalConfig.userAAgreement,
        title: '用户协议',
      ),
    );
  }

  // 打开隐私政策页面
  void onTopPrivacyPolicyBtnHandle() {
    Get.to(
      () => WebviewPage(
        url: AppGlobalConfig.privacyAgreement,
        title: '隐私政策',
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
    print("cs_login_page_controller on Close ------");
    phoneController?.dispose();
    pwdController?.dispose();
    EasyLoadingUtil.popHidden();
  }
}
