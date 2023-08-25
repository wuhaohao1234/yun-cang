// 扫码添加商品
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

import 'package:flutter/services.dart';
import 'package:scan/scan.dart';
import 'dart:convert';

class ENScanStandardPage extends StatefulWidget {
  final String title;
  final String searchType;
  final String manuallyplaceHolder;
  final int prepareOrderId;
  final int orderOperationalRequirements;

  const ENScanStandardPage(
      {Key key,
      this.title,
      this.manuallyplaceHolder,
      this.searchType = 'other',
      this.prepareOrderId,
      this.orderOperationalRequirements})
      : super(key: key);

  @override
  _ENScanStandardPageState createState() => _ENScanStandardPageState();
}

class _ENScanStandardPageState extends State<ENScanStandardPage> {
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

  @override
  void dispose() {
    setState(() {
      show = false;
    });
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: widget.title,
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
          // Positioned(
          //   bottom: 50.h,
          //   left: 100.h,
          //   child: IconButton(
          //     onPressed: () {
          //       //csm goto
          //       if (widget.searchType == 'shangpin') {
          //         Get.to(
          //           () => SkuSearchPage(
          //             prepareOrderId: widget.prepareOrderId,
          //             placeHolder: widget.manuallyplaceHolder,
          //             orderOperationalRequirements:
          //                 widget.orderOperationalRequirements,
          //           ),
          //         );
          //       } else {
          //         Get.to(
          //           () => ENSearchPage(
          //             placeHolder: widget.manuallyplaceHolder,
          //           ),
          //         );
          //       }
          //     },
          //     icon: Icon(
          //       Icons.edit,
          //       size: 30.w,
          //       color: sgd ? Colors.yellow : Colors.white,
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 50.h,
            // right: 100.h,
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
