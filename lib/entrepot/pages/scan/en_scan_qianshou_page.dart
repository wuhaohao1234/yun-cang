// 收货页面扫描
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

import 'package:flutter/services.dart';
import 'package:scan/scan.dart';
import 'en_search_page.dart';
import 'dart:convert';

class ENScanQianShouPage extends StatefulWidget {
  const ENScanQianShouPage({Key key}) : super(key: key);

  @override
  _ENScanQianShouPageState createState() => _ENScanQianShouPageState();
}

class _ENScanQianShouPageState extends State<ENScanQianShouPage> {
  ScanController controller;

  bool show = false;
  bool sgd = false;

  @override
  void initState() {
    super.initState();
    controller = ScanController();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        show = true;
      });
    });
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
          content: '扫码签收',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 375.w,
            height: 667.h,
            child: Visibility(
              visible: show,
              child: ScanView(
                controller: controller,
                scanAreaScale: .7,
                scanLineColor: Colors.green.shade400,
                onCapture: (data) {
                  if (data.substring(0, 4) == 'MMM=') {
                    final res = json.decode(data.substring(4, data.length).replaceAll("'", "\""))['k5'];
                    Get.back(result: res);
                  } else {
                    Get.back(result: data);
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: 100.h,
            child: IconButton(
              onPressed: () {
                //csm goto
                Get.to(
                  () => ENSearchPage(
                    placeHolder: "请输入商品单号",
                  ),
                );
              },
              icon: Icon(
                Icons.edit,
                size: 30.w,
                color: sgd ? Colors.yellow : Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 50.h,
            right: 100.h,
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
      ),
    );
  }
}
