import 'package:get/get.dart';
import 'package:wms/models/entrepot/en_wares_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class ENWaresDetailPageController extends GetxController {
  final num id;

  var dataModel = ENWaresModel().obs;

  var itemsState = 0.obs; // 0 正常  1 瑕疵

  ENWaresDetailPageController(this.id);

  @override
  void onInit() {
    super.onInit();
    EasyLoadingUtil.showLoading();
    requestData();
  }

  // 请求数据
  requestData() {
    HttpServices.enPrepareSkuDetail(
        id: id,
        success: (data) {
          EasyLoadingUtil.hidden();
          dataModel.value = data;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  Future<void> onRefresh() async {
    requestData();
  }
}
