// 扫描结果
import 'package:get/get.dart';
import 'package:wms/entrepot/pages/old/en_create_wzd_page.dart.old';
import 'package:wms/entrepot/pages/old/en_create_ybrkd_page.dart.old';

class ENScanResultPageController extends GetxController {
  final String mailNo;

  ENScanResultPageController(this.mailNo);

  // 生成预约入库单
  void onTapCreateYbrkHandle() {
    Get.to(() => ENCreateYbrkdPage(
          mailNo: mailNo,
        ));
  }

  // 生成 无主单
  void onTapCreateWzdHandle() {
    Get.to(() => ENCreateWzdPage(
          mailNo: mailNo,
        ));
  }
}
