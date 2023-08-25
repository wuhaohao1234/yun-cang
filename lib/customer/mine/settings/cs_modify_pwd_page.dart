import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/mine/controllers/cs_modify_pwd_page_controller.dart';

class CSModifyPwdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CSModifyPwdPageController pageController = Get.put(CSModifyPwdPageController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w, bottom: 20.h),
            child: Column(
              children: [
                buildTopTitleWidget(),
                buildInputContainerWidget(pageController),
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
        '手机号验证码输入',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
      ),
    );
  }

  // 文本输入框容器
  Widget buildInputContainerWidget(CSModifyPwdPageController pageController) {
    return Container(
      margin: EdgeInsets.only(top: 50.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: WMSText(
                content: '将向手机号：${WMSUser.getInstance().userInfoModel.phoneNum} 发送验证码',
                size: 13,
              )),
          SizedBox(
            height: 20.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: pageController.codeC,
                    decoration: InputDecoration(
                      hintText: '请输验证码',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: pageController.btnText.value == '获取验证码' ? pageController.onTapSendCodeHandle : null,
                    child: Obx(
                      () => Text(
                        pageController.btnText.value,
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSubmitButton(CSModifyPwdPageController pageController) {
    return Container(
      margin: EdgeInsets.only(top: 80.h),
      height: 34.h,
      width: 300.w,
      child: GestureDetector(
        onTap: pageController.requestCommitHandle,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Center(
            child: Text(
              '下一步',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
