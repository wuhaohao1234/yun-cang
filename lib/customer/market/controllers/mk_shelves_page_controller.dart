import 'package:get/get.dart';
import 'package:wms/models/market/market_all_detail_model.dart';
import 'package:wms/utils/easy_loading_util.dart';

class MKShelvesPageController extends GetxController {
  final int typeMode; // 0 得物 1 APP

  MKShelvesPageController(this.typeMode);

  var dataModel = MarketAllDetailModel().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
  }
}
