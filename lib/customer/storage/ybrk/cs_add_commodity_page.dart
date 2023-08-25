// 预约入库、添加商品页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/common/baseWidgets/wm_code_input_widget.dart';

// import 'package:wms/entrepot/controllers/en_add_wares_page_controller.dart';
import 'package:wms/customer/storage/controllers/cs_ybrk_add_commodity_page_controller.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

class CSYbrkAddCommodityPage extends StatefulWidget {
  final List commodityList;
  final String orderIdName;

  const CSYbrkAddCommodityPage({Key key, this.commodityList, this.orderIdName})
      : super(key: key);

  @override
  _CSYbrkAddCommodityPageState createState() => _CSYbrkAddCommodityPageState();
}

class _CSYbrkAddCommodityPageState extends State<CSYbrkAddCommodityPage> {
  @override
  Widget build(BuildContext context) {
    CSYbrkAddCommodityPageController pageController = Get.put(
        CSYbrkAddCommodityPageController(
            widget.commodityList, widget.orderIdName));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '预约入库-申请新品',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: TextButton(
          child: WMSText(
            content: '取消',
            color: Colors.grey,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            child: ScrollConfiguration(
              behavior: JKOverScrollBehavior(),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Text('新品信息',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            )),
                        WMSTextField(
                          title: '商品货号',
                          hintText: '请输入',
                          keyboardType: TextInputType.text,
                          controller: pageController.stockCode,
                          onSubmittedCallback: (value) {
                            setState(() {});
                          },
                        ),
                        WMSTextField(
                          title: '标签条码',
                          hintText: '请输入',
                          keyboardType: TextInputType.text,
                          controller: pageController.labelBarCode,
                          onSubmittedCallback: (value) {
                            setState(() {});
                          },
                          endWidget: GestureDetector(
                            onTap: () {
                              Get.to(() => ENScanStandardPage(
                                    title: "扫SN码",
                                    // leading: backLeadingIcon,
                                  )).then((value) {
                                pageController.labelBarCode.text = value;
                              });
                            },
                            child: SvgPicture.asset(
                              'assets/svgs/scan.svg',
                              width: 15.w,
                            ),
                          ),
                        ),
                        WMSTextField(
                          title: '规格/尺码',
                          hintText: '请输入，无尺码时请填OS',
                          keyboardType: TextInputType.text,
                          controller: pageController.size,
                          onSubmittedCallback: (value) {
                            setState(() {});
                          },
                        ),
                        WMSTextField(
                          title: '数量',
                          hintText: '请输入',
                          keyboardType: TextInputType.number,
                          controller: pageController.commodityNumber,
                          onSubmittedCallback: (value) {
                            setState(() {});
                          },
                        ),
                        SectionTitleWidget(
                          title: '商品照片(请选择)',
                        ),
                        buildItemsImage(pageController),
                        TextField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.multiline,
                          controller: pageController.remark,
                          onChanged: (value) {
                            setState(() {});
                          },
                          style: TextStyle(fontSize: 13.sp),
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: '添加备注',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(343.w, 34.w)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => AppStyleConfig.btnColor
                            // pageController.checkInput() == true
                            //     ? AppStyleConfig.btnColor
                            //     : null
                            ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        pageController.onTapCommitHandle();
                      }
                      // pageController.checkInput() == false
                      //     ? null
                      //     : () {
                      //         FocusScope.of(context).requestFocus(FocusNode());
                      //         pageController.onTapCommitHandle();
                      //       }
                      ,
                      child: Text(
                        '生成预约单',
                        style: TextStyle(fontSize: 12.sp),
                      ),
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

  Widget buildBarcodeWdidget(CSYbrkAddCommodityPageController pageController) {
    return WMSCodeInputWidget(
      controller: pageController.labelBarCode,
      callback: () => pageController.onTapScanBarcode(),
    );
  }

  Widget buildItemsImage(CSYbrkAddCommodityPageController pageController) {
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
