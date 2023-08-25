import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/utils/easy_loading_util.dart';

class WebviewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebviewPage({Key key, this.title = '关于我们', this.url}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: widget.title ?? '',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: WebView(
        initialUrl: widget.url,
        onPageStarted: (String url) {
          print('Page started loading: $url');
          EasyLoadingUtil.showLoading();
        },
        onPageFinished: (String url) {
          EasyLoadingUtil.hidden();
          print('Page finished loading: $url');
        },
        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoadingUtil.popHidden();
  }
}
