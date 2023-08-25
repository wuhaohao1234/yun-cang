/*获得一个spu下的sku列表信息 */
// 搜索页面
import 'package:get/get.dart';
import 'package:wms/models/entrepot/sku/en_shangpin_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class SkuSearchPageController extends GetxController {
  final num prepareOrderId;
  final num spuId;

  SkuSearchPageController(this.prepareOrderId, this.spuId);
  var dataLength = 0.obs;
  var dataModel = ENShangPingModel().obs;
  @override
  void onInit() {
    super.onInit();
    print("cool");
    request();
  }

  void request() {
    requestSkus();
  }

  // 搜商品
  void requestSkus() {
    // 根据内容请求商品
    HttpServices.getSPuDetail(
        prepareOrderId: prepareOrderId,
        spuId: spuId,
        success: (data) {
          print(data);
          EasyLoadingUtil.hidden();
          dataModel.value = ENShangPingModel.fromJson(data);
          dataLength.value = dataModel
              .value.sysPrepareOrderSpuList.sysPrepareOrderSpuList.length;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
  }
}
