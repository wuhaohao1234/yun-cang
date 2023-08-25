// 扫码添加商品
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

import 'package:flutter/services.dart';
import 'package:scan/scan.dart';
import 'en_search_page.dart';
import '../ruku/lihuo/en_shangping_search.dart';
import 'dart:convert';

class ENScanStandardPage extends StatefulWidget {
  final String title;
  final String searchType;
  final String manuallyplaceHolder;
  final int prepareOrderId;
  final int orderOperationalRequirements;

  // 默认返回按钮
  // 样例
  // IconButton(
  //         icon: Icon(
  //           Icons.arrow_back_ios_rounded,
  //           color: Colors.white,
  //         ),
  //         onPressed: () => Get.back(),
  //       )
  final IconButton leading;

  const ENScanStandardPage(
      {Key key,
      this.title,
      this.manuallyplaceHolder,
      this.searchType = 'other',
      this.prepareOrderId,
      this.orderOperationalRequirements,
      this.leading})
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
    print("initState-----");
    controller = ScanController();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        show = true;
      });
    });
    super.initState();
    // initPlatformState();
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
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            title: WMSText(
              content: widget.title,
              size: AppStyleConfig.navTitleSize,
            ),
            leading: widget.leading,
          ),
          backgroundColor: Colors.black,
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
                      // 如果是二维码,MMM 开头, 就解析处理
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
                    print(widget.searchType);
                    print(widget.orderOperationalRequirements);
                    if (widget.searchType == 'shangpin') {
                      Get.to(() => SkuSearchPage(
                          placeHolder: '请输入商品货号',
                          prepareOrderId: widget.prepareOrderId,
                          orderOperationalRequirements: widget.orderOperationalRequirements));
                    } else {
                      Get.to(
                        () => ENSearchPage(
                          placeHolder: widget.manuallyplaceHolder,
                        ),
                      );
                    }
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
        ),
        onWillPop: () {
          return Future.value(widget.leading != null ? false : true);
        });
  }
}
