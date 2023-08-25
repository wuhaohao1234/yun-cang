import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/entrepot/controllers/en_scan_result_page_controller.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

class ENScanResultPage extends StatelessWidget {
  final String mailNo;

  const ENScanResultPage({Key key, this.mailNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ENScanResultPageController pageController =
        Get.put(ENScanResultPageController(mailNo));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '扫描结果',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Center(
              child: WMSText(
                content: '未匹配到预约入库单${mailNo ?? ''}',
              ),
            ),
            Positioned(
              bottom: 100.h,
              child: buildButtonWidget(
                width: 280.w,
                height: 34.h,
                radius: 2.0,
                bgColor: AppConfig.themeColor,
                contentColor: Colors.white,
                buttonContent: '生成预约入库单',
                handelClick: pageController.onTapCreateYbrkHandle,
              ),
            ),
            Positioned(
              bottom: 40.h,
              child: buildButtonWidget(
                width: 280.w,
                height: 34.h,
                radius: 2.0,
                bgColor: Colors.red,
                borderColor: Colors.red,
                contentColor: Colors.white,
                buttonContent: '生成无主单',
                handelClick: pageController.onTapCreateWzdHandle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
