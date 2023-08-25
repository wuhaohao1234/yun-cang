import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_button.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/models/version_model.dart';
import 'package:wms/views/dialog/inout_claim_widget.dart';
import 'package:wms/views/dialog/version_update_widget.dart';

class WMSDialog {
  static showOperationPromptDialog(
    BuildContext context, {
    @required String content,
    String confirmStr = '确定',
    String cancelStr = '取消',
    VoidCallback handle,
    VoidCallback cancelHandle,
  }) {
    showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                alignment: Alignment(0, 0),
                child: Container(
                  width: 270.w,
                  height: 126.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Center(
                              child: WMSText(
                                content: content,
                                textAlign: TextAlign.center,
                                bold: true,
                                strutStyle: StrutStyle(
                                    forceStrutHeight: true,
                                    height: 0.7,
                                    leading: 1),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top:
                                  BorderSide(width: 1, color: Colors.grey[100]),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: WMSButton(
                                  radius: 0,
                                  textColor: Colors.black,
                                  bgColor: Colors.white,
                                  title: cancelStr,
                                  callback: () {
                                    Navigator.pop(context);
                                    cancelHandle();
                                  },
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 44.h,
                                color: Colors.grey[100],
                              ),
                              Expanded(
                                child: WMSButton(
                                  radius: 0,
                                  textColor: AppStyleConfig.enThemColor,
                                  title: confirmStr,
                                  bgColor: Colors.white,
                                  callback: () {
                                    Navigator.pop(context);
                                    handle();
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            ),
          );
        });
  }

  // 输入快递 单号后4位
  static showCourierNumberInptDialog(
      BuildContext context, Function(String) callback) {
    showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                alignment: Alignment(0, 0),
                child: InoutClaimWidget(
                  callback: callback,
                ),
              ),
            ),
          );
        });
  }

  // 修改用户名
  static showTextFieldDialog(
      BuildContext context, TextEditingController textC, Function() callback) {
    showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                alignment: Alignment(0, 0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: false,
                    body: Container(
                      child: Center(
                        child: Container(
                          height: 100.h,
                          width: 260.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: Colors.white),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1.h,
                                        color: Colors.grey[100],
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    cursorColor: Colors.black,
                                    controller: textC,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: '请输入用户名',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(fontSize: 13.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                WMSButton(
                                  width: 150.w,
                                  title: '确定',
                                  callback: () {
                                    Get.back();
                                    callback();
                                  },
                                  bgColor: Colors.black,
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  static void showVersionDialog(BuildContext context, VersionModel model) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              alignment: Alignment(0, 0),
              child: VersionUpdateWidget(
                model: model,
              ),
            ),
          ),
        );
      },
    );
  }

  static void showAlertDialog(BuildContext context, content) {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
            child: Center(
              child: Container(
                height: 300,
                width: 250,
                color: Colors.white,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                                child: Icon(Icons.cancel),
                                margin: EdgeInsets.symmetric(
                                    vertical: 4.h, horizontal: 4.w)))),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        content,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
