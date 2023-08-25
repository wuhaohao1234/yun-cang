import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/customer/market/controllers/market_defect_commodity_page_controller.dart';

class MKPlaceDefectOrderPage extends StatefulWidget {
  // final MarketAllDetailModel dataModel;
  // final ChuHuoShipmentModel dataSource;
  //
  // /// 1:下单 2:购物车
  // final int state;
  //
  // MKPlaceOrderPage({this.dataModel, this.dataSource, this.state});

  @override
  _MKPlaceDefectOrderPageState createState() => _MKPlaceDefectOrderPageState();
}

class _MKPlaceDefectOrderPageState extends State<MKPlaceDefectOrderPage> {
  // MKPlaceOrderPageController pageController;

  MarketDefectCommodityPageController pageController =
      Get.find<MarketDefectCommodityPageController>();

  @override
  void initState() {
    // pageController = Get.put(MKPlaceOrderPageController());
    // pageController.getEtk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 49.0,
                    alignment: Alignment.center,
                    // child: Text('选择下架商品'),
                  ),
                  Positioned(
                    child: CloseButton(),
                    right: 0,
                    top: 0,
                  )
                ],
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.network(
                        pageController.model?.picturePath ?? '',
                        fit: BoxFit.fitWidth,
                        height: 50.h,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            pageController.model?.commodityName ?? '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            pageController.model.stockCode ?? '-',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WMSText(
                      content: '送货时效：',
                      size: 12,
                      bold: true,
                    ),
                    WMSText(
                      content:
                          '${pageController.selectDataDefectSource?.value?.depotName ?? ''} ${WMSUtil.expirationStringChange(pageController.selectDataDefectSource?.value?.expiration)}',
                      size: 12,
                      bold: true,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WMSText(
                      content: '选择尺码',
                      size: 14,
                      bold: true,
                    ),
                  ],
                ),
              ),
              buildCommoditySizeList(
                  [pageController.selectDataDefectSource?.value], false, ''),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() => Checkbox(
                        value: pageController.checkedNotice.value,
                        activeColor: Colors.black87,
                        onChanged: (bool e) {
                          pageController.setNoticeValue(e);
                          // update();
                        })),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                        text: "勾选表示您已阅读并同意 ",
                        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                      ),
                      TextSpan(
                        text: "跨境消费者告知书",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = pageController.onTapNoticeBtnHandle,
                      ),
                    ])),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(343.w, 34.w)),
                  backgroundColor: MaterialStateProperty.resolveWith((states) =>
                      pageController.skuOrderList?.fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue +
                                          element['count'].value) ==
                                  0 ||
                              pageController.checkedNotice.value == false
                          ? null
                          : AppStyleConfig.btnColor),
                ),
                // style: TextButton.styleFrom(
                //   minimumSize: Size(90.w, 34.h),
                //   fixedSize: Size(343.w, 34.h),
                //   // shape: RoundedRectangleBorder(
                //   //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
                //   // ),
                // ),
                // style: ButtonStyle(
                //     foregroundColor: AppStyleConfig.btnColor),
                onPressed: pageController.skuOrderList?.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element['count'].value) ==
                            0 ||
                        pageController.checkedNotice.value == false
                    ? null
                    : () {
                        pageController.onTapCommitOrder();
                      },

                child: Text('确定'),
              ),
            ],
          );
        }),
      ),
    );
  }

  //创建搜索商品的尺寸列表
  Widget buildCommoditySizeList(skuSizeList, itemCheckValue, stockCode) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // return CommodityChooseSizeWidget(
          //     size: skuSizeList[index]['size'],
          //     onChangeCallback: (value) {
          //       print(value);
          //       setState(() {
          //         //设置尺寸值
          //         skuSizeList[index]['commodityNumber'] = value;
          //       });
          //     });
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    WMSText(
                      content: '${skuSizeList[index].size ?? '无尺码'}',
                      size: 12,
                      bold: true,
                    ),
                    WMSText(
                      content: '1件',
                      size: 12,
                      bold: true,
                      color: Colors.grey,
                    ),
                  ],
                ),
                Row(
                  children: [
                    WMSText(
                      content: '¥${skuSizeList[index].price.toString() ?? '-'}',
                      size: 12,
                      bold: true,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 16.w),
                    GestureDetector(
                      onTap: () {
                        pageController.onTapSubtractionHandle(context, index,
                            pageController.skuOrderList[index]['count'].value);
                      },
                      child: Container(
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        width: 30.w,
                        height: 24.w,
                        child: WMSText(
                          content: '-',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Container(
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      width: 30.w,
                      height: 24.w,
                      child: Obx(
                        () => WMSText(
                          content: pageController
                              .skuOrderList[index]['count'].value
                              .toString(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.onTapAddHandle(context, index,
                            pageController.skuOrderList[index]['count'].value);
                      },
                      child: Container(
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        width: 30.w,
                        height: 24.w,
                        child: WMSText(
                          content: '+',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
        itemCount: skuSizeList.length ?? 0,
      ),
    );
  }
}
