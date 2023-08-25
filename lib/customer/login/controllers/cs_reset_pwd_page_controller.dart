import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/customer/main/cs_main_page.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class CSResetPwdPageController extends GetxController {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController agentCodeController = TextEditingController();

  var show1 = false.obs;
  var show2 = false.obs;

  void changeShow1() {
    show1.value = show1.value ? false : true;
  }

  void changeShow2() {
    show2.value = show2.value ? false : true;
  }

  // 发送请求
  void requestCommitHandle({String mobile, String code}) {
    if (controller1.text.length == 0) {
      ToastUtil.showMessage(message: '请输入密码');
      return;
    }

    if (controller2.text.length == 0) {
      ToastUtil.showMessage(message: '请输入确认密码');
      return;
    }

    if (controller1.text != controller2.text) {
      ToastUtil.showMessage(message: '两次密码不一致');
      return;
    }

    EasyLoadingUtil.showLoading();
    HttpServices.resetPwd(
        params: {
          'password': controller1.text,
          'phoneNum': mobile,
          'code': code
        },
        success: () {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: '修改成功');
          Get.offAll(() => CSMainPage());
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }
}
