import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/utils/jk_over_scroll_behavior.dart';

import 'wms_choose_area_page_controller.dart';

class WMSChooseAreaPage extends StatelessWidget {
  final bool countryStatus;
  const WMSChooseAreaPage({Key key, this.countryStatus});

  @override
  Widget build(BuildContext context) {
    WMSChooseAreaPageController pageController =
        Get.put(WMSChooseAreaPageController(countryStatus: countryStatus));
    return Container(
      height: 500.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  alignment: Alignment(-1, 0),
                  child: WMSText(
                    content: '请选择所在地区',
                    bold: true,
                    size: 17,
                  )),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[200]),
                  child: Center(
                    child: Icon(
                      Icons.close_sharp,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: countryStatus
                          ? WMSText(content: pageController.country.value)
                          : WMSText(
                              content:
                                  '${pageController.province.value} ${pageController.city.value} ${pageController.area.value}')),
                  // Padding(
                  //     padding: EdgeInsets.only(right: 8.w),
                  //     child: WMSText(content: pageController.city.value)),
                  // Padding(
                  //     padding: EdgeInsets.only(right: 8.w),
                  //     child: WMSText(content: pageController.area.value)),
                ],
              ),
            ),
          ),
          Flexible(
            child: ScrollConfiguration(
              behavior: JKOverScrollBehavior(),
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController.pageViewController,
                children: [
                  if (countryStatus) buildCountryWidget(pageController),
                  if (!countryStatus) buildProvinceWidget(pageController),
                  // buildStateWidget(
                  //     callback: (index) => pageController.onTapProvince(index),
                  //     stateList: pageController.provinceList),
                  if (!countryStatus) buildCityWidget(pageController),
                  if (!countryStatus) buildAreaWidget(pageController),
                ],
              ),
            ),
          ),
          // Obx(
          //   () => Container(
          //     padding: EdgeInsets.symmetric(vertical: 8.h),
          //     child: Row(
          //       children: [
          //         Padding(
          //             padding: EdgeInsets.only(right: 8.w),
          //             child: WMSText(content: pageController.country.value)),
          //       ],
          //     ),
          //   ),
          // ),
          // Flexible(
          //   child: ScrollConfiguration(
          //     behavior: JKOverScrollBehavior(),
          //     child: PageView(
          //       physics: NeverScrollableScrollPhysics(),
          //       controller: pageController.pageViewController,
          //       children: [
          //         buildCountryWidget(pageController),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget buildCountryWidget(WMSChooseAreaPageController pageController) {
    return Obx(() {
      return ListView.builder(
        itemBuilder: (context, index) {
          print('$index');
          return GestureDetector(
            onTap: () => pageController.onTapCountry(index),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .5, color: Colors.grey[100]),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: WMSText(
                content: pageController.countryList[index].countryName,
                size: 13,
              ),
            ),
          );
        },
        itemCount: pageController.countryList.length,
      );
    });
  }

  Widget buildStateWidget({callback, stateList, stateName}) {
    return Obx(() {
      return ListView.builder(
        itemBuilder: (context, index) {
          print('$index');
          return GestureDetector(
            onTap: callback(index),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .5, color: Colors.grey[100]),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: WMSText(
                content: stateList[index].toJson()[stateName],
                size: 13,
              ),
            ),
          );
        },
        itemCount: stateList.length,
      );
    });
  }

  Widget buildProvinceWidget(WMSChooseAreaPageController pageController) {
    return Obx(() {
      return ListView.builder(
        itemBuilder: (context, index) {
          print('$index');
          return GestureDetector(
            onTap: () => pageController.onTapProvince(index),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .5, color: Colors.grey[100]),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: WMSText(
                content: pageController.provinceList[index].provinceName,
                size: 13,
              ),
            ),
          );
        },
        itemCount: pageController.provinceList.length,
      );
    });
  }

  Widget buildCityWidget(WMSChooseAreaPageController pageController) {
    return Obx(
      () => ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => pageController.onTapCity(index),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: .5, color: Colors.grey[100]))),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: WMSText(
                content: pageController.cityList[index].cityName,
                size: 13,
              ),
            ),
          );
        },
        itemCount: pageController.cityList.length,
      ),
    );
  }

  Widget buildAreaWidget(WMSChooseAreaPageController pageController) {
    return Obx(() => ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => pageController.onTapArea(index),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: .5, color: Colors.grey[100]),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: WMSText(
                  content: pageController.areaList[index].areaName,
                  size: 13,
                ),
              ),
            );
          },
          itemCount: pageController.areaList.length,
        ));
  }
}
