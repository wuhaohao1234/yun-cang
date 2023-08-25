import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/customer/common.dart';
import 'package:wms/customer/login/pages/cs_login_page.dart';
import 'package:wms/customer/others/webview_page.dart';

class AgreementSecondWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: ClipRRect(
          child: Container(
            height: 160.h,
            width: 262.w,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  child: WMSText(
                    content: "欢迎使用云仓！",
                    bold: true,
                    size: 20,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text: '请您相信，我们将尽力保护您的个人信息。如您不同意',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(
                                    () => WebviewPage(
                                      url: AppGlobalConfig.privacyAgreement,
                                      title: '隐私政策',
                                    ),
                                  );
                                }),
                          TextSpan(
                              text: '，很遗憾我们将无法为您提供服务。',
                              style: TextStyle(color: Colors.black))
                        ])),
                      ],
                    ),
                  ),
                )),
                Container(
                  height: 60.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: MaterialButton(
                        minWidth: 200.w,
                        color: AppConfig.themeColor,
                        onPressed: () {
                          SPUtils.setIsFirst(false);
                          Get.offAll(CSLoginPage());
                        },
                        child: WMSText(content: '同意使用', size: 16),
                      )),
                      Expanded(
                          child: MaterialButton(
                        minWidth: 200.w,
                        onPressed: () {
                          exit(0);
                        },
                        child: WMSText(content: '不同意使用', size: 14,bold: false,color: Colors.grey),
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
      ),
    );
  }
}
