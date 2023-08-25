import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:common_utils/common_utils.dart';

import 'package:wms/utils/orders_config.dart';
import 'package:wms/customer/orders/cs_order_detail_page.dart';
import 'package:wms/models/order/order_model.dart';
import 'package:wms/views/customer/order_commodity_cell.dart';

import '../../customer/orders/controllers/cs_order_nav_bar_controller.dart';
// import 'controllers/order_cell_controller.dart';
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';

class OrderCellWidget extends StatefulWidget {
  OrderCellWidget(
      {Key key, this.state, this.type, this.dataModel, this.callBack})
      : super(key: key);
  final String state;
  final int type;
  final OrderModel dataModel; //订单基本数据模型
  final Function callBack; // 返回刷新数据

  @override
  _OrderCellWidgetState createState() => _OrderCellWidgetState();
}

class _OrderCellWidgetState extends State<OrderCellWidget> {
  // OrderCellController pageController;
  CSOrderNavBarController navController = Get.find<CSOrderNavBarController>();

  // 控制器
  TimerUtil mCountDownTimerUtil;

  // 使用变量
  int countdownInt = 0;
  String countdownStr = '-';
  bool selected = false;
  void timer() {
    countdown(widget.dataModel?.createTime, (str, int) {
      setState(() {
        countdownStr = str;
        countdownInt = int;
      });
    });
  }

  void countdown(String time, Function callBack) {
    if (time == null) return;
    if (mCountDownTimerUtil != null) {
      //取消计时器
      mCountDownTimerUtil.cancel();
    }
    int now = DateUtil.getNowDateMs() ~/ 1000 * 1000;
    int createTime = DateTime.parse(time).millisecondsSinceEpoch;
    // 订单结束时长
    int _m = 15 * 60 * 1000;
    // 下单时间 + 15分钟
    int _m2 = createTime + _m;
    // 下单15分后 - 当前时间
    int _m3 = _m2 - now;
    mCountDownTimerUtil = new TimerUtil(mInterval: 1000, mTotalTime: _m3);
    mCountDownTimerUtil.setOnTimerTickCallback((int tick) {
      // print('tick $tick');
      String H = '00';
      String M = (tick ~/ 60 ~/ 1000).toInt().toString().padLeft(2, '0');
      String S = (tick / 1000 % 60).toInt().toString().padLeft(2, '0');
      callBack('$H:$M:$S', tick);
      // countdownStr.value = '$H:$M:$S';
      // countdownInt.value = tick;
    });
    mCountDownTimerUtil.startCountDown();
  }

  @override
  void initState() {
    timer();
    super.initState();
  }

  @override
  void dispose() {
    if (mCountDownTimerUtil != null) {
      mCountDownTimerUtil.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // pageController = Get.put(OrderCellController(widget.dataModel));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.white,
      margin: EdgeInsets.only(top: 8.h),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (widget.dataModel.virtualCommodity == true) {
            showDialog(
                context: context,
                builder: (BuildContext ctx) => wvDialog(
                    widget: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 24.w),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      '此商品为虚拟商品',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Icon(Icons.cancel))),
                                ],
                              ),
                            ]))));
          } else {
            Get.to(() => CSOrderDetailPage(
                  id: widget.dataModel.orderId,
                  navStatus: widget.type,
                )).then((value) {
              if (widget.callBack != null) {
                widget.callBack();
              }
            });
          }
        },
        child: Obx(
          () => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WMSText(
                    content: widget.dataModel?.createTime ?? '',
                    size: 12,
                    bold: true,
                  ),
                  WMSText(
                    content:
                        OrderConfig.orderState(widget.dataModel?.orderStatus),
                    size: 12,
                    bold: true,
                  ),
                ],
              ),
              // SizedBox(
              //   height: 8.h,
              // ),

              Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: buildList(widget.dataModel?.detailsList),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // WMSText(
                  //   content: '${widget.dataModel?.depotName ?? '仓库名称'}',
                  //   size: 12,
                  //   color: Colors.grey,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      WMSText(
                        content: '订单总计：',
                        size: 12,
                        color: Colors.grey,
                      ),
                      WMSText(
                        content:
                            '¥${widget.dataModel.orderSum ?? widget.dataModel.detailsList.fold(0, (previousValue, element) => previousValue + element.subTotal) ?? '0'}',
                        size: 18,
                        bold: true,
                      ),
                    ],
                  ),
                ],
              ),
              Visibility(
                visible:
                    navController.model.value == 1 && widget.state == "TO_PAY",
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WMSText(
                        content: '剩余付款时间 $countdownStr',
                        size: 10,
                        color: Colors.red,
                      ),
                      Row(
                        children: [
                          buildButtonWidget(buttonContent: '取消订单'),
                          SizedBox(
                            width: 16.w,
                          ),
                          buildButtonWidget(
                              buttonContent: '去支付',
                              contentColor: Colors.white,
                              bgColor: AppConfig.themeColor),
                          // buildPayBtn(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Visibility(

                  //设置出售订单0待发货,且发货仓库为自主仓时出现手动配发按钮；
                  visible: widget.state == "TO_DELIVERY" &&
                      navController.model.value == 0 &&
                      (widget.dataModel.depotId == -1 ||
                          widget.dataModel.depotId == -2),
                  // visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [buildButtonWidget(buttonContent: '手动配发')],
                    ),
                  )),

              //设置已发货时出现物流轨迹按钮；如果订单商品列表中虚拟商品，则不显示

              Visibility(
                visible: (widget.state == "TO_RECEIVE") &&
                    widget.dataModel.detailsList.every(
                        (element) => !element.productName.contains('虚拟商品')),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildButtonWidget(
                        buttonContent: '订单详情',
                        // handelClick:(){
                        //           Get.to(() => ENLogisticsPage(
                        // dataCode: widget.dataModel.logisticsNum,
                        // ));
                        //           }
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      // Visibility(
                      //   visible: navController.model.value == 1,
                      //   child: buildButtonWidget(
                      //       buttonContent: '确认收货',
                      //       contentColor: Colors.white,
                      //       bgColor: AppConfig.themeColor),
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//设置订单商品列表
  Widget buildList(goodList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // return CSDkdGoodCell(
        //   model: goodList[index],
        // );
        return OrderCommoditycell(
          model: goodList[index],
        );
      },
      itemCount: goodList.length ?? 0,
    );
  }
}
