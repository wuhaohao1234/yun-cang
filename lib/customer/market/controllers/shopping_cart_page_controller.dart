import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wms/common/baseWidgets/wms_dialog.dart';
import 'package:wms/models/orderShow_model.dart';
import 'package:wms/models/shopping_cart_model.dart';

class ShoppingCartPageController extends GetxController {
  var total = 0.0.obs;
  var isAll = false.obs;

  var dataSource = RxList<ShoppingCartModel>();

  // 循环数据
  RxMap<String, OrderShowModel> newOrderDataMap =
      RxMap<String, OrderShowModel>();

  @override
  void onInit() {
    print('getShoppingCartData INIT');
    getShoppingCartData();
    super.onInit();
    dataSource.value = [
      ShoppingCartModel(count: 1),
      ShoppingCartModel(count: 2),
      ShoppingCartModel(count: 3),
    ];
  }

  Future onRefresh() async {}

  Future onLoad() async {}

  void onTapAdd(int index) {
    dataSource[index].count += 1;
    dataSource.refresh();
  }

  void onTapSub(int index, BuildContext context) {
    if (dataSource[index].count == 1) {
      print('删除');
      WMSDialog.showOperationPromptDialog(context, content: '确认删除该商品',
          handle: () {
        dataSource[index].count -= 1;
        dataSource.removeAt(index);
      });
    } else {
      dataSource[index].count -= 1;
    }

    dataSource.refresh();
  }

  /// 获取本地交易数据
  getShoppingCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String orderDataStr = prefs.getString('orderDataMap');
    Map<String, dynamic> orderDataMap = json.decode(orderDataStr);
    Map<String, OrderShowModel> _newOrderDataMap =
        orderDataMap.map((key, value) {
      print(key.runtimeType.toString());
      return MapEntry(key, OrderShowModel.fromJson(value));
    });
    print('获取 $_newOrderDataMap');
    newOrderDataMap = _newOrderDataMap;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
