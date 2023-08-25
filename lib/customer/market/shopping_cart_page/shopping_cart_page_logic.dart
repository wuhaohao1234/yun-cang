import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wms/models/orderShow_model.dart';

import 'shopping_cart_page_state.dart';

class ShoppingCartPageLogic extends GetxController {
  final state = ShoppingCartPageState();

  /// 获取本地交易数据
  getShoppingCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('orderDataMap');
    String orderDataStr = prefs.getString('orderDataMap');
    if (orderDataStr == null) return;
    Map<String, dynamic> orderDataMap = json.decode(orderDataStr);
    Map<String, OrderShowModel> _newOrderDataMap = orderDataMap
        .map((key, value) => MapEntry(key, OrderShowModel.fromJson(value)));
    print('获取 $_newOrderDataMap');
    state.newOrderDataMap = _newOrderDataMap;
    update();
  }

  /// 全选
  void onChangedAllCheckbox(bool val) {
    bool _val = val ? false : true;
    state.allCheckbox = _val;
    if (_val) {
      state.newOrderDataMap.forEach((key, value) => value.selected = true);
    } else {
      state.newOrderDataMap.forEach((key, value) => value.selected = false);
    }
    onChanged();
    update();
  }

  /// 项目勾选
  void itemOnChanged(bool v, String key) {
    state.newOrderDataMap[key].selected = v;
    onChanged();
    state.selectDataList.forEach((element) => print(element.toJson()));
    mappingAllCheckbox();
    update();
  }

  /// 数据响应
  void onChanged() {
    List<OrderShowModel> _dataList = state.newOrderDataMap.values.toList();
    List<OrderShowModel> _newDataList =
        _dataList.where((element) => element.selected).toList();
    state.selectDataList = _newDataList;
  }

  /// 映射全选
  void mappingAllCheckbox() {
    if (state.selectDataList.length == state.newOrderDataMap.length) {
      state.allCheckbox = true;
    } else if (state.selectDataList.length == 0) {
      state.allCheckbox = false;
    } else {
      state.allCheckbox = null;
    }
    update();
  }

  /// 结算
  void submit() {
    if (state.newOrderDataMap == null) return;
    state.newOrderDataMap.forEach((key, value) {
      print(key);
      print(value.toJson());
    });
  }

  // 加
  void onTapAddHandle(WmsUserOrderDetailsList item) {
    int maxInt = item.sysPrepareSkuIds.length;
    if (item.count >= maxInt) return;
    item.count = item.count + 1;
    item.sysPrepareSkuIdLength = item.count;
    update();
  }

  // 减
  void onTapSubtractionHandle(WmsUserOrderDetailsList item) {
    if (item.count <= 1) return;
    item.count = item.count - 1;
    item.sysPrepareSkuIdLength = item.count;
    update();
  }

  @override
  void onReady() {
    getShoppingCartData();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
