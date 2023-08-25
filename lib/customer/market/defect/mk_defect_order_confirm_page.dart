import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/common/baseWidgets/wms_size_tag_widget.dart';
import 'package:wms/common/identify/wv_recipient_info.dart';
import 'package:wms/customer/market/controllers/market_defect_commodity_page_controller.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/views/common/order_info_widget.dart';
import 'package:wms/common/baseWidgets/wv_payStatus_widget.dart';

// 集市订单确认页面
class MKDefectOrderConfirmPage extends StatefulWidget {
  @override
  _MKDefectOrderConfirmPageState createState() => _MKDefectOrderConfirmPageState();
}

class _MKDefectOrderConfirmPageState extends State<MKDefectOrderConfirmPage> {
  final MarketDefectCommodityPageController pageController = Get.find<MarketDefectCommodityPageController>();

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
                        //           // WidgetSpan(
                        //           //   child: ConstrainedBox(
                        //           //     constraints: BoxConstraints(maxWidth: 180.w),
                        //           //     child: Text(
                        //           //       '${pageController.dataModel.value?.commodityName ?? '-'}',
                        //           //       overflow: TextOverflow.ellipsis,
                        //           //       maxLines: 1,
                        //           //       style: TextStyle(color: Colors.white),
                        //           //     ),
                        //           //   ),
                        //           // ),
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
                        //   visible: pageController.isCrossBorder.value,
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
                        buildRowOrderInfo(
                            title: '瑕疵类别',
                            content:
                                '${WMSUtil.getExceptionTypeString(pageController.selectDataDefectSource.value.defectDegree)}'),
                        buildRowOrderInfo(
                          title: '商品照片',
                          content: '',
                          endWidget: Container(
                            child: GestureDetector(
                              child: SizedBox(
                                height: 48.0,
                                width: 48.0,
                                child: Image.network(
                                  pageController.selectDataDefectSource.value.picturePath,
                                  height: 48.0,
                                  width: 48.0,
                                ),
                              ),
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                print('图片1');
                                Get.to(() => PhotoViewPage(
                                      images:
                                          pageController.selectDataDefectSource.value.picturePath.split(';'), //传入图片list
                                      index: 0, //传入当前点击的图片的index
                                    ));
                              },
                            ),
                            // child: WMSImageWrap(
                            //   imagePaths: WMSUtil.segmentationImageUrl(
                            //     pageController
                            //         .selectDataDefectSource.value.picturePath,
                            //   ),
                            // ),
                          ),
                        ),
                        buildRowOrderInfo(title: '订单编号', content: '${null ?? ''}'),
                        buildRowOrderInfo(
                            title: '配送方式', content: '${pageController.isCrossBorder.value == false ? "境内快递" : "跨境顺丰"}'),
                        // buildPayModel(),
                        Obx(() => buildRowOrderSmallInfo('商品金额', '¥${pageController.goodsTotalFee.value ?? 0.0}')),
                        buildRowOrderSmallInfo(
                            '运费',
                            pageController.goodsTotalFee.value >= 5000
                                ? "已包含"
                                : '¥${pageController.freightFee.value ?? 0.0}'),
                        buildRowOrderSmallInfo('税费',
                            pageController.goodsTotalFee.value >= 5000 ? "已包含" : '¥${pageController.taxFee ?? 0.0}'),
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
                            Obx(
                              () => WMSText(
                                content: '¥${pageController.totalFee.value ?? 0.0}',
                                color: Colors.red,
                                size: 17,
                                bold: true,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          // style: TextButton.styleFrom(
                          //   minimumSize: Size(90.w, 34.w),
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(30.0)),
                          //   ),
                          // ),
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
                                    pageController.businessOrderAdd(context, (code, sum) {
                                      this.orderCode = code;
                                      this.orderSum = sum;
                                    });
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                WMSSizeTagWidget(
                                  title: pageController.skuIdData?.value?.size ?? '-',
                                ),
                                SizedBox(width: 5.w),
                                Visibility(
                                  visible: pageController.model?.color != null,
                                  child: WMSSizeTagWidget(
                                    title:
                                        // pageController.dataModel?.value?.color ?? '-',
                                        '',
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                WMSSizeTagWidget(
                                  title: pageController.model.brandNameCn ?? '-',
                                ),
                              ],
                            ),
                            Visibility(
                              visible: !((pageController.isCrossBorder.value == true) &&
                                  pageController.count.value > pageController.etk.value),
                              child: Text(
                                'x${pageController.skuOrderList[index]['count'] ?? '-'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                  pageController.onTapSubtractionHandle(
                                      context, index, pageController.skuOrderList[index]['count'].value);
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
                                    content: pageController.skuOrderList[index]['count'].value.toString(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  pageController.onTapAddHandle(
                                      context, index, pageController.skuOrderList[index]['count'].value);
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
              ),
            );
          },
          itemCount: pageController.skuOrderList.length),
    );
  }

  Widget buildPayModel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: .5,
            color: Colors.grey[100],
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WMSText(
            content: '支付方式',
            size: 13,
            bold: true,
          ),
          GestureDetector(
            onTap: () {
              print("xxsss");
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) => wvDialog(
                          //构建弹框中的内容
                          widget: PayStatusWidget(
                        initialValue: pageController.payModel['value'],
                        forbiddenValue: pageController.isCrossBorder.value ? [4] : [],
                        changeStatusCallback: () {
                          Navigator.of(ctx, rootNavigator: false).pop();
                        },
                        chooseStatusCallback: (map) {
                          pageController.payModel = map;
                          print(pageController.payModel);
                          // Navigator.of(ctx, rootNavigator: false).pop();
                          setState(() {
                            // pageController.onTapPayModel(map);
                            Navigator.of(ctx, rootNavigator: false).pop();
                          });
                        },
                      )));

              setState(() {
                pageController.onTapPayModel(pageController.payModel);
              });
            },
            child: Container(
                child: Row(
              children: [
                if (pageController.payModel['icon'] != null)
                  SvgPicture.asset(
                    pageController.payModel['icon'],
                    width: 18,
                  ),
                SizedBox(width: 8.w),
                WMSText(
                  content: pageController.payModel['lable'],
                  size: 13,
                  bold: true,
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}
