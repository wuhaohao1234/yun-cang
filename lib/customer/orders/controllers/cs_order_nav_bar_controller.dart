import 'package:get/get.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/utils/event_bus_util.dart';

//设置订单页面购买与出售tab
class CSOrderNavBarController extends GetxController {
  // 海关审核需取消
  var model = 0.obs;
  //出售0 购买1
  CSOrderNavBarController(){
    model.value = WMSUser.getInstance().depotPower?0:1;
  }
  void onTapBuyItem() {
    model.value = 1;
    EventBusUtil.getInstance().fire(
      ChangeOrderModel(1),
    );
  }

  void onTapSellItem() {
    model.value = 0;
    EventBusUtil.getInstance().fire(
      ChangeOrderModel(0),
    );
  }
}
