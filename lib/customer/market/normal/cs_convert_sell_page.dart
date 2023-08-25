import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/customer/market/controllers/market_all_commodity_page_controller.dart';
import 'package:wms/models/market/market_all_detail_model.dart';
import '../controllers/market_all_commodity_page_controller.dart';
import 'package:wms/models/market/chu_huo_shipment_normal_model.dart';
import 'package:wms/views/customer/market/commodity_resale_price_widget.dart';

class CSConvertSellPage extends StatefulWidget {
  @override
  _CSConvertSellPageState createState() => _CSConvertSellPageState();
}

class _CSConvertSellPageState extends State<CSConvertSellPage> {
  final MarketAllCommodityPageController pageController =
      Get.find<MarketAllCommodityPageController>();
  num resalePrice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '转售-小程序',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            // Get.delete<MarketAllCommodityPageController>();
            Get.back();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 8.w,
        ),
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SectionTitleWidget(
                      title: '出货列表',
                    ),
                    Column(
                      children: [
                        Container(
                          // color: Colors.white,
                          // child: Obx(() => buildShipmentList(pageController)),
                          child: buildShipmentList(pageController),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 8.w,
                      ),
                      child: CommodityResalePriceWidget(
                          initNumber: 0.00,
                          title: '统一转售（元）',
                          onChangeCallback: (value) {
                            print(value);
                            setState(() {
                              // EasyLoadingUtil.showMessage(
                              //     message: "已加价$value元");
                              resalePrice = value;
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 20.h),
                child: WMSButton(

                    // style: TextButton.styleFrom(
                    // minimumSize: Size(90.w, 34.h),
                    // fixedSize: Size(343.w, 34.h),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    // ),
                    // ),
                    callback: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                        if(resalePrice==0){
                          EasyLoadingUtil.showMessage(message: '请改变价格');
                          return;
                        }
                      var data = await HttpServices().csMarketResale(
                        storeStrList: [
                          pageController.dataModel.value.marketSizeList
                              .fold(
                                  '',
                                  (previousValue, element) =>
                                      previousValue.toString() +
                                      element.storeIdStr +
                                      ',')
                              .substring(1)
                        ],
                        spuId: pageController.spuId,
                        resalePrice: resalePrice,
                      );
                      if (data == false) {
                        EasyLoadingUtil.showMessage(message: '转售失败');
                      }
                      if (data != false) {
                        EasyLoadingUtil.showMessage(message: '已成功转售');
                        Get.back();
                      }
                    },
                    title: '转售到小程序'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShipmentList(MarketAllCommodityPageController pageController) {
    return ListView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        ChuHuoShipmentNormalModel model = pageController.dataSource[index];
        return Container(
          margin: EdgeInsets.only(top: 8.h),
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey[200],
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
                              content: '¥${model.previewPrice}',
                              size: 16,
                              bold: true,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 20.h,
                                alignment: Alignment.center,
                                child: WMSText(
                                  content: '${model.depotName}',
                                  size: 14,
                                  bold: true,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Container(
                                height: 20.h,
                                alignment: Alignment.center,
                                child: WMSText(
                                  content: WMSUtil.expirationStringChange(
                                      model.expiration),
                                  size: 14,
                                  bold: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Container(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  children: buildShipSizeList(
                      list: model.sizeList, pageController: pageController),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: pageController.dataSource.length,
    );
  }

  //出货页面尺寸列表
  List<Widget> buildShipSizeList(
      {List<SizeModel> list, MarketAllCommodityPageController pageController}) {
    List<Widget> widgets = [];
    list?.forEach((element) {
      widgets.add(buildShipSizeItemWidget(
          model: element, pageController: pageController));
    });

    return widgets;
  }

  //出货页面尺寸列表
  Widget buildShipSizeItemWidget(
      {MarketAllCommodityPageController pageController, SizeModel model}) {
    return Container(
      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          // pageController.setUserSkuIdData(model);
        },
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.r)),
            border: pageController.skuIdData.value.storeIdStr == model.skuId
                ? Border.all(width: 2.0, color: Colors.black)
                : null,
            color: Colors.grey[200],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WMSText(
                content: '${model.size ?? '无尺码'}',
                size: 14,
                bold: true,
              ),
              SizedBox(
                height: 4.h,
              ),
              WMSText(
                content: '${model.onSaleCount ?? '0'}件',
                size: 13,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
