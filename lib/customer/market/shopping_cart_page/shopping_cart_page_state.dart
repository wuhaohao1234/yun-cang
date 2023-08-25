import 'package:wms/models/orderShow_model.dart';

class ShoppingCartPageState {
  // 循环数据
  Map<String, OrderShowModel> newOrderDataMap;

  // 全选状态
  bool allCheckbox;

  // 被选择的数据List
  List<OrderShowModel> selectDataList;

  ShoppingCartPageState() {
    ///Initialize variables
    allCheckbox = false;
  }
}
