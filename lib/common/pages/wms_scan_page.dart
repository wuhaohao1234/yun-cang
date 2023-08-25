import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:wms/common/pages/wms_scan_page_controller.dart';

class WMSScanPagae extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // WMSScanPageController pageController = Get.put(WMSScanPageController());
    return Scaffold(
      backgroundColor: Color.fromRGBO(72, 72, 72, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(72, 72, 72, 1),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          '扫码',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
