import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ota_update/ota_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/customer/common.dart';
import 'package:wms/models/version_model.dart';
import 'package:wms/utils/aot_utils.dart';
import 'package:wms/utils/toast_util.dart';

import '../../customer/login/controllers/cs_login_page_controller.dart';

class StatementWidget extends StatelessWidget {
  CSLoginPageController pageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: ClipRRect(
          child: Container(
            height: 140.h,
            width: 262.w,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  child: WMSText(
                    content: '服务协议及隐私保护',
                    bold: true,
                    size: 20,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: RichText(
                    text: TextSpan(children: <InlineSpan>[
                      TextSpan(
                          text: '为了更好的保障您的合法权益，请您阅读并同意以下协议',
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                          text: '《用户协议》',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              pageController.onTapUserAgreementBtnHandle();
                            }),
                      TextSpan(
                          text: '《隐私政策》',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("asdasd");

                              pageController.onTopPrivacyPolicyBtnHandle();
                            })
                    ]),
                  ),
                )),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: MaterialButton(
                        height: 38.h,
                        onPressed: () {
                          Get.back();
                        },
                        child: WMSText(content: '不同意', size: 16),
                      )),
                      Expanded(
                          child: MaterialButton(
                        height: 38.h,
                        color: AppConfig.themeColor,
                        onPressed: () {
                          pageController.setPrivacyValue(true);
                          Get.back();
                        },
                        child: WMSText(content: '同意', size: 16),
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
