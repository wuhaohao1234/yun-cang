import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/entrepot/pages/en_logistics_page.dart';
import 'package:wms/customer/orders/controllers/cs_order_nav_bar_controller.dart';
import 'package:wms/views/customer/order_commodity_cell.dart';
import 'package:wms/views/common/order_info_widget.dart';
import 'controllers/cs_order_detail_page_controller.dart';
import 'package:wms/utils/orders_config.dart';
import 'order_ship_page.dart';
import 'package:wms/customer/main/cs_main_page.dart';
import 'package:flutter/services.dart';

class CSOrderDetailPage extends StatefulWidget {
  // final OrderDetailModel data;
  // final data;
  final int id;
  final int navStatus;

  CSOrderDetailPage({this.id, this.navStatus});

  @override
  _CSOrderDetailPageState createState() => _CSOrderDetailPageState();
}

class _CSOrderDetailPageState extends State<CSOrderDetailPage> {
  CSOrderDetailController pageController = Get.put(CSOrderDetailController());
  CSOrderNavBarController navController = Get.find<CSOrderNavBarController>();

  @override
  void initState() {
    pageController.id.value = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageController.loadData();
    print(widget.navStatus);
    EasyLoadingUtil.showMessage(message: '下拉可进行页面刷新');
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          leading: BackButton(
            onPressed: () {
              Get.offAll(() => CSMainPage(defaultIndex: WMSUser.getInstance().depotPower?1:0));
            },
          ),
          title: Obx(() {
            return WMSText(
              content:
                  '订单详情 (${OrderConfig.orderState(pageController.data.value?.orderStatus)})',
              size: AppStyleConfig.navTitleSize,
            );
          }),
        ),
        body: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Container(child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: pageController.data?.value?.orderStatus == 1,
                  // visible: pageController.dataInfo['orderStatus'] == 1,

                  child: Container(
                    // color: Color(0xff00cccc),
                    color: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WMSText(
                          content: '订单待支付',
                          color: Colors.white,
                          bold: true,
                          size: 12.sp,
                        ),
                        WMSText(
                          content:
                              '剩余付款时间: ${pageController.countdownStr.value}',
                          color: Colors.white,
                          bold: true,
                          size: 10.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshView(
                    onRefresh: () => pageController.loadData(firstLoad: false),
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10.w),
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.w, horizontal: 15.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_rounded,
                                  color: Colors.red, size: 30),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        WMSText(
                                          content:
                                              '${pageController.data.value?.userName}',
                                          bold: true,
                                        ),
                                        SizedBox(width: 6.w),
                                        WMSText(
                                          content:
                                              '${pageController.data.value?.userPhone}',
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: WMSText(
                                        content:
                                            '${pageController.data.value?.province} ${pageController.data.value?.city}${pageController.data.value?.area}${pageController.data.value?.address}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                        text:
                                            '${pageController.data.value?.userName} ${pageController.data.value?.userPhone} ${pageController.data.value?.province} ${pageController.data.value?.city}${pageController.data.value?.area}${pageController.data.value?.address}'),
                                  ).then((value) {
                                    ToastUtil.showMessage(message: '复制成功');
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.h),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.h, color: Colors.black),
                                  ),
                                  child: WMSText(
                                    content: '复制',
                                    color: Colors.black,
                                    size: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (pageController
                                    .data?.value?.wmsUserOrderDetailsList !=
                                null &&
                            pageController.data?.value?.wmsUserOrderDetailsList
                                    ?.length >
                                0)
                          Column(
                            children: [
                              Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(top: 10.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 10.w),
                                child: buildList(pageController
                                    .data?.value?.wmsUserOrderDetailsList),
                              )
                            ],
                          )
                        else
                          Container(
                            child: Text('无商品'),
                          ),
                        SizedBox(height: 10.h),
                        buildRowOrderInfo(
                          title: '订单编号',
                          content: '${pageController.data?.value?.orderCode}',
                        ),
                        buildRowOrderInfo(
                          title: '仓库',
                          content: '${pageController.data?.value?.depotName}',
                        ),
                        buildRowOrderInfo(
                            title: '配送方式',
                            content:
                                '${pageController.data?.value?.logisticsName}'),
                        buildRowOrderInfo(
                            title: '快递单号',
                            content:
                                '${pageController.data?.value?.logisticsNum}'),
                        buildRowOrderInfo(
                          title: '商品费用',
                          content: '¥ ${pageController.data?.value?.sellPrice}',
                        ),
                        buildRowOrderInfo(
                          title: '税费',
                          content: '¥ ${pageController.data?.value?.tariff}',
                        ),
                        buildRowOrderInfo(
                          title: '运费',
                          content: '¥ ${pageController.data?.value?.postFee}',
                        ),
                        buildRowOrderInfo(
                          title: '订单备注',
                          content: '${pageController.data?.value?.notes ?? ''}',
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 10.w,
                    right: 15.w,
                    bottom: MediaQuery.of(context).padding.bottom + 15.w,
                    left: 15.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                          children: [
                            TextSpan(
                                text: '订单总计: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '¥${pageController.data.value?.orderSum}',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Visibility(
                              visible: (pageController
                                              .data.value?.orderStatus ==
                                          2 ||
                                      pageController.data.value?.orderStatus ==
                                          3) &&
                                  navController.model.value == 0 &&
                                  (pageController.data.value.depotName
                                      .contains('自')),
                              child: buildButtonWidget(
                                  buttonContent:
                                      pageController.data.value?.orderStatus ==
                                              2
                                          ? '手动配发'
                                          : '修改物流',
                                  contentColor: Colors.white,
                                  bgColor: AppConfig.themeColor,
                                  height: 34.0,
                                  handelClick: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) => wvDialog(
                                            widget: CSOrderShipPage(
                                                orderId: widget.id,
                                                orderShipCallback:
                                                    pageController
                                                        .outStoreOrder)));
                                  })),
                          SizedBox(width: 10.w),
                          Visibility(
                              visible: (pageController.data.value?.orderType ==
                                          0 ||
                                      pageController.data.value?.orderType ==
                                          2) &&
                                  (pageController.data.value?.orderStatus ==
                                          3040 ||
                                      pageController.data.value?.orderStatus ==
                                          3 ||
                                      pageController.data.value?.orderStatus ==
                                          5),
                              child: buildButtonWidget(
                                  buttonContent: '物流轨迹',
                                  height: 34.0,
                                  handelClick: () {
                                    Get.to(() => ENLogisticsPage(
                                        dataCode: pageController
                                            .data.value?.logisticsNum));
                                  })),
                          SizedBox(width: 10.w),
                          Visibility(
                              visible: (pageController.data.value?.orderType ==
                                          0 ||
                                      pageController.data.value?.orderType ==
                                          2) &&
                                  pageController.data.value?.orderStatus == 3 &&
                                  widget.navStatus == 1,
                              child: buildButtonWidget(
                                  buttonContent: '确认收货',
                                  contentColor: Colors.white,
                                  bgColor: AppConfig.themeColor,
                                  height: 34.0,
                                  handelClick: () {
                                    pageController.openConfirmGoodsDialog(
                                      // context, widget.data);
                                      context,
                                    );
                                    pageController.refresh();
                                  })),
                          Visibility(
                            //订单购买1,
                            visible:
                                pageController.data.value?.orderStatus == 1 &&
                                    navController.model.value == 1,
                            child: buildButtonWidget(
                                buttonContent: '取消订单',
                                height: 34.0,
                                handelClick: () {
                                  pageController
                                      .cancelOrder(pageController.data.value);
                                }),
                          ),
                          SizedBox(width: 10.w),
                          Visibility(
                            //订单购买1,
                            visible:
                                pageController.data.value?.orderStatus == 1 &&
                                    pageController.data.value?.payStatus != 1 &&
                                    navController.model.value == 1,
                            // visible: true,
                            child: buildButtonWidget(
                                buttonContent: '去支付',
                                contentColor: Colors.white,
                                bgColor: AppConfig.themeColor,
                                height: 34.0,
                                handelClick: () {
                                  pageController.openPayDialog(
                                      context, pageController.data.value);
                                  pageController.refresh();

                                  // Get.to(()=>() => OrderSuccessPage(id: data?.id));
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          })),
        ));
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
