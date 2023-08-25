import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:wms/configs/wv_tool.dart';
import 'package:wms/models/order/order_model.dart';

/// Create by bigv on 21-7-14
/// Description:

class OrderCellController extends GetxController {
  final OrderModel dataModel;

  OrderCellController(this.dataModel);

  // 控制器
  TimerUtil mCountDownTimerUtil;

  // 使用变量
  RxInt countdownInt = 0.obs;
  RxString countdownStr = '-'.obs;

  @override
  void onInit() {
    print('dataModel?.createTime ${dataModel?.createTime}');
    print('dataModel?.createTime ${dataModel?.createTime}');
    WvTool.countdown(dataModel?.createTime, (str, int) {
      countdownStr.value = str;
      countdownInt.value = int;
    });
    super.onInit();
  }

  @override
  void onReady() {
    print('onReady');

    WvTool.countdown(dataModel?.createTime, (str, int) {
      print('dasd');
      countdownStr.value = str;
      countdownInt.value = int;
    });
    super.onReady();
  }

  /// 选择框
  void onChanged(bool v, Function checkboxCallBack) {
    checkboxCallBack({"id": 1, "selected": v});
  }

  @override
  void onClose() {
    super.onClose();
    if (WvTool.mCountDownTimerUtil != null) {
      WvTool.mCountDownTimerUtil.cancel();
    }
    // if (mCountDownTimerUtil != null) mCountDownTimerUtil.cancel();
  }
}
