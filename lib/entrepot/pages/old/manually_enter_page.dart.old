import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_button.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/entrepot/controllers/old/manually_enter_page_controller.dart.old';
class ManuallyEnterPage extends StatelessWidget {
  const ManuallyEnterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ManuallyEnterPageController pageController = Get.put(ManuallyEnterPageController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: WMSText(
          content: '手动输入',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        width: 375.w,
        child: Column(
          children: [
            Container(
              height: 44.h,
              width: 200.w,
              margin: EdgeInsets.only(top: 100.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.h,color: Colors.green[100],),),),
              child: TextField(
                textAlign: TextAlign.center,
                cursorColor: Colors.black,
                controller: pageController.textC,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: '请输入快递单号/入仓号',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 13.sp),
                ),
              ),
            ),
            SizedBox(height: 100.h,),
            WMSButton(width: 300.w,title: '提交',callback: pageController.onTapSubmitHandle,bgColor: AppStyleConfig.btnColor,),
          ],
        ),
      ),
    );
  }
}
