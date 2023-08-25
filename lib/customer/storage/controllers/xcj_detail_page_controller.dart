import 'package:get/get.dart';

// import 'package:wms/models/entrepot/en_wares_model.dart';
import 'package:wms/models/storage/exception_list_detail_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class XcjDetailPageController extends GetxController {
  final num id;

  XcjDetailPageController(this.id);

  var dataModel = ExceptionListDetailModel().obs;

  @override
  void onInit() {
    super.onInit();
    EasyLoadingUtil.showLoading();
    requestData();
  }

  void requestData() {
    HttpServices.exceptionListDetail(
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
