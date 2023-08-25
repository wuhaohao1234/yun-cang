import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/customer/login/pages/cs_set_pwd_page.dart';
import 'package:wms/customer/others/webview_page.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/utils/wms_check_util.dart';
import 'package:wms/customer/login/pages/cs_login_page.dart';

class CSRegisterPageController extends GetxController {
  TextEditingController phoneController;
  TextEditingController codeController;

  var btnText = '获取验证码'.obs;
  var areaCode = '86'.obs;
  var checkedPrivacy = false.obs;
  //倒计时的计时器。
  Timer _timer;

  // 当前倒计时的秒数。
  int _seconds = 60;
  int countdown = 60;

  //是否可以获取验证码
  bool _isAvailableGetVCode = true;

  @override
  void onInit() {
    super.onInit();

    phoneController = TextEditingController();
    codeController = TextEditingController();
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(_seconds.toString());
      _seconds--;
      _isAvailableGetVCode = false;
      btnText.value = '${_seconds}s';
      if (_seconds == 0) {
        btnText.value = '获取验证码';
        _isAvailableGetVCode = true;
        _seconds = countdown;
        _cancelTimer();
      }
    });
  }

  // 登录按钮点击事件处理
  void onTopNextBtnHandle() {
    if (!checkInput()) return;
    if (!checkPrivacy()) {
      ToastUtil.showMessage(message: '请先阅读并勾选用户协议');
      return;
    }
    requestCheckVerificationCode();
  }

  // 校验输入
  bool checkInput() {
    if (phoneController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入手机号');
      return false;
    }
    if (codeController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入验证码');
      return false;
    }

    // 校验手机号
    if (!WMSCheckUtil.isPhoneNumber(phoneController.text) &&
        areaCode.value == '86') {
      ToastUtil.showMessage(message: '手机号格式错误');
      return false;
    }

    return true;
  }

  bool checkPrivacy() {
    return checkedPrivacy.value;
  }

  setPrivacyValue(e) {
    this.checkedPrivacy.value = e;
  }

  // 发送校验验证码请求
  void requestCheckVerificationCode() {
    EasyLoadingUtil.showLoading();
    HttpServices.requestCheckVerificationCode(
      code: codeController.text,
      mobile: phoneController.text,
      success: () {
        EasyLoadingUtil.hidden();
        Get.to(() => CSSetPwdPage(
              phoneNum: phoneController.text,
            )).then((value) {
          if (value == true) {
            // Get.back();
            String phone = phoneController.text;
            Get.offAll(CSLoginPage(
              phone: phone,
            ));
          }
        });
      },
      error: (e) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: e.message);
      },
    );
  }

  // 发送获取验证码请求
  void requestGetVerificationCode() {
    if (phoneController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入手机号');

      return;
    }

    // 校验手机号
    if (!WMSCheckUtil.isPhoneNumber(phoneController.text)) {
      ToastUtil.showMessage(message: '手机号格式错误');
      return;
    }

    EasyLoadingUtil.showLoading();
    HttpServices.requestSendVerificationCode(
      type: '1',
      mobile: phoneController.text,
      success: () {
        EasyLoadingUtil.hidden();
        _startTimer();
      },
      error: (e) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: e.message);
      },
    );
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
    phoneController?.dispose();
    codeController?.dispose();
    _timer?.cancel();
    EasyLoadingUtil.popHidden();
  }
}
