import 'package:flutter_verification_box/verification_box.dart';
import 'wv_payStatus_widget.dart';
import 'package:wms/views/common/common_style_widget.dart';
//pay
import 'package:wms/customer/common.dart'; //页面通用依赖集合
// import 'package:intl/intl.dart';
import 'package:wms/customer/pay/pay_calls.dart';

class PayDialogWidget extends StatefulWidget {
  // final OrderModel data;
  final num orderSum;
  final int id;
  final Function callBack;
  final int type; // 0 支付 1 确认收货
  final List forbiddenValue;

  const PayDialogWidget({
    Key key,
    this.orderSum,
    this.id,
    this.callBack,
    this.type = 0,
    this.forbiddenValue = const [],
  }) : super(key: key);

  @override
  _PayDialogWidgetState createState() => _PayDialogWidgetState();
}

class _PayDialogWidgetState extends State<PayDialogWidget> {
  bool status = true;
  int moneyIndex = 0;
  int orderId;
  Map selectedPayStatusMap = {
    "lable": '微信',
    "value": 1,
    "icon": SvgPicture.asset(
      'assets/svgs/微信方.svg',
      width: 24,
    ),
  };
  int selectedValue;
// 支付相关
  String alipayInstalled = "Unknown";
  String wechatInstalled = "Unknown";
  String openId = "Unknown";
  PayCallController payCallController;
  String vertifyCode;

  @override
  void initState() {
    orderId = widget.id;
    selectedValue = selectedPayStatusMap['value']; //设置默认为微信支付1；
    payCallController = Get.put(PayCallController());
    payCallController.registerWechatMp(widget.id);
    super.initState();
  }

  // @override
  // void dispose() {
  //   payCallController.clearInfo();
  //   super.dispose();
  // }

  // @override
  // void deactivate() {
  //   payCallController.clearInfo();
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: status,
          child: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 49.0,
                      alignment: Alignment.center,
                      child: Text('请进行支付'),
                    ),
                    Positioned(
                      child: CloseButton(),
                      left: 0,
                      top: 0,
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Align(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: '￥', style: TextStyle(fontSize: 18.0)),
                          TextSpan(
                              text: '${widget?.orderSum ?? 0.0}',
                              style: TextStyle(fontSize: 40.0))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        width: 1,
                        color: Color(0xfff2f2f2),
                      ),
                    ),
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        switchStatus();
                        print('选择支付方式');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '请选择',
                            style: TextStyle(color: Colors.black38),
                          ),
                          Row(
                            children: [
                              if (selectedPayStatusMap['icon'] != null)
                                selectedPayStatusMap['icon'],
                              SizedBox(width: 6.0),
                              Text(selectedPayStatusMap['lable']),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: selectedValue == 4,
                    child: Container(
                      height: 45,
                      margin: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 30.0),
                      child: VerificationBox(
                        showCursor: true,
                        cursorWidth: 2,
                        onSubmitted: submit,
                        onChanged: changeVerfityCode,
                      ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildButtonWidget(
                        width: 120.0,
                        height: 34.0,
                        buttonContent: '取消支付',
                        handelClick: () {
                          Navigator.of(context).pop(false);
                          // Get.to(() =>
                          // CSOrderDetailPage(id: widget.id, navStatus: 1));
                          // Get.to(() => OrderHomePage());
                        },
                        radius: 2.0,
                      ),
                      if (selectedValue != 4)
                        buildButtonWidget(
                          width: 120.0,
                          height: 34.0,
                          contentColor: Colors.white,
                          bgColor: AppConfig.themeColor,
                          buttonContent: '跳转支付',
                          handelClick: () async {
                            if (selectedValue == 1) {
                              payCallController
                                  .toWeChatPayMpPay(widget.orderSum,widget.id);
                            } else if (selectedValue == 2) {
                              await payCallController.toAliPay(
                                  widget.orderSum, widget.id);
                            }

                            Navigator.of(context).pop(false);
                            Future.delayed(Duration(seconds: 5), () {
                              print(widget?.id);
                              WMSDialog.showOperationPromptDialog(context,
                                  content: '请确认是否完成支付？',
                                  confirmStr: '确认完成',
                                  handle: () async {
                                    widget.callBack(widget?.id);
                                    // EasyLoadingUtil.showLoading(statusText: "...");
                                  },
                                  cancelStr: '未完成',
                                  cancelHandle: () {
                                    Navigator.of(context).pop(false);
                                  });
                            });
                          },
                          radius: 2.0,
                        )
                      else
                        buildButtonWidget(
                          width: 120.0,
                          height: 34.0,
                          contentColor: Colors.white,
                          bgColor: AppConfig.themeColor,
                          buttonContent: '确认支付',
                          handelClick: () {
                            requestPay(this.vertifyCode);
                          },
                          radius: 2.0,
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: !status,
          child: PayStatusWidget(
            forbiddenValue: widget.forbiddenValue,
            initialValue: selectedValue,
            changeStatusCallback: switchStatus,
            chooseStatusCallback: (map) {
              setState(() {
                selectedPayStatusMap = map;
                selectedValue = selectedPayStatusMap['value'];
                switchStatus();
              });
            },
          ),
        )
      ],
    );
  }

  // 切换界面
  void switchStatus() {
    setState(() {
      status = !status;
    });
  }

  // 输入回调
  void submit(v) {
    print('密码:$v 类型：${selectedPayStatusMap['value']}');
    setState(() {
      vertifyCode = v;
    });
    if (widget.type == 0) {
      requestPay(v);
    } else {
      requestConfirmGoods(v);
    }
  }

  void changeVerfityCode(v) {
    setState(() {
      vertifyCode = v;
    });
  }

  // 发送支付请求
  void requestPay(v) {
    print('请求支付====');
    HttpServices.payMoneys(
      orderId: orderId,
      payPassword: v.toString(),
      moneyType: selectedPayStatusMap['value'].toString(),
      success: (res) {
        print('success $res');
        widget.callBack(widget?.id);
      },
      error: (error) {
        Navigator.of(context).pop();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  // 发送确认收货请求
  void requestConfirmGoods(v) {
    print('请求确认收货====');
    HttpServices.postOrderReceived(
      orderId: orderId,
      success: (res) {
        print('success $res');
        widget.callBack(widget?.id);
      },
      error: (error) {
        Navigator.of(context).pop();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }
}
