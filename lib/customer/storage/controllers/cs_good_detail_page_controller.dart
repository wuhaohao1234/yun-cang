import 'package:get/get.dart';
import 'package:wms/models/cs_god_detail_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class CSGoodDetailPageController extends GetxController {
  final num id;

  CSGoodDetailPageController(this.id);

  var dataModel = CSGodDetailModel().obs;

  @override
  void onInit() {
    super.onInit();
    EasyLoadingUtil.showLoading();
    requestData();
  }

  void requestData() {
    HttpServices.prepareSkuDetail(
      query: id.toString(),
      success: (data) {
        EasyLoadingUtil.hidden();
        dataModel.value = data;
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  Future onRefresh() async {
    requestData();
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.hidden();
  }
}
