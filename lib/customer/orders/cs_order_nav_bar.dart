import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/customer/orders/controllers/cs_order_nav_bar_controller.dart';

class CSOrderNavBar extends StatelessWidget {
  CSOrderNavBarController pageController = Get.put(CSOrderNavBarController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pageController.onTapSellItem,
              child: Container(
                width: 120.w,
                height: 34.h,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Color(0xfff2f2f2)),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  color: pageController.model.value == 0
                      ? Colors.white
                      : Color(0xfff2f2f2),
                ),
                child: Center(
                  child: WMSText(
                    content: '出售',
                    bold: pageController.model.value == 0,
                    color: pageController.model.value == 0
                        ? Colors.black
                        : Color(0xff666666),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: pageController.onTapBuyItem,
              child: Container(
                  width: 120.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Color(0xfff2f2f2)),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: pageController.model.value == 1
                        ? Colors.white
                        : Color(0xfff2f2f2),
                  ),
                  child: Center(
                      child: WMSText(
                    content: '购买',
                    bold: pageController.model.value == 1,
                    color: pageController.model.value == 1
                        ? Colors.black
                        : Color(0xff666666),
                  ))),
            ),
          ],
        ),
      ),
    );
  }
}
