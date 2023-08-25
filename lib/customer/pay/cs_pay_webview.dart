import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class PaymentWebPage extends StatefulWidget {
  final String title;
  final String url;

  const PaymentWebPage({Key key, this.title, this.url}) : super(key: key);

  @override
  WMSWebPageState createState() => WMSWebPageState();
}

class WMSWebPageState extends State<PaymentWebPage> {
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
    // return WebviewScaffold(
    //   appBar: _setTitle(context),
    //   url: widget.url,
    //   mediaPlaybackRequiresUserGesture: false,
    //   withZoom: false,
    //   withLocalStorage: true,
    //   hidden: false,
    // );
    return Scaffold(
      appBar: _setTitle(context),
      body: Container(
        child: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            // controller.loadUrl('assets/htmls/topay.html');
            controller.loadString(r"""
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://gw.alipayobjects.com/as/g/h5-lib/alipayjsapi/3.1.1/alipayjsapi.inc.min.js"></script>
    <script src="https://cdn.bootcss.com/vConsole/3.2.0/vconsole.min.js"></script>

    <title>Alipay-demo</title>
  </head>
  <body>
    <div class="parent">
      hello
      <div class="child" contenteditable="true">world</div>
      <button class="btn1" onclick="fn()">点击1y</button>
      <button class="btn2">点击2x</button>
    </div>
    <script>
      var vConsole = new window.VConsole();
      function ready(callback) {
        if (window.AlipayJSBridge) {
          callback && callback();
          console.log(1);
        } else {
          console.log("请在支付宝打开");
          document.addEventListener("AlipayJSBridgeReady", callback, false);
          window.AlipayJSBridge = {
            call: function () {
              console.log("mock AlipayJSBridge call");
            },
          };
        }
      }
      ready(function () {
        document.querySelector(".btn2").addEventListener("click", function () {
          AlipayJSBridge.call(
            "beehiveOptionsPicker",
            {
              title: "还款日选择",
              optionsOne: [
                "每周一",
                "每周二",
                "每周三",
                "每周四",
                "每周五",
                "每周六",
                "每周日",
              ],
              selectedOneIndex: 2,
            },
            function (result) {
              alert(JSON.stringify(result));
            }
          );
          // AlipayJSBridge.call(
          //   "chooseContact",
          //   {
          //     title: "choose contacts", // title show on the title bar
          //     multiMax: 2, // max contact items size, default 50
          //     multiMaxText: "max!", // message if selected more than max
          //   },
          //   function (result) {
          //     alert(JSON.stringify(result));
          //   }
          // );
        });
      });
      function fn() {
        alert("sdsd");
        AlipayJSBridge.call("toast", {
          content: "请填写正确的姓名",
          type: "none",
          duration: 2000,
        });
      }
    </script>
  </body>
</html>
            """);
          },
        ),
      ),
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
