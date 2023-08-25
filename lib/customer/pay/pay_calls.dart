import 'package:get/get.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
// import 'package:wms/configs/app_config.dart';
import 'package:wms/network/http_services.dart';
import 'package:fluwx/fluwx.dart' as Fluwx;
import 'dart:convert';
import 'package:tobias/tobias.dart' as tobias;
import 'package:url_launcher/url_launcher.dart';

class PayCallController extends GetxController {
  RxDouble price = 0.0.obs;
  RxBool wechatInstalled = false.obs;
  RxString wechatAuthCode = "Unknown".obs;
  RxString openId = "Unknown".obs;

  RxBool wechatAuthed = false.obs;
  final hs = HttpServices();
  RxInt orderId = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  clearInfo() {
    price.value = 0.0;
    wechatInstalled.value = false;
    wechatAuthCode.value = "Unknown";
    openId.value = "Unknown";
    wechatAuthed.value = false;
  }

  createOrder(String openId, {int payChannel, num orderId}) async {
    print("orderId...${orderId}");
    // payChannel 支付方式 0-默认 1-微信支付 2-支付宝支付 3-银行卡 4-店铺余额
    final orderInfo = await hs.submitPaymentInfo(
        openId: openId,
        price: price.value,
        payChannel: payChannel,
        orderId: orderId);
    print("orderInfo  --- ${orderInfo}");
    if (orderInfo == false) {
      EasyLoadingUtil.showMessage(message: "后台接口返回错误");
      return false;

      // return "false";
    }
    return orderInfo;
  }

  void toWeChatPayMpPay(double wxPrice,int orderId) async {
    price.value = wxPrice;
    this.orderId.value = orderId;
    // 跳转微信小程序支付
    final apiReg = await Fluwx.registerWxApi(
      appId: AppConfig.wechatAppId,
      universalLink:
          AppConfig.universalLink == "" ? null : AppConfig.universalLink,
    );
    print("api 注册结果: $apiReg");
    bool installed;
    installed = true;
    installed = await Fluwx.isWeChatInstalled;
    print("微信安装状况: $installed");
    if (!installed) {
      EasyLoadingUtil.showMessage(message: "请先安装微信以完成支付");
    }
    wechatInstalled.value = installed;
    final authSucceed = await Fluwx.sendWeChatAuth(
        scope: "snsapi_userinfo", state: "wechat_sdk_demo_test");
    print("认证结果: $authSucceed");
  }

  createWeChatOrder(wxOpenId) async {
    print("orderId???${orderId.value}");
    final payOrderInfo =
        await createOrder(wxOpenId, payChannel: 1, orderId: orderId.value);
    if (payOrderInfo == false) {
      EasyLoadingUtil.showMessage(message: "后台接口返回错误");
      return;
    }
    final payOrderId = json.decode(payOrderInfo['payOrderId']);
    final base64Str = base64.encode(utf8.encode(json.encode(payOrderId)));
    final callMpSuccess = await Fluwx.launchWeChatMiniProgram(
      username: AppConfig.wechatOriginalId,
      path: "pages/payThroughApp/index?payOrderId=$base64Str",
      miniProgramType: Fluwx.WXMiniProgramType.RELEASE,
    );

    if (!callMpSuccess) {
      EasyLoadingUtil.showMessage(message: "调起微信支付失败");
    }
  }

  registerWechatMp(orderId) {
    // ignore second call once created.
    if (wechatAuthed.value == true) {
      return;
    }
    wechatAuthed.value = true;
    price.value = 0.0;
    Fluwx.weChatResponseEventHandler.listen((res) async {
      print(res);
      if (res is Fluwx.WeChatAuthResponse) {
        var wxOpenId;
        if (res.code == wechatAuthCode.value) {
          print('使用缓存的openid=${openId.value}');
          wxOpenId = openId.value;
        } else {
          wechatAuthCode.value = res.code;

          wxOpenId = await HttpServices().getWeChatOpenId(code: res.code);
          print('重新获取openid=$wxOpenId');
          if (wxOpenId is bool) {
            return;
          }
          openId.value = wxOpenId;
        }
        await createWeChatOrder(wxOpenId);
      } else if (res is Fluwx.WeChatPaymentResponse) {
        print(res);
      }
    });
  }

  preAliPay(double aliPrice, num orderId) async {
    price.value = aliPrice;
    final installed = await tobias.isAliPayInstalled();
    if (!installed) {
      EasyLoadingUtil.showMessage(message: "请先安装支付宝以完成支付");
      return;
    }
    final baseApiInfo =
        "apiname=com.alipay.account.auth&method=alipay.open.auth.sdk.code.get&app_id=${AppConfig.alipayAppId}&app_name=mc&biz_type=openservice&pid=${AppConfig.alipayPid}&product_id=APP_FAST_LOGIN&scope=kuaijie&target_id=20141225xxxx&auth_type=AUTHACCOUNT&sign_type=RSA2";
    final url =
        '$baseApiInfo&sign=fMcp4GtiM6rxSIeFnJCVePJKV43eXrUP86CQgiLhDHH2u%2FdN75eEvmywc2ulkm7qKRetkU9fbVZtJIqFdMJcJ9Yp%2BJI%2FF%2FpESafFR6rB2fRjiQQLGXvxmDGVMjPSxHxVtIqpZy5FDoKUSjQ2%2FILDKpu3%2F%2BtAtm2jRw1rUoMhgt0%3D';
    final res = await tobias.aliPayAuth(url);

    // final res = await tobias.aliPayAuth("weqwqe");
    if (res['resultStatus'] != "9000") {
      EasyLoadingUtil.showMessage(message: "授权失败");
      return;
    }
    EasyLoadingUtil.showMessage(message: "授权成功");
    final result = res['result'];
    Map userRes = {};
    result.split("&").forEach((e) {
      final kv = e.split("=");
      userRes[kv[0]] = kv[1];
    });
    final payOrderInfo =
        await createOrder(userRes['user_id'], payChannel: 2, orderId: orderId);
    final urlRaw =
        "${AppConfig.alipayUrl}?prepay_id=${payOrderInfo['payOrderId']}";

    // final urlRaw = "https://www.baidu.com";
    print('urlRaw is $urlRaw');
    return urlRaw;
  }

  toAliPay(double aliPrice, num orderId) async {
    final urlRaw = await preAliPay(aliPrice, orderId);
    launch(
        "alipays://platformapi/startapp?appId=20000067&url=${Uri.encodeFull(urlRaw)}");
  }
}
