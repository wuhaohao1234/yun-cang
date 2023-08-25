import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/main/cs_main_page.dart';
import 'package:wms/entrepot/pages/en_main_page.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/sp_utils.dart';
import 'package:wms/utils/toast_util.dart';

class CSSetPwdPageController extends GetxController {
  final String phoneNum;

  TextEditingController pwdController1;
  TextEditingController pwdController2;
  TextEditingController agentCodeController;

  CSSetPwdPageController(this.phoneNum);

  var show1 = false.obs;
  var show2 = false.obs;

  @override
  void onInit() {
    super.onInit();
    pwdController1 = TextEditingController();
    pwdController2 = TextEditingController();
    agentCodeController = TextEditingController();
  }

  // 点击提交按钮事件处理
  void onTapSubmitBtnHandle() {
    print('111');
    if (!checkInput()) return;

    requestRegister();
  }

  // 发送注册请求
  void requestRegister() {
    EasyLoadingUtil.showLoading();
    HttpServices.requestRegister(
        phoneNum: phoneNum,
        userType: 1,
        password: pwdController1.text,
        agentCode: agentCodeController.text,
        success: () {
          // EasyLoadingUtil.hidden();
          // ToastUtil.showMessage(message: '注册成功');

          requestLogin(
            phoneNum: phoneNum,
            pwd: pwdController1.text,
          );
        },
        error: (e) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: e.message);
        });
  }

  // 发送登录请求
  void requestLogin({String phoneNum, String pwd}) {
    HttpServices.requestLogin(
        phoneNum: phoneNum,
        password: pwd,
        loginType: 1,
        success: (data) {
          // EasyLoadingUtil.hidden();
          WMSUser.getInstance().token = data['token'];
          WMSUser.getInstance().userType = data['userType'];
          WMSUser.getInstance().agentName = data['agentName'];
          WMSUser.getInstance().depotName = data['depotName'];
          WMSUser.getInstance().depotId = data['depotId'].toString();
          WMSUser.getInstance().depotPower = data['depotPower'];
          WMSUser.getInstance().openId = data['openId'];
          SPUtils.saveToken(data['token']);
          SPUtils.saveUserType(data['userType']);
          SPUtils.saveAgentName(data['agentName']);
          SPUtils.saveDepotName(data['depotName']);
          SPUtils.saveDepotPower(data['depotPower']);
          SPUtils.saveOpenId(data['openId']);
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

  // 校验输入
  bool checkInput() {
    if (pwdController1.text.length == 0) {
      ToastUtil.showMessage(message: '请输入密码');
      return false;
    }

    if (pwdController1.text.length == 0) {
      ToastUtil.showMessage(message: '请输入确认密码');
      return false;
    }
    if (agentCodeController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入运营商编号');
      return false;
    }
    // if (!WMSCheckUtil.isLoginPassword(pwdController1.text)) {
    //   ToastUtil.showMessage(message: '登录密码格式错误');
    //   return false;
    // }

    if (pwdController1.text != pwdController2.text) {
      ToastUtil.showMessage(message: '两次密码不一致');
      return false;
    }

    return true;
  }

  void changeShow1() {
    show1.value = !show1.value;
  }

  void changeShow2() {
    show2.value = !show2.value;
  }
}
