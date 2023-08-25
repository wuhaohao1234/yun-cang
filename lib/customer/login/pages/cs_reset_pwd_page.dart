import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_set_pwd_widget.dart';
import 'package:wms/customer/login/controllers/cs_reset_pwd_page_controller.dart';

class CSResetPwdPage extends StatelessWidget {
  final String mobile;
  final String code;

  CSResetPwdPage({Key key, this.mobile, this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CSResetPwdPageController pageController =
        Get.put(CSResetPwdPageController());

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
                buildTipsWidget(),
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
        '设置登录密码',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
      ),
    );
  }

  Widget buildTipsWidget() {
    return Container(
      width: 300.w,
      margin: EdgeInsets.only(top: 20.h),
      alignment: Alignment(-1, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '为您的账号设置一个新密码',
            style: TextStyle(color: Colors.grey, fontSize: 13.sp),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            mobile,
            style: TextStyle(color: Colors.grey, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  // 文本输入框容器
  Widget buildInputContainerWidget(CSResetPwdPageController pageController) {
    return Container(
        margin: EdgeInsets.only(top: 40.h),
        child: Obx(
          () => Column(
            children: [
              WMSSetPwdWidget(
                hinText: '6-20位数字、字母、标点符号（至少两种）',
                controller: pageController.controller1,
                callback: pageController.changeShow1,
                show: pageController.show1.value,
              ),
              SizedBox(
                height: 10.h,
              ),
              WMSSetPwdWidget(
                hinText: '确认新密码',
                controller: pageController.controller2,
                callback: pageController.changeShow2,
                show: pageController.show2.value,
              ),
              // SizedBox(
              //   height: 10.h,
              // ),
              // Container(
              //   width: 300.w,
              //   decoration: BoxDecoration(
              //     border: Border(
              //       bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           cursorColor: Colors.black,
              //           controller: pageController.agentCodeController,
              //           decoration: InputDecoration(
              //             hintText: '请输入邀请码，如无可填123456',
              //             border: InputBorder.none,
              //             hintStyle: TextStyle(fontSize: 13.sp),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ));
  }

  Widget buildSubmitButton(CSResetPwdPageController pageController) {
    return Container(
      margin: EdgeInsets.only(top: 80.h),
      height: 34.h,
      width: 300.w,
      child: GestureDetector(
        onTap: () =>
            pageController.requestCommitHandle(mobile: mobile, code: code),
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
}
