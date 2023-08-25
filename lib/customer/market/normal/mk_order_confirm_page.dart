import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/common/baseWidgets/wms_size_tag_widget.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/identify/wv_recipient_info.dart';
import 'package:wms/common/baseWidgets/wv_payStatus_widget.dart';
import 'package:wms/customer/market/controllers/market_all_commodity_page_controller.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/views/common/order_info_widget.dart';

// 集市订单确认页面
class MKOrderConfirmPage extends StatefulWidget {
  @override
  _MKOrderConfirmPageState createState() => _MKOrderConfirmPageState();
}

class _MKOrderConfirmPageState extends State<MKOrderConfirmPage> {
  final MarketAllCommodityPageController pageController = Get.find<MarketAllCommodityPageController>();

  num orderCode;
  num orderSum;

  @override
  void initState() {
    // pageController.getEtk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // MKOrderConfirmPageController pageController = Get.put(MKOrderConfirmPageController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '订单确认',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Obx(
        () => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            child: ScrollConfiguration(
              behavior: JKOverScrollBehavior(),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        // Visibility(
                        //   // 是跨境 并且 数量大于ETK数量
                        //   visible:
                        //       (pageController.isCrossBorder.value == true) &&
                        //           (pageController.count.value >
                        //               pageController.etk.value),
                        //   child: Container(
                        //     color: Colors.black87,
                        //     alignment: Alignment.center,
                        //     height: 44.h,
                        //     child: RichText(
                        //       text: TextSpan(
                        //         style: TextStyle(color: Colors.white),
                        //         children: [
                        //           TextSpan(
                        //             text: '根据海关要求，该品类单个包裹内物品总数仅限 ',
                        //             style: TextStyle(fontSize: 12.sp),
                        //           ),
                        //           TextSpan(
                        //             text: '${pageController.etk.value}',
                        //             style: TextStyle(
                        //                 fontSize: 17.sp,
                        //                 color: Colors.redAccent),
                        //           ),
                        //           TextSpan(
                        //             text: ' 件',
                        //             style: TextStyle(fontSize: 12.sp),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        RecipientInfoWidget(
                          addressInfo: pageController.consigneeData,
                          callBack: (AddressModel v) {
                            pageController.setConsignee(v, context);
                          },
                        ),
                        // Visibility(
                        //   visible: pageController.isCrossBorder.value ?? false,
                        //   child: IdnetifyCellWidget(
                        //       model: pageController.consigneeData,
                        //       callback: () async {
                        //         await showDialog(
                        //             context: context,
                        //             builder: (BuildContext ctx) => wvDialog(
                        //                 //构建弹框中的内容
                        //                 widget: CSCrossBorderVertifyPage()));
                        //       }),
                        // ),
                        Column(
                          children: [
                            buildCommodityInformation(),
                            // child: Text("goodx"),
                          ],
                        ),
                        buildRowOrderInfo(title: '订单编号', content: '${null ?? ''}'),
                        buildRowOrderInfo(
                            title: '配送方式', content: '${pageController.isCrossBorder.value == false ? "境内快递" : "跨境顺丰"}'),
                        // buildPayModel(),
                        buildRowOrderSmallInfo('商品金额', '¥${pageController.goodsTotalFee.value ?? 0.0}'),
                        buildRowOrderSmallInfo(
                            '运费',
                            pageController.goodsTotalFee.value >= 5000
                                ? "已包含"
                                : '¥${pageController.freightFee.value ?? 0.0}'),
                        buildRowOrderSmallInfo(
                            '税费',
                            pageController.goodsTotalFee.value >= 5000
                                ? "已包含"
                                : '¥${pageController.taxFee.value ?? 0.0}'),
                        buildRowOrderNote(controller: pageController.notesController, title: '订单备注'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20, left: 16.w, right: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
                        /*PopupMenuButton<String>(
                              itemBuilder: (context) {
                                return <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: '联系卖家',
                                    child: Text('联系卖家'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: '取消订单',
                                    child: Text('取消订单'),
                                  ),
                                ];
                              },
                            ),*/
                        Row(
                          children: [
                            WMSText(
                              content: '共${pageController.count.value ?? 0}件',
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8.w),
                            WMSText(
                              content: '订单总计：',
                              bold: true,
                            ),
                            WMSText(
                              content: '¥${pageController.totalFee.value ?? 0.0}',
                              color: Colors.red,
                              size: 17,
                              bold: true,
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(90.w, 34.w)),
                            fixedSize: MaterialStateProperty.all(Size(90.w, 34.w)),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => pageController.consigneeData == null ? null : AppStyleConfig.btnColor),
                          ),
                          onPressed: pageController.consigneeData == null
                              ? null
                              : () {
                                  FocusScope.of(context).requestFocus(FocusNode());

                                  // if (WMSUser.getInstance()
                                  //         .userInfoModel
                                  //         .payPassword ==
                                  //     null) {
                                  //   Get.to(() => CSSetPayPwdPage());
                                  // } else {
                                  if (orderCode == null) {
                                    // pageController.businessOrderAdd(context,
                                    //     (code, sum) {
                                    //   this.orderCode = code;
                                    //   this.orderSum = sum;
                                    // });
                                    pageController.csMarketOrderAdd(context);
                                  } else {
                                    pageController.openPayDialog(context, orderCode, orderSum);
                                  }
                                  // }
                                },
                          child: Text(
                            '支付',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCommodityInformation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: .5,
            color: Colors.grey[100],
          ),
        ),
      ),
      margin: EdgeInsets.only(top: 8.h),
      child: ListView.builder(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
                child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.network(
                    pageController.model?.picturePath ?? '-',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        pageController.model?.commodityName ?? '-',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                      WMSText(
                        content: '货号：${pageController.model?.spuId ?? '-'}',
                        color: Colors.grey,
                        size: 12,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Wrap(
                        children: [
                          WMSSizeTagWidget(
                            title:
                                "${pageController.skuConfirmOrderList[index]['size'] ?? '无尺码'}${pageController.skuConfirmOrderList[index]['size'] != null ? '/' + pageController.skuConfirmOrderList[index]['size'] : ''}",
                          ),
                          SizedBox(width: 5.w),
                          Visibility(
                            visible: pageController.model?.color != null,
                            child: WMSSizeTagWidget(
                              title: pageController.model?.color ?? '-',
                            ),
                          ),
                          SizedBox(width: 5.w),
                          WMSSizeTagWidget(
                            title: pageController.model.brandNameCn ?? "-",
                          ),
                          Visibility(
                            visible: !((pageController.isCrossBorder.value == true) &&
                                pageController.count.value > pageController.etk.value),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Text(
                                'x${pageController.skuConfirmOrderList[index]['count'] ?? '-'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Visibility(
                        visible: (pageController.isCrossBorder.value == true) &&
                            pageController.count.value > pageController.etk.value,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print(pageController.skuConfirmOrderList[index]['count']);
                                pageController.onTapSubtractionHandle(
                                    context,
                                    index,
                                    pageController.skuConfirmOrderList[index]['count'].value,
                                    pageController.skuConfirmOrderList);
                                setState(() {});
                              },
                              child: Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                width: 30.w,
                                height: 24.w,
                                child: WMSText(content: '-'),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              width: 30.w,
                              height: 24.w,
                              child: Obx(
                                () => WMSText(
                                  content: pageController.skuConfirmOrderList[index]['count'].value.toString(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                pageController.onTapAddHandle(
                                    context,
                                    index,
                                    pageController.skuConfirmOrderList[index]['count'].value,
                                    pageController.skuConfirmOrderList);
                              },
                              child: Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                width: 30.w,
                                height: 24.w,
                                child: WMSText(content: '+'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
          },
          itemCount: pageController.skuConfirmOrderList.length),
    );
  }
}
