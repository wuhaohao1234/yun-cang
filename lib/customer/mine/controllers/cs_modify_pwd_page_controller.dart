import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/login/pages/cs_reset_pwd_page.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

import '../../../configs/wms_user.dart';

class CSModifyPwdPageController extends GetxController {
  TextEditingController codeC;

  var btnText = '获取验证码'.obs;

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
    codeC = TextEditingController();
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

  // 点击发送验证码按钮
  void onTapSendCodeHandle() {
    requestGetVerificationCode();
  }

  // 发送请求
  void requestCommitHandle({String mobile, String code}) {
    if (codeC.text.length == 0) {
      ToastUtil.showMessage(message: '请输入验证码');
      return;
    }

    String mobile = WMSUser.getInstance().userInfoModel.phoneNum;
    EasyLoadingUtil.showLoading();
    HttpServices.requestCheckVerificationCode(
      code: codeC.text,
      mobile: mobile,
      success: () {
        EasyLoadingUtil.hidden();
        Get.to(() => CSResetPwdPage(
              mobile: mobile,
              code: codeC.text,
            )).then((value) {
          if (value == true) {
            Get.back();
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
    EasyLoadingUtil.showLoading();
    HttpServices.requestSendVerificationCode(
      type: '3',
      mobile: WMSUser.getInstance().userInfoModel.phoneNum,
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

  @override
  void onClose() {
    super.onClose();
    codeC.dispose();
    _timer?.cancel();
  }
}
