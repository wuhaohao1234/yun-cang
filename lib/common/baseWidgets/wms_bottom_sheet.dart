import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/pages/wms_choose_area_page.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/views/customer/chu_huo_sheet_widget.dart';

class WMSBottomSheet {
  static showReleaseBtns({BuildContext context, Function(int) callBack}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              // height: 150.h,
              child: Container(
            margin: EdgeInsets.only(left: 40.w, right: 40.w, bottom: 70.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                itemWidget(
                    title: '预约入库',
                    iconData: Icons.send,
                    bgColor: Colors.black,
                    callback: () => callBack(0)),
                itemWidget(
                    title: '出库',
                    iconData: Icons.outbox,
                    bgColor: Colors.black,
                    callback: () => callBack(1)),
              ],
            ),
          ));
        });
  }

  static Widget itemWidget(
      {String title, IconData iconData, Color bgColor, VoidCallback callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        width: (375.w - 32.w) / 4.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50.w,
              width: 50.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r), color: bgColor),
              child: Center(
                child: Icon(
                  iconData,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  //相机/相册
  static Future<T> showCameraSheet<T>(
    BuildContext context, {
    VoidCallback handle1,
    VoidCallback handle2,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, //允许bottomSheet高度自定义
        backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
        builder: (BuildContext c) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              color: Colors.white,
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  width: 375.w,
                  height: 186.h,
                  color: Colors.white,
                  constraints: BoxConstraints(maxHeight: 414.h),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.h),
                            child: WMSText(
                              content: '选择',
                              bold: true,
                              size: AppStyleConfig.titleSize,
                              color: Color(0xFF212121),
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          InkWell(
                            onTap: handle1,
                            child: Container(
                              height: 46.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 20.w,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  WMSText(
                                    content: '相机',
                                    size: AppStyleConfig.titleSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: handle2,
                            child: Container(
                              height: 46.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                    size: 20.w,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  WMSText(
                                    content: '相册',
                                    size: AppStyleConfig.titleSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  //扫码or手动输入
  static Future<T> showScanSheet<T>(
    BuildContext context, {
    VoidCallback handle1,
    VoidCallback handle2,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, //允许bottomSheet高度自定义
        backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
        builder: (BuildContext c) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              color: Colors.white,
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  width: 375.w,
                  height: 146.h,
                  color: Colors.white,
                  constraints: BoxConstraints(maxHeight: 414.h),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.h),
                            child: WMSText(
                              content: '选择',
                              bold: true,
                              size: AppStyleConfig.titleSize,
                              color: Color(0xFF212121),
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                              handle1();
                            },
                            child: Container(
                              height: 46.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 20.w,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  WMSText(
                                    content: '扫码',
                                    size: AppStyleConfig.titleSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                              handle2();
                            },
                            child: Container(
                              height: 46.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 20.w,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  WMSText(
                                    content: '手动输入',
                                    size: AppStyleConfig.titleSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  // 地区选择

  static Future<T> showAreaSheet<T>(
    BuildContext context, {
    Function(String) callback,
    bool countryStatus = false,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, //允许bottomSheet高度自定义
        backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
        builder: (BuildContext c) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              color: Colors.white,
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  width: 375.w,
                  height: 600.h,
                  color: Colors.white,
                  constraints: BoxConstraints(maxHeight: 500.h),
                  child: WMSChooseAreaPage(countryStatus: countryStatus),
                ),
              ),
            ),
          );
        });
  }

  // 地区月分
  static Future<T> showDateSheet<T>(
    BuildContext context, {
    VoidCallback handle1,
    VoidCallback handle2,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, //允许bottomSheet高度自定义
        backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
        builder: (BuildContext c) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              color: Colors.white,
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  width: 375.w,
                  height: 600.h,
                  color: Colors.white,
                  constraints: BoxConstraints(maxHeight: 500.h),
                  child: WMSChooseAreaPage(),
                ),
              ),
            ),
          );
        });
  }

  // 客户端入库单详情操作
  static Future<T> showRkdDetailOptionsSheet<T>(
    BuildContext context, {
    Function(int) callback,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, //允许bottomSheet高度自定义
        backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
        builder: (BuildContext c) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              color: Colors.white,
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  width: 375.w,
                  height: 130.h,
                  color: Colors.white,
                  constraints: BoxConstraints(maxHeight: 414.h),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              callback(0);
                            },
                            child: Container(
                              height: 46.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WMSText(
                                    content: '修改入库单',
                                    size: AppStyleConfig.titleSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                              callback(1);
                            },
                            child: Container(
                              height: 46.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WMSText(
                                    content: '预约入库单',
                                    size: AppStyleConfig.titleSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  // 客户端我的在售详情上架商品
  static Future<T> showCSshelvesSheet<T>(
    BuildContext context, {
    Function(int) callback,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, //允许bottomSheet高度自定义
        backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
        builder: (BuildContext c) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              color: Colors.white,
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  width: 375.w,
                  height: 130.h,
                  color: Colors.white,
                  constraints: BoxConstraints(maxHeight: 414.h),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              callback(0);
                            },
                            child: Container(
                              height: 46.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WMSText(
                                    content: '得物（毒/POIZION）',
                                    size: AppStyleConfig.titleSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                              callback(1);
                            },
                            child: Container(
                              height: 46.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WMSText(
                                    content: 'APP出货',
                                    size: AppStyleConfig.titleSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  // 下单
  static Future<T> showPlaceOrderSheet<T>(
    BuildContext context, {
    Function(int) callback,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, //允许bottomSheet高度自定义
        backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
        builder: (BuildContext c) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              color: Colors.white,
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  width: 375.w,
                  height: 260.h,
                  color: Colors.white,
                  constraints: BoxConstraints(maxHeight: 414.h),
                  child: SingleChildScrollView(
                      // child: MKPlaceOrderPage(),
                      ),
                ),
              ),
            ),
          );
        });
  }

  // 客户端集市单品在售
  static Future<T> showChuHuoListSheet<T>(
    BuildContext context, {
    dataModel,
    Function(int) callback,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, //允许bottomSheet高度自定义
        backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
        builder: (BuildContext c) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              color: Colors.white,
              child: IntrinsicHeight(
                child: Container(
                    padding: EdgeInsets.all(16.w),
                    width: 375.w,
                    height: 600.h,
                    color: Colors.white,
                    constraints: BoxConstraints(maxHeight: 414.h),
                    child: ChuHuoSheetWidget(
                      dataModel: dataModel,
                    )),
              ),
            ),
          );
        });
  }
}
