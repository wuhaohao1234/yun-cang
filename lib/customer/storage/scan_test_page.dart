// 扫码页面

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scan/scan.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'dart:convert';

class ScanTestPage extends StatefulWidget {
  const ScanTestPage({Key key}) : super(key: key);

  @override
  _ScanTestPageState createState() => _ScanTestPageState();
}

class _ScanTestPageState extends State<ScanTestPage> {
  ScanController controller = ScanController();

  bool sgd = false;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {} on PlatformException {}
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: WMSText(
            content: '扫码',
            size: AppStyleConfig.navTitleSize,
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 375.w,
              height: 667.h,
              child: ScanView(
                controller: controller,
                scanAreaScale: .7,
                scanLineColor: Colors.green.shade400,
                onCapture: (data) {
                  if (data.substring(0, 4) == 'MMM=') {
                    final res = json.decode(data
                        .substring(4, data.length)
                        .replaceAll("'", "\""))['k5'];
                    Get.back(result: res);
                  } else {
                    Get.back(result: data);
                  }
                },
              ),
            ),
            Positioned(
              bottom: 100.h,
              child: IconButton(
                onPressed: () {
                  controller.toggleTorchMode();
                  sgd = !sgd;
                  setState(() {});
                },
                icon: Icon(
                  Icons.wb_incandescent,
                  size: 30.w,
                  color: sgd ? Colors.yellow : Colors.white,
                ),
              ),
            ),
          ],
        )
        // body: Column(
        //   children: [
        //     Text('Running on: $_platformVersion\n'),
        //     Wrap(
        //       children: [
        //         ElevatedButton(
        //           child: Text("toggleTorchMode"),
        //           onPressed: () {
        //             controller.toggleTorchMode();
        //           },
        //         ),
        //         ElevatedButton(
        //           child: Text("pause"),
        //           onPressed: () {
        //             controller.pause();
        //           },
        //         ),
        //         ElevatedButton(
        //           child: Text("resume"),
        //           onPressed: () {
        //             controller.resume();
        //           },
        //         ),
        //         ElevatedButton(
        //           child: Text("parse from image"),
        //           onPressed: () async {
        //             // List<Media>? res = await ImagesPicker.pick();
        //             // if (res != null) {
        //             //   String? str = await Scan.parse(res[0].path!);
        //             //   if (str != null) {
        //             //     setState(() {
        //             //       qrcode = str;
        //             //     });
        //             //   }
        //             // }
        //           },
        //         ),
        //       ],
        //     ),
        //     Container(
        //       width: 220,
        //       height: 400,
        //       child: ScanView(
        //         controller: controller,
        //         scanAreaScale: .7,
        //         scanLineColor: Colors.green.shade400,
        //         onCapture: (data) {
        //           setState(() {
        //             qrcode = data;
        //           });
        //         },
        //       ),
        //     ),
        //     Text('scan result is $qrcode'),
        //   ],
        // ),
        );
  }
}
