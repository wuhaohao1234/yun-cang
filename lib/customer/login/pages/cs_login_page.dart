import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:flutter/cupertino.dart';

import 'package:wms/common/baseWidgets/wms_account_input_widget.dart';
import 'package:wms/common/baseWidgets/wms_password_input_widget.dart';
import 'package:wms/customer/login/controllers/cs_login_page_controller.dart';

import 'cs_choose_region_page.dart';

class CSLoginPage extends StatelessWidget {
  final String phone;

  const CSLoginPage({Key key, this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CSLoginPageController controller = Get.put(CSLoginPageController(phone));
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: 64.h, left: 16.w, right: 16.w, bottom: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTopTitleWidget(),
                  buildInputContainerWidget(controller),
                  buildSubmitButton(controller),
                  buildBottomBtnsWidget(controller),
                ],
              ),
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
        '账号登录',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
      ),
    );
  }

  // 文本输入框容器
  Widget buildInputContainerWidget(CSLoginPageController controller) {
    print("controller.phoneController------>${controller.phoneController}");
    print("controller.pwdController++++++++>${controller.pwdController}");
    return Container(
      margin: EdgeInsets.only(top: 60.h),
      child: Column(
        children: [
          Obx(
            () => WMSAccountInputWidget(
              areaCode: controller.areaCode.value,
              controller: controller.phoneController,
              callback: () {
                Get.to(() => CSChooseRegionPage(
                      areaCode: controller.areaCode.value,
                    )).then((value) {
                  if (value != null) {
                    controller.areaCode.value = value;
                  }
                });
              },
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          WMSPasswordInputWidget(
            controller: controller.pwdController,
          ),
        ],
      ),
    );
  }

// 登录按钮+协议
  Widget buildSubmitButton(CSLoginPageController pageController) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          Container(
            // color: Colors.red,
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Checkbox(
                      value: pageController.checkedPrivacy.value,
                      activeColor: Colors.black87,
                      onChanged: (bool e) {
                        pageController.setPrivacyValue(e);
                        // update();
                      })),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "登录表示您已阅读并同意 ",
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                    TextSpan(
                      text: "用户协议、",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = pageController.onTapUserAgreementBtnHandle,
                    ),
                    TextSpan(
                      text: "隐私政策",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = pageController.onTopPrivacyPolicyBtnHandle,
                    ),
                  ]))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 70.h,
          ),
          GestureDetector(
            onTap: () => pageController.onTopLoginBtnHandle(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 120.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppConfig.themeColor,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                '登录',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

// 找回密码 + 新用户注册
  Widget buildBottomBtnsWidget(CSLoginPageController controller) {
    return Container(
      margin: EdgeInsets.only(top: 180.h),
      width: 200.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => controller.onTapReterievePwdBtnHandel(),
            child: Text(
              '找回密码',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey,
            height: 11.h,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Get.to(()=>CSRegisterPage());
              controller.onTapRegisterBtnHandle();
            },
            child: Text(
              '新用户注册',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
