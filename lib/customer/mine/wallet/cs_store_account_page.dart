import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_refresh_view.dart';
import 'package:wms/views/customer/mine/moneys_log_cell.dart';

import '../controllers/cs_store_account_page_controller.dart';

class CSStoreAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CSStoreAccountPageController pageController = Get.put(CSStoreAccountPageController());
    return RefreshView(
      header: MaterialHeader(
        valueColor: AlwaysStoppedAnimation(Colors.black),
      ),
      onRefresh: pageController.onRefresh,
      onLoad: pageController.canMore.value ? pageController.onLoad : null,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return MoneysLogCell(model: pageController.dataSource[index],);
        },
        itemCount: pageController.dataSource.length,
      ),
    );
  }
}
