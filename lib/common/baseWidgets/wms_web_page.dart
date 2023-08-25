import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';

class WMSWebPage extends StatefulWidget {
  final String title;
  final String url;

  const WMSWebPage({Key key, this.title, this.url}) : super(key: key);

  @override
  _WMSWebPageState createState() => _WMSWebPageState();
}

class _WMSWebPageState extends State<WMSWebPage> {
  FlutterWebviewPlugin _webViewPlugin = FlutterWebviewPlugin();
  double lineProgress = 0.0;

  @override
  initState() {
    super.initState();
    _webViewPlugin.onProgressChanged.listen((progress) {
      print(progress.toString());
      setState(() {
        lineProgress = progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: _setTitle(context),
      url: widget.url,
      mediaPlaybackRequiresUserGesture: false,
      withZoom: true,
      withLocalStorage: true,
      hidden: false,
      useWideViewPort: true,
    );
  }

  _setTitle(context) {
    return AppBar(
      centerTitle: true,
      elevation: 0.0,
      title: WMSText(
        content: widget.title,
        size: AppStyleConfig.navTitleSize,
      ),
      bottom: PreferredSize(
        child: _progressBar(lineProgress, context),
        preferredSize: Size.fromHeight(0.1),
      ),
    );
  }

  _progressBar(double progress, BuildContext context) {
    return Container(
      child: LinearProgressIndicator(
        backgroundColor: Colors.white,
        value: progress.toInt() == 1 ? 0 : progress,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppStyleConfig.enThemColor,
        ),
      ),
      height: 2,
    );
  }

  @override
  void dispose() {
    _webViewPlugin.dispose();

    super.dispose();
    _webViewPlugin.dispose();
  }
}
