import 'package:get/get.dart';
import 'package:wms/models/logistics_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class ENLogisticsPageController extends GetxController {
  final String dataCode;

  ENLogisticsPageController(this.dataCode);

  var dataModel = LogisticsModel().obs;

  @override
  void onInit() {
    super.onInit();
    dataModel.value = null;
    EasyLoadingUtil.showLoading();
    requestData();
  }

  void requestData() {
    print('dataCode = $dataCode');
    HttpServices.logistics(
      dataCode: dataCode,
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
    EasyLoadingUtil.popHidden();
  }
}
