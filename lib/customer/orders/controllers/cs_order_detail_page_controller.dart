import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合

import 'package:wms/common/basePage/wv_success.dart';
import 'package:wms/common/baseWidgets/wv_pay_dialog_widget.dart';
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';
import 'package:wms/configs/wv_tool.dart';
import 'package:wms/entrepot/pages/chuku/chuku_chenggong.dart';
import 'package:wms/models/order/order_model.dart';
import 'package:wms/models/order/order_detail_model.dart';
import '../wv_order_success.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../cs_order_detail_page.dart';
import 'package:wms/customer/main/cs_main_page.dart';

class CSOrderDetailController extends GetxController {
  int pageSize = 10;
  Rx<OrderDetailModel> data = OrderDetailModel().obs;
  var dataInfo = {};

  // 使用变量
  RxInt countdownInt = 0.obs;
  RxString countdownStr = '-'.obs;
  RxInt id = 0.obs;
  var dataSource = OrderModel().obs;
  Timer _timer;

  //Wiget生成时判断订单超时状态；
  @override
  void onReady() {
    // loadData();
    super.onReady();
  }

  void openPayDialog(BuildContext context, OrderDetailModel data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => wvDialog(
        widget: PayDialogWidget(
          // data: data,
          id: data.id,
          orderSum: data.orderSum,
          callBack: (int _id) {
            Get.to(() => OrderSuccessPage(id: data.id));
          },
        ),
      ),
    );
  }

  void refresh() {
    //设置刷新倒计时，6秒一次，刷新5分钟；
    WvTool.orderCountdown((int) {
      // print(int);
      loadData(firstLoad: false);
    });
    // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   print('检查更新=====');
    //   loadData(firstLoad: false);
    //   _timer?.cancel();
    // });
  }

  /// 手动配发
  void outStoreOrder(map) {
    print(map);
    int _ids = id.value;

    print('配发IDS $_ids');
    HttpServices.outOrderExpress(
      params: map,
      success: (data) {
        EasyLoadingUtil.hidden();
        // 刷新数据
        // Get.to(() => SuccessPage(
        //       title: '订单配发成功',
        //       content: Text(
        //         '（待仓库操作出库）',
        //         style: TextStyle(fontSize: 14.0, color: Color(0xff00CCCC)),
        //       ),
        //       button: OutlinedButton(
        //         onPressed: () {
        //           // Get.to(() => CSOrderDetailPage(id: _ids),
        //           //     preventDuplicates: true);
        //           Get.offAll(() => CSMainPage(defaultIndex: 1));
        //         },
        //         child: Text(
        //           '订单列表',
        //           style: TextStyle(fontWeight: FontWeight.bold),
        //         ),
        //       ),
        //     ));
        Get.to(() => ChuKuChengGong(expressNumber: map["logisticsNum"])).then(
            (value) => Get.offAll(() => CSMainPage(
                defaultIndex: WMSUser.getInstance().depotPower ? 1 : 0)));
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  // 确认收货
  void openConfirmGoodsDialog(
    BuildContext context,
  ) {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) => wvDialog(
    //     widget: PayDialogWidget(
    //       type: 1,
    //       id: id.value,
    //       orderSum: data.value.orderSum,
    //       callBack: (int _id) {
    //         Get.back();
    //       },
    //     ),
    //   ),
    // );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => wvDialog(
        widget: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '是否确认收货',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WMSButton(
                    title: '取消',
                    width: 120.w,
                    bgColor: Colors.transparent,
                    textColor: Colors.black,
                    showBorder: true,
                    callback: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  WMSButton(
                    title: '确认收货',
                    width: 120.w,
                    bgColor: AppConfig.themeColor,
                    textColor: Colors.white,
                    showBorder: true,
                    callback: () async {
                      HttpServices.postOrderReceived(
                        orderId: id.value,
                        success: (res) {
                          print('success $res');
                          Get.to(() => SuccessPage(
                                title: '订单收货成功',
                                content: Text(
                                  '（用户已确认收货）',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Color(0xff00CCCC)),
                                ),
                                button: OutlinedButton(
                                  onPressed: () {
                                    // Get.to(() => CSOrderDetailPage(id: _ids),
                                    //     preventDuplicates: true);
                                    Get.offAll(() => CSMainPage(
                                        defaultIndex:
                                            WMSUser.getInstance().depotPower
                                                ? 1
                                                : 0));
                                  },
                                  child: Text(
                                    '订单列表',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ));
                        },
                        error: (error) {
                          Navigator.of(context).pop();
                          ToastUtil.showMessage(message: error.message);
                        },
                      );
                      Navigator.of(context).pop(true);
                      loadData();

                      // pageController.onTapCommitHandle();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData({firstLoad = true}) {
    if (firstLoad) {
      EasyLoadingUtil.showLoading();
    }
    HttpServices.businessOrder(
      query: "${id.value}",
      success: (res) {
        EasyLoadingUtil.hidden();
        data.value = res;

        WvTool.countdown(data?.value?.createTime, (str, int) {
          countdownStr.value = str;
          countdownInt.value = int;
        });
        if (firstLoad) {
          ToastUtil.showMessage(message: '下拉可进行页面刷新');
        }
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
    return null;
  }

  // 取消订单
  void cancelOrder(OrderDetailModel _data) {
    _data.orderStatus = 6;
    data.value = _data;
    EasyLoadingUtil.showLoading();
    HttpServices.businessOrde(
      params: {"id": _data.id, "orderStatus": 6},
      success: () {
        EasyLoadingUtil.hidden();
        loadData();
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    if (WvTool.mCountDownTimerUtil != null) {
      WvTool.mCountDownTimerUtil.cancel();
    }
    if (WvTool.orderCountDownTimerUtil != null) {
      WvTool.orderCountDownTimerUtil.cancel();
    }
  }
}
