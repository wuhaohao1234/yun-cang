/// 商品controller, 用于理货时搜索和添加商品用 */
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/models/entrepot/sku/en_shangpin_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class ENShangPingController extends GetxController {
  TextEditingController textC;

  var dataSource = RxList<ENShangPingStockModel>();
  var dataLength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    textC = TextEditingController();
  }

  void request(num prepareOrderId) {
    requestSkus(prepareOrderId);
  }

  // 搜商品
  void requestSkus(num prepareOrderId) {
    // 根据内容请求商品
    EasyLoadingUtil.showLoading();
    HttpServices.enSearchSkuList(
        stockCode: textC.text,
        prepareOrderId: prepareOrderId,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          // dataSource.value = data;
          dataLength.value = data.length;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  void requestSkuByScan(num prepareOrderId) {
    // 根据扫描请求商品
    EasyLoadingUtil.showLoading();
    HttpServices.enSearchSkuByScan(
        skuCode: textC.text,
        prepareOrderId: prepareOrderId,
        success: (data) {
          EasyLoadingUtil.hidden();
          // dataSource.value = data;
          // dataLength.value = data.length;
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
    textC?.dispose();
  }
}
