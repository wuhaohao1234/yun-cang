import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_account_input_widget.dart';
import 'package:wms/common/baseWidgets/wms_verification_code_input_widget.dart';
import 'package:wms/entrepot/pages/common.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/utils/wms_check_util.dart';

import 'cs_choose_region_page.dart';
import 'cs_reset_pwd_page.dart';

class CSRetrievePwdPage extends StatefulWidget {
  final String title;

  const CSRetrievePwdPage({Key key, this.title = '找回登录密码'}) : super(key: key);

  @override
  _CSRetrievePwdPageState createState() => _CSRetrievePwdPageState();
}

class _CSRetrievePwdPageState extends State<CSRetrievePwdPage> {
  TextEditingController _accountController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                top: 20.h, left: 16.w, right: 16.w, bottom: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTopTitleWidget(),
                buildInputContainerWidget(),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // top title
  Widget buildTopTitleWidget() {
    return Container(
      width: 300.w,
      alignment: Alignment(-1, 0),
      child: Text(
        widget.title ?? '',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
      ),
    );
  }

  // 文本输入框容器
  Widget buildInputContainerWidget() {
    return Container(
      margin: EdgeInsets.only(top: 60.h),
      child: Column(
        children: [
          WMSAccountInputWidget(
            controller: _accountController,
            callback: () {
              Get.to(() => CSChooseRegionPage());
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          WMSVerificationCodeInputWidget(
            controller: _codeController,
            callback: () {
              // 获取验证码
              // print("get verification code");
              getVerificationCode();
            },
          ),
        ],
      ),
    );
  }

  Widget buildSubmitButton() {
    return Container(
      margin: EdgeInsets.only(top: 80.h),
      height: 34.h,
      width: 300.w,
      child: GestureDetector(
        onTap: onTapCommitHandle,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Center(
            child: Text(
              '下一步',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void onTapCommitHandle() {
    if (_accountController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入手机号');
      return;
    }
    if (!WMSCheckUtil.isPhoneNumber(_accountController.text)) {
      ToastUtil.showMessage(message: '请输入正确的手机号');
      return;
    }
    if (_codeController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入验证码');
      return;
    }

    requestCheckVerificationCode();
  }

  void getVerificationCode() async {
    EasyLoadingUtil.showLoading();
    final res = await HttpServices().requestSendVerificationCodeAsync(
        type: "3", mobile: _accountController.text);
    EasyLoadingUtil.hidden();
    if (res is ErrorEntity) {
      EasyLoadingUtil.showMessage(message: res.message);
    } else {
      EasyLoadingUtil.showMessage(message: "获取成功");
    }
  }

  // 发送校验验证码请求
  void requestCheckVerificationCode() {
    EasyLoadingUtil.showLoading();
    HttpServices.requestCheckVerificationCode(
      code: _codeController.text,
      mobile: _accountController.text,
      success: () {
        EasyLoadingUtil.hidden();
        Get.to(() => CSResetPwdPage(
              mobile: _accountController.text,
              code: _codeController.text,
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

  @override
  void dispose() {
    super.dispose();
    _accountController.dispose();
    _codeController.dispose();
  }
}
