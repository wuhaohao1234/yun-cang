import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';
import 'package:wms/models/entrepot/sku/en_shangpin_model.dart';
import 'en_shangping_search.dart';
import 'en_shangping.dart'; //商品界面
import 'en_rkd_add_wares_page.dart'; //新增商品页面

Future scanSku(
    {num prepareOrderId,
    num instoreOrderId,
    num orderOperationalRequirements,
    clearPrev = false,
    IconButton backLeadingIcon,
    callback}) async {
  // orderOperationalRequirements 扫码要求
  print(orderOperationalRequirements);
  await Permission.camera.request();
  Get.to(() => ENScanStandardPage(
        title: "扫码添加商品",
        searchType: "shangpin",
        leading: backLeadingIcon,
        orderOperationalRequirements: orderOperationalRequirements,
      )).then((value) {
    // 首先检索商品

    if (value != null) {
      EasyLoadingUtil.showLoading(statusText: "查找商品");
      print(prepareOrderId);
      print(orderOperationalRequirements);
      HttpServices.enSearchSkuByScan(
          skuCode: value,
          prepareOrderId: prepareOrderId,
          success: (ENShangPingModel shangping) {
            print("shangping  ${shangping.toJson()}");
            Function goNext = () => ENShangPingPage(
                  instoreOrderId: instoreOrderId,
                  prepareOrderId: prepareOrderId,
                  spuId: shangping.spuId,
                  skuId: shangping.skuId,
                  dataModel: shangping,
                  orderOperationalRequirements: orderOperationalRequirements,
                  callback: callback,
                );
            EasyLoadingUtil.hidden();
            if (clearPrev) {
              Get.off(goNext);
            } else {
              Get.to(goNext);
            }
          },
          error: (ErrorEntity e) {
            EasyLoadingUtil.showMessage(message: "未找到商品");
            Get.to(() => SkuSearchPage(
                  placeHolder: "没有商品, 请创建",
                  prepareOrderId: prepareOrderId,
                  notFoundAndCreate: true,
                  orderOperationalRequirements: orderOperationalRequirements,
                ));
            Get.to(() => ENRkdAddwaresPage(
                  orderId: instoreOrderId,
                  orderOperationalRequirements: orderOperationalRequirements,
                  fromScan: true,
                ));
          });
    }
  });
}
