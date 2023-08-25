import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_button.dart';
import 'package:wms/common/baseWidgets/wms_refresh_view.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/customer/market/controllers/shopping_cart_page_controller.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final ShoppingCartPageController pageController = Get.put(ShoppingCartPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '购物车',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Text(pageController.newOrderDataMap.length.toString()),
            Obx(
              () => RefreshView(
                header: MaterialHeader(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                ),
                onRefresh: pageController.onRefresh,
                onLoad: pageController.onLoad,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var item = pageController.newOrderDataMap[index];
                    print('item ${item.toJson()}');
                    return Text('${item.tenantUserCode}123');
                    // return CartCellWidget(
                    //   addCallback: () => pageController.onTapAdd(index),
                    //   subCallback: () => pageController.onTapSub(index, context),
                    //   dataModel: pageController.dataSource[index],
                    // );
                  },
                  itemCount: pageController.newOrderDataMap.length,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                width: 375.w,
                height: 54.h,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(icon: Icon(Icons.check_box_outline_blank_sharp), onPressed: () {}),
                        WMSText(
                          content: '全选',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        WMSText(
                          content: '合计：',
                        ),
                        Obx(
                          () => WMSText(
                            content: '¥${pageController.total}',
                            bold: true,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        WMSButton(
                          width: 100,
                          title: '结算',
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
