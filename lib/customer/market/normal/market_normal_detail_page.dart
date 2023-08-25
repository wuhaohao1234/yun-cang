import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/models/market/chu_huo_shipment_normal_model.dart';
import 'package:wms/models/market/market_all_detail_model.dart';
import 'package:wms/views/customer/market/mk_detail_top_widget.dart';
import 'package:wms/views/customer/market/mk_detail_info_widget.dart';
import 'package:wms/models/market/market_detail_model.dart';
import '../controllers/market_all_commodity_page_controller.dart';
import 'cs_convert_sell_page.dart';
import 'package:wms/configs/wms_user.dart';

class MarketNormalDetailPage extends StatefulWidget {
  final num spuId;
  final num status;
  final model;

  const MarketNormalDetailPage({Key key, this.spuId, this.status, this.model}) : super(key: key);

  @override
  _MarketNormalDetailPageState createState() => _MarketNormalDetailPageState();
}

class _MarketNormalDetailPageState extends State<MarketNormalDetailPage> {
  MarketAllCommodityPageController pageController;

  @override
  void initState() {
    pageController = Get.put(MarketAllCommodityPageController(widget.spuId, widget.status, widget.model));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: WMSText(
            content: '单品在售',
            size: AppStyleConfig.navTitleSize,
          ),
          /*actions: [
            TextButton(
              onPressed: pageController.onTapShoppingCartHandle,
              child: WMSText(
                content: '购物车',
              ),
            ),
          ],*/
        ),
        body: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              // alignment: AlignmentDirectional.topCenter,
              children: [
                Expanded(
                  child: RefreshView(
                    header: MaterialHeader(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    ),
                    onRefresh: pageController.onRefresh,
                    child: ListView(
                      children: [
                        MKdetailTopWidget(
                          imagePath: widget.model.picturePath,
                          name: widget.model.commodityName,
                          color: widget.model.color,
                          brand: widget.model.brandNameCn,
                          spuId: null,
                          total: pageController.dataModel?.value?.onSaleCount ?? 0,
                          // showInfo: false,
                        ),
                        Obx(() => Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: WMSText(
                                          content: '商品详情',
                                          size: 15,
                                        )),
                                    GestureDetector(
                                        onTap: pageController.onChangeDetail,
                                        child: pageController.detailInfoShow.value
                                            ? Icon(Icons.keyboard_arrow_up_outlined)
                                            : Icon(
                                                Icons.keyboard_arrow_down_outlined,
                                              ))
                                  ],
                                ),
                                Visibility(
                                    visible: pageController.detailInfoShow.value,
                                    child: MarketDetailInfoWidget(model: pageController.detail)),
                              ],
                            )),
                        SizedBox(height: 20.h),
                        buildSizeListWidget(pageController),
                        buildShipmentList(pageController),
                      ],
                    ),
                  ),
                ),
                // Row(
                //   children: [
                /*Expanded(
                      child: OutlinedButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          ),
                        ),
                        onPressed: pageController.tenantUserIndex.value == -1
                            ? null
                            : () => pageController.onTapCommitHandle(context, 1),
                        child: Text('加入购物车'),
                      ),
                    ),
                    SizedBox(width: 10.w),*/
                // WMSButton(
                //   bgColor: Colors.black,
                //   title: '下单',
                //   callback: pageController.tenantUserIndex.value == -1
                //       ? null
                //       : () => pageController.onTapCommitHandle(context, 2),
                // ),
                // SizedBox(
                //   height: 60.h,
                // ),

                // Expanded(
                //     child: ElevatedButton(
                //       style: ButtonStyle(foregroundColor: AppStyleConfig.btnColor),
                //   onPressed: pageController.tenantUserIndex.value == -1
                //       ? null
                //       : () => pageController.onTapCommitHandle(context, 2),
                //   child: Text('下单'),
                // ))
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSizeListWidget(MarketAllCommodityPageController pageController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: WMSText(
                  content: '选择尺码',
                  size: 15,
                  // bold: true,
                ),
              ),
              Visibility(
                child: SizedBox(
                  width: 80,
                  child: WMSButton(
                    height: 28.0,
                    // also, use absolute pixel here in case of layout overflow.
                    width: 66.0,
                    fontSize: 12.sp,

                    bgColor: Colors.transparent,
                    textColor: Colors.black,
                    showBorder: true,
                    title: '全部转售',
                    callback: () {
                      Get.to(() => CSConvertSellPage());
                    },
                  ),
                ),
                visible: WMSUser.getInstance().depotPower,
              ),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              children:
                  buildSizeList(list: pageController.dataModel?.value?.marketSizeList, pageController: pageController),
            ),
          ),
          Visibility(
            child: Container(
              alignment: Alignment.centerLeft,
              child: WMSText(
                // specification
                content: pageController.dataModel?.value?.marketSizeList
                        ?.firstWhere((item) => pageController.skuIdData.value.storeIdStr == item.storeIdStr)
                        ?.specification ??
                    "",
                size: 15,
                // bold: true,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildSizeList({List<SizeListModel> list, MarketAllCommodityPageController pageController}) {
    List<Widget> widgets = [];
    list?.forEach((element) {
      widgets.add(buildSizeItemWidget(model: element, pageController: pageController));
    });

    return widgets;
  }

  Widget buildSizeItemWidget({MarketAllCommodityPageController pageController, SizeListModel model}) {
    final size = 60.0;
    return Container(
      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          pageController.setSkuIdData(model);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: size, // do not use relative width here in case of overflow.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                border: pageController.skuIdData.value.storeIdStr == model.storeIdStr
                    ? Border.all(width: 2.0, color: AppStyleConfig.btnColor)
                    : null,
                color: Colors.grey[200],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: WMSText(
                        content:
                            '${model.size ?? '无尺码'}${model.specification != null ? "/" + model.specification : ""}',
                        size: 14,
                        // bold: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  WMSText(
                    content: '${model.sellerCount ?? '0'}人',
                    size: 13,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//出货页面尺寸列表
  List<Widget> buildShipSizeList({List<SizeModel> list, MarketAllCommodityPageController pageController}) {
    List<Widget> widgets = [];
    list?.forEach((element) {
      widgets.add(buildShipSizeItemWidget(model: element, pageController: pageController));
    });

    return widgets;
  }

//出货页面尺寸列表
  Widget buildShipSizeItemWidget({MarketAllCommodityPageController pageController, SizeModel model}) {
    return Container(
      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          // pageController.setUserSkuIdData(model);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                border: pageController.skuIdData.value.storeIdStr == model.skuId
                    ? Border.all(width: 2.0, color: AppStyleConfig.btnColor)
                    : null,
                color: Colors.grey[200],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: WMSText(
                        content:
                            '${model.size ?? '无尺码'}${model.specification != null ? "/" + model.specification : ''}',
                        size: 14,
                        // bold: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  WMSText(
                    content: '${model.onSaleCount ?? '0'}件',
                    size: 13,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildShipmentList(MarketAllCommodityPageController pageController) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: WMSText(
              content: '出货列表',
              size: 15,
            ),
          ),
          SizedBox(height: 8.h),
          ListView.builder(
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              ChuHuoShipmentNormalModel model = pageController.dataSource[index];
              return Container(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    pageController.setTenantUser(model, index);
                    print(model.sizeList.toString() + '=====');
                    // print(model.appPrice);
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey[100],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 60.w,
                                    height: 60.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60.r),
                                      image: DecorationImage(
                                        image: NetworkImage(model.avatar ?? ''),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Container(
                                    height: 40.h,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 20.h,
                                          alignment: Alignment.centerLeft,
                                          child: WMSText(
                                            content: '¥${model.previewPrice ?? 0}',
                                            size: 16,
                                            // bold: true,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 20.h,
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                width: 60.w,
                                                child: WMSText(
                                                  content: '${model.depotName ?? '-'}',
                                                  size: 14,
                                                  // bold: true,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Container(
                                              height: 20.h,
                                              alignment: Alignment.center,
                                              child: WMSText(
                                                content: WMSUtil.expirationStringChange(model.expiration ?? 0),
                                                size: 14,
                                                // bold: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                buildButtonWidget(
                                  bgColor: WMSUser.getInstance().userInfoModel.userCode == model.userCode
                                      ? Colors.grey
                                      : AppConfig.themeColor,
                                  contentColor: Colors.white,
                                  height: 30.0,
                                  width: 60.0,
                                  radius: 5.0,
                                  handelClick: WMSUser.getInstance().userInfoModel.userCode == model.userCode
                                      ? () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext ctx) => wvDialog(
                                                  widget: Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                                                      child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Align(
                                                                  alignment: Alignment.topCenter,
                                                                  child: Text(
                                                                    '用户无法购买本人已出售的商品',
                                                                    style: TextStyle(
                                                                        fontSize: 14.0, fontWeight: FontWeight.bold),
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
                                        }
                                      : () {
                                          pageController.setTenantUser(model, index);
                                          pageController.onTapCommitHandle(context, 2);
                                        },
                                  buttonContent: '选购',
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                children: buildShipSizeList(list: model.sizeList, pageController: pageController),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => Visibility(
                            visible: pageController.tenantUserIndex.value == index,
                            child: Positioned(
                              top: 8.h,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r),
                                    bottomRight: Radius.circular(5.r),
                                  ),
                                  color: Colors.black,
                                ),
                                child: WMSText(
                                  content: '当前',
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              );
            },
            itemCount: pageController.dataSource.length,
          )
        ],
      ),
    );
  }
}
