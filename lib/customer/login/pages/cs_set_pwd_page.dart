import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_set_pwd_widget.dart';
import 'package:wms/customer/login/controllers/cs_set_pwd_page_controller.dart';

class CSSetPwdPage extends StatelessWidget {
  final String phoneNum;

  const CSSetPwdPage({Key key, this.phoneNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CSSetPwdPageController pageController =
        Get.put(CSSetPwdPageController(phoneNum));

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
                buildSubmitButton(pageController),
                SizedBox(
                  height: 260.h,
                ),
                buildAgreementTipsWidget(),
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
        '设置登录密码',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
      ),
    );
  }

  // 文本输入框容器
  Widget buildInputContainerWidget(CSSetPwdPageController pageController) {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      child: Column(
        children: [
          Obx(
            () => WMSSetPwdWidget(
              hinText: '6-20位数字、字母、标点符号（至少两种）',
              controller: pageController.pwdController1,
              callback: pageController.changeShow1,
              show: pageController.show1.value,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Obx(
            () => WMSSetPwdWidget(
              hinText: '确认新密码',
              controller: pageController.pwdController2,
              callback: pageController.changeShow2,
              show: pageController.show2.value,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            width: 300.w,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: pageController.agentCodeController,
                    decoration: InputDecoration(
                      hintText: '请输入邀请码，如无可填123456',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSubmitButton(CSSetPwdPageController pageController) {
    return Container(
      margin: EdgeInsets.only(top: 80.h),
      height: 34.h,
      width: 300.w,
      child: GestureDetector(
        onTap: pageController.onTapSubmitBtnHandle,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Center(
            child: Text(
              '提交',
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

  Widget buildAgreementTipsWidget() {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: "注册表示您已阅读并同意 ",
        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
      ),
      TextSpan(
        text: "用户协议、",
        style: TextStyle(
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w600),
      ),
      TextSpan(
        text: "隐私政策",
        style: TextStyle(
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w600),
      ),
    ]));
  }
}
