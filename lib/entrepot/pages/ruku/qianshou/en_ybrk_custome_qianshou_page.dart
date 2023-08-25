// 仓库端  待收货页面无预约签收

import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/entrepot/controllers/ruku/en_ybrk_sign_no_forecast_page_controller.dart';

import 'package:wms/views/common/section_title_widget.dart';
import 'package:wms/common/baseWidgets/wms_upload_image_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wms/common/baseWidgets/wms_text_field.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

class ENYbrkSignNoForecastPage extends StatelessWidget {
  final String mailNo;
  ENYbrkSignNoForecastPage({
    Key key,
    this.mailNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ENYbrkSignNoForecastPageController pageController =
        Get.put(ENYbrkSignNoForecastPageController(this.mailNo));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '签收',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/nofound.svg',
                      width: 150.w,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Text(
                        '未匹配到预约入库单',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    WMSTextField(
                        title: '客户代码',
                        hintText: '请输入',
                        keyboardType: TextInputType.text,
                        controller: pageController.customerCode),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 0.5, color: Colors.grey[200]),
                        ),
                      ),
                      child: Row(
                        children: [
                          WMSText(
                            content: '入库要求',
                            bold: true,
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                              child: Obx(
                            () => DropdownButton(
                              underline: Container(),
                              items: [
                                DropdownMenuItem(
                                    child: Text('仅理货点数'), value: '1'),
                                DropdownMenuItem(
                                    child: Text('质检拍照'), value: '2'),
                                DropdownMenuItem(
                                    child: Text('临时存放'), value: '3')
                              ],
                              onChanged: (value) {
                                pageController
                                    .changeorderOperationalRequirements(value);
                              },
                              value: pageController
                                  .orderOperationalRequirements.value
                                  .toString(),
                            ),
                          ))
                        ],
                      ),
                    ),
                    WMSTextField(
                      title: '收货箱数',
                      hintText: '必填',
                      keyboardType: TextInputType.number,
                      controller: pageController.boxTotalFact,
                    ),
                    SectionTitleWidget(
                      title: '上传收货照片',
                    ),
                    buildItemsImage(pageController),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20.h),
                child: buildButtonWidget(
                    width: 343.w,
                    height: 34.h,
                    radius: 2.0,
                    contentColor: Colors.white,
                    bgColor: pageController.customerCode != null
                        ? AppConfig.themeColor
                        : Colors.grey,
                    buttonContent: pageController.buttonContent,
                    handelClick: pageController.onTapCommitHandle),
              ),
            ],
          )),
    );
  }

  // 商品照片
  Widget buildItemsImage(ENYbrkSignNoForecastPageController pageController) {
    return Obx(() => WMSUploadImageWidget(
          maxLength: 6,
          images: pageController.itemsImages.value,
          addCallBack: () {
            print('add =======');
            pageController.onTapAddItemsImage();
          },
          delCallBack: (index) {
            pageController.onTapDelItemsImage(index);
          },
        ));
  }
}
