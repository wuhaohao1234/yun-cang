// 理货详情、添加商品页面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/entrepot/controllers/en_add_wares_page_controller.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

class ENRkdAddwaresPage extends StatelessWidget {
  final int orderId;
  final int orderOperationalRequirements;
  final bool fromScan;

  // final List wmsCommodityInfoVOList;

  const ENRkdAddwaresPage(
      {Key key, this.orderId, this.orderOperationalRequirements, this.fromScan
      //  this.wmsCommodityInfoVOList
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ENAddWaresPageController pageController = Get.put(ENAddWaresPageController(
      orderId,
      // wmsCommodityInfoVOList
    ));
    bool _fromScan = this.fromScan ?? false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '申请新品',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: TextButton(
          child: WMSText(
            content: '取消',
            color: Colors.grey,
          ),
          onPressed: () {
            if (_fromScan) {
              Get.back();
              Get.back();
            } else {
              Get.back();
            }
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (_fromScan) {
            Get.back();
            Get.back();
          } else {
            Get.back();
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              child: ScrollConfiguration(
                behavior: JKOverScrollBehavior(),
                child: ListView(
                  children: [
                    Text('新品信息',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    WMSTextField(
                      title: '商品货号',
                      hintText: '选填',
                      keyboardType: TextInputType.text,
                      controller: pageController.stockCode,
                    ),
                    WMSTextField(
                      title: '标签条码',
                      hintText: '必填',
                      keyboardType: TextInputType.text,
                      controller: pageController.labelBarcode,
                      endWidget: GestureDetector(
                        // onTap: () {},
                        onTap: () {
                          Get.to(() => ENScanStandardPage(
                                title: "标签扫码",
                                // leading: backLeadingIcon,
                              )).then((value) {
                            pageController.labelBarcode.text = value;
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/svgs/scan.svg',
                          width: 15.w,
                        ),
                      ),
                    ),
                    // buildBarcodeWdidget(pageController),
                    WMSTextField(
                      title: '规格/尺码',
                      hintText: '请输入，无尺码时请填OS',
                      keyboardType: TextInputType.text,
                      controller: pageController.size,
                    ),
                    WMSTextField(
                        title: '数量',
                        hintText: '必填',
                        keyboardType: TextInputType.number,
                        controller: pageController.commodityNumber),
                    SectionTitleWidget(
                      title: '商品照片(必填)',
                    ),
                    buildItemsImage(pageController),
                    TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.multiline,
                      controller: pageController.remark,
                      style: TextStyle(fontSize: 13.sp),
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: '添加备注',
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: buildButtonWidget(
                        width: 343.w,
                        height: 34.h,
                        radius: 2.0,
                        contentColor: Colors.white,
                        bgColor: AppConfig.themeColor,
                        buttonContent: '申请新品',
                        handelClick: pageController.onTapCommitHandle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 条形码
  Widget buildBarcodeWdidget(ENAddWaresPageController pageController) {
    return WMSCodeInputWidget(
      controller: pageController.labelBarcode,
      callback: () => pageController.onTapScanBarcode(),
    );
  }

  // 商品照片
  Widget buildItemsImage(ENAddWaresPageController pageController) {
    return Obx(() {
      return WMSUploadImageWidget(
        maxLength: 6,
        images: pageController.itemsImages.value,
        addCallBack: () {
          print('add =======');
          pageController.onTapAddItemsImage();
        },
        delCallBack: (index) {
          pageController.onTapDelItemsImage(index);
        },
      );
    });
  }
}
