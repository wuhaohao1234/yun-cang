import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';
import 'package:wms/customer/storage/common/kc_select_widget/kc_select_widget_view.dart';
import 'package:wms/models/inventory_categorys_model.dart';
import 'package:wms/models/market/market_wares_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class CSKCPageController extends GetxController {
  var dataSource = RxList<InventoryCategorysModel>();

  // 控制器
  TabController tabController;

  // 全选
  RxBool allCheckbox = false.obs;

  @override
  void onInit() {
    super.onInit();

    EasyLoadingUtil.showLoading();
    requestData();
  }

  void requestData() {
    HttpServices.getInventoryCategorys(success: (data, total) {
      EasyLoadingUtil.hidden();
      // data.forEach((element) {
      //   print('${element.categoryName}  =  ${element.qty}');
      // });
      dataSource.value = data;
      // tabController = TabController(length: dataSource.length);
    }, error: (error) {
      EasyLoadingUtil.hidden();
      ToastUtil.showMessage(message: error.message);
    });
  }

  // 更改全选
  void onChangedAllCheckbox(v) {
    allCheckbox.value = v;
  }

  //打开底部弹出框
  void openPicker(BuildContext context, MarketWaresModel data) {
    setUpWidget(context, KcSelectWidgetPage(data: data)
        // KcSelectWidget(data:data),
        );
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
  }
}
