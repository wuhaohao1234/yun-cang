import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/customer/common.dart';
import 'package:wms/customer/login/pages/cs_login_page.dart';
import 'package:wms/customer/others/webview_page.dart';
import 'agreement_second_widget.dart';

class AgreementWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: ClipRRect(
          child: Container(
            height: 440.h,
            width: 262.w,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  child: WMSText(
                    content: "温馨提示",
                    bold: true,
                    size: 20,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: '欢迎使用云仓！',
                                style: TextStyle(color: Colors.black))),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text: '云仓一贯重视用户个人信息保护，请您在使用本软件前，务必仔细阅读并充分理解',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: '《用户协议》',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(
                                    () => WebviewPage(
                                      url: AppGlobalConfig.userAAgreement,
                                      title: '用户协议',
                                    ),
                                  );
                                }),
                          TextSpan(
                              text: '和', style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(
                                    () => WebviewPage(
                                      url: AppGlobalConfig.privacyAgreement,
                                      title: '隐私政策',
                                    ),
                                  );
                                }),
                          TextSpan(
                              text: '的详细信息，了解我们为您提供的服务方式和目的。',
                              style: TextStyle(color: Colors.black))
                        ])),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text:
                                  '您在使用本软件过程中我们将如何处理您的个人信息，以下特别说明，在点击“同意”后开始使用：',
                              style: TextStyle(color: Colors.black)),
                        ])),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text: '1、为实现用户注册、登录我们可能需要收集您的手机号码、密码。',
                              style: TextStyle(color: Colors.black)),
                        ])),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text: '2、为实现购物下单，我们可能需要手机您的订单信息和支付信息。',
                              style: TextStyle(color: Colors.black)),
                        ])),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text:
                                  '3、为实现交付商品/服务，我们可能需要收集收货人姓名、收货地址、联系电话、身份信息。',
                              style: TextStyle(color: Colors.black)),
                        ])),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text: '4、为实现商品/服务展示，我们可能会申请使用您的相机、相册权限。',
                              style: TextStyle(color: Colors.black)),
                        ])),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text:
                                  '5、为了向您提供安全保障，我们可能需要收集您的用户信息、交易信息、日志信息及其他必要信息。',
                              style: TextStyle(color: Colors.black)),
                        ])),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text:
                                  '6、基于您的明示授权，我们会出于实现我们的产品/服务功能您所收集的个人信息进行使用。',
                              style: TextStyle(color: Colors.black)),
                        ])),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text: '7、我们会采取符合业界标准、合理可行的安全技术措施保护您提供的个人信息安全。',
                              style: TextStyle(color: Colors.black)),
                        ])),
                        RichText(
                            text: TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text: '8、您可以通过注销账户功能行使个人信息权。',
                              style: TextStyle(color: Colors.black)),
                        ]))
                      ],
                    ),
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  height: 60.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: MaterialButton(
                        minWidth: 200.w,
                        color: AppConfig.themeColor,
                        onPressed: () {
                          SPUtils.setIsFirst(false);
                          Get.offAll(CSLoginPage());
                        },
                        child: WMSText(content: '同意并继续', size: 16),
                      )),
                      Expanded(
                          child: MaterialButton(
                        minWidth: 200.w,
                        onPressed: () {
                          Get.to(AgreementSecondWidget(),
                              opaque: true,
                              duration: Duration(milliseconds: 50));
                        },
                        child: WMSText(
                            content: '不同意',
                            size: 14,
                            bold: false,
                            color: Colors.grey),
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
      ),
    );
  }
}
