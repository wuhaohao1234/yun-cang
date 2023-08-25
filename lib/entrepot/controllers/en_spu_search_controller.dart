/*获得商品spu信息 */
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/models/entrepot/sku/en_shangpin_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class SpuSearchPageController extends GetxController {
  final int prepareOrderId;

  SpuSearchPageController(this.prepareOrderId);

  TextEditingController textC;
  var dataSource = [].obs;
  // var dataSource = RxList<ENShangPingModel>();
  var dataLength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    textC = TextEditingController();
    request(prepareOrderId);
  }

  void request(num prepareOrderId) {
    requestSkus(prepareOrderId);
  }

  // 搜商品
  void requestSkus(num prepareOrderId) {
    // 根据内容请求商品
    // print("输入的商品ID ${textC.text}, $prepareOrderId");
    dataSource.value = [];
    EasyLoadingUtil.showLoading();
    dataSource.value = [];
    HttpServices.enSearchSkuList(
        stockCode: textC.text ?? '',
        prepareOrderId: prepareOrderId,
        pageSize: 100,
        pageNum: 1,
        success: (data, total) {
          if (total != 0) {
            print(data);
            print(total);
            EasyLoadingUtil.hidden();
            dataSource.value =
                data.map((e) => ENShangPingStockModel.fromJson(e)).toList();
          }
          dataSource.value =
              data.map((e) => ENShangPingStockModel.fromJson(e)).toList();
          dataLength.value = data.length;
          update();
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
          dataLength.value = 0;
        });
    update();
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
    textC?.dispose();
  }
}
