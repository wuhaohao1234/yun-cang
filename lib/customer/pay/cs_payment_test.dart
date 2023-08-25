import 'package:wms/customer/common.dart'; //页面通用依赖集合
// import 'package:intl/intl.dart';
import 'cs_pay_webview.dart';
import 'pay_calls.dart';

// 测试支付

class PaymentTestPage extends StatefulWidget {
  PaymentTestPage({Key key}) : super(key: key);

  @override
  PaymentTestPageState createState() => PaymentTestPageState();
}

class PaymentTestPageState extends State<PaymentTestPage> {
  final hs = HttpServices();
  String alipayInstalled = "Unknown";
  String wechatInstalled = "Unknown";
  String openId = "Unknown";
  PayCallController payCallController;
  final aliPrice = 1.2;

  @override
  void initState() {
    super.initState();
    payCallController = Get.put(PayCallController());
    payCallController.registerWechatMp(00);
  }

  void toAliPay() async {
    await payCallController.toAliPay(1.2,00);
  }

  void toWeChatPayMpPay() async {
    // 跳转微信小程序支付
    payCallController.toWeChatPayMpPay(0.2,1);
  }

  void toWebView() {
    Get.to(() => PaymentWebPage(
          title: "测试",
          url: "https://google.com",
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: WMSText(
            content: '测试支付',
            size: AppStyleConfig.navTitleSize,
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Text("微信安装状态: $wechatInstalled"),
              ElevatedButton(
                  child: Text("微信支付0.2元"), onPressed: toWeChatPayMpPay),
              ElevatedButton(child: Text("支付宝付款1.2元"), onPressed: toAliPay)
            ],
          ),
        ));
  }
}
