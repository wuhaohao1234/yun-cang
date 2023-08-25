import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_account_input_widget.dart';
import 'package:wms/common/baseWidgets/wms_verification_code_input_widget.dart';
import 'package:wms/customer/login/controllers/cs_register_page_controller.dart';

import 'cs_choose_region_page.dart';

class CSRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CSRegisterPageController pageController =
        Get.put(CSRegisterPageController());
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
                buildInputContainerWidget(pageController),
                SizedBox(
                  height: 20.h,
                ),
                buildAgreementTipsWidget(pageController),
                SizedBox(
                  height: 100.h,
                ),
                buildSubmitButton(pageController),
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
        '新用户注册',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
      ),
    );
  }

  // 文本输入框容器
  Widget buildInputContainerWidget(CSRegisterPageController controller) {
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
          Obx(
            () => WMSVerificationCodeInputWidget(
              callback: controller.requestGetVerificationCode,
              btnText: controller.btnText.value,
              controller: controller.codeController,
            ),
          )
        ],
      ),
    );
  }

  Widget buildSubmitButton(CSRegisterPageController controller) {
    return Container(
      margin: EdgeInsets.only(top: 80.h),
      height: 34.h,
      width: 300.w,
      child: GestureDetector(
        onTap: controller.onTopNextBtnHandle,
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

  Widget buildAgreementTipsWidget(CSRegisterPageController pageController) {
    return Container(
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
                text: "注册表示您已阅读并同意 ",
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
            ])),
          ],
        ),
      ),
    );
  }
}
