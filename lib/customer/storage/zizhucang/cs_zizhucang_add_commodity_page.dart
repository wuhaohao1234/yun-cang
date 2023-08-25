// 自主仓申请新品页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
// import 'package:wms/common/baseWidgets/wm_code_input_widget.dart';
import 'package:wms/customer/storage/controllers/cs_zizhucang_add_commodity_page_controller.dart';
import 'cs_zizhucang_add_order_page.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

class CSZiZhuCangAddCommodityPage extends StatefulWidget {
  final List commodityList;

  const CSZiZhuCangAddCommodityPage({Key key, this.commodityList})
      : super(key: key);

  @override
  _CSZiZhuCangAddCommodityPageState createState() =>
      _CSZiZhuCangAddCommodityPageState();
}

class _CSZiZhuCangAddCommodityPageState
    extends State<CSZiZhuCangAddCommodityPage> {
  @override
  Widget build(BuildContext context) {
    CSZiZhuCangAddCommodityPageController pageController =
        Get.put(CSZiZhuCangAddCommodityPageController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '自主仓-申请新品',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            // pageController.onClose();
            // Get.delete<CSZiZhuCangAddCommodityPageController>();
            Get.offAll(() => CSZiZhuCangAddOrderPage());
          },
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
              child: ListView(
                children: [
                  Text('新品信息',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  WMSTextField(
                    title: '商品货号',
                    hintText: '请输入，选填',
                    keyboardType: TextInputType.text,
                    controller: pageController.stockCode,
                    onSubmittedCallback: (value) {
                      setState(() {});
                    },
                  ),
                  WMSTextField(
                    title: '标签条码',
                    hintText: '请输入，必填',
                    keyboardType: TextInputType.text,
                    controller: pageController.labelBarcode,
                    onSubmittedCallback: (value) {
                      setState(() {});
                    },
                    endWidget: GestureDetector(
                      onTap: () {
                        Get.to(() => ENScanStandardPage(
                              title: "扫SN码",
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
                    onSubmittedCallback: (value) {
                      setState(() {});
                    },
                  ),
                  WMSTextField(
                    title: '数量',
                    hintText: '必填',
                    keyboardType: TextInputType.number,
                    controller: pageController.commodityNumber,
                    onSubmittedCallback: (value) {
                      setState(() {});
                    },
                  ),
                  buildSourcePlacewidget(pageController),

                  SectionTitleWidget(
                    title: '商品照片(必填)',
                  ),
                  buildItemsImage(pageController),
                  SizedBox(
                    height: 20.h,
                  ),
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
                      // border: InputBorder.none,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0.1)),
                      hintStyle: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(90.w, 34.w)),
                        // fixedSize: MaterialStateProperty.all(Size(343.w, 34.w)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => pageController.checkInput() == true
                                ? AppStyleConfig.btnColor
                                : null),
                      ),
                      onPressed: pageController.checkInput() == false
                          ? null
                          : () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              pageController.onTapCommitHandle();
                            },
                      child: Text(
                        '生成入库单',
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

  Widget buildSourcePlacewidget(
      CSZiZhuCangAddCommodityPageController pageController) {
    return Obx(() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text("商品所在地"), // Huzi@04/25: 这里可能要多加hinttext, 可能要多行
          ),
          SizedBox(width: 20.w),
          Radio(
              value: '0',
              groupValue: pageController.sourcePlace.value,
              activeColor: Colors.blue,
              onChanged: (value) {
                pageController.onChangeSourcePlace(value);
              }),
          WMSText(
            content: '国现',
          ),
          SizedBox(
            width: 8.w,
          ),
          Radio(
            value: '1',
            groupValue: pageController.sourcePlace.value,
            activeColor: Colors.blue,
            onChanged: (value) {
              pageController.onChangeSourcePlace(value);
            },
          ),
          WMSText(
            content: '境外',
          ),
        ],
      );
    });
  }

  Widget buildItemsImage(CSZiZhuCangAddCommodityPageController pageController) {
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
