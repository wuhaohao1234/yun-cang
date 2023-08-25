import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wms/network/http_services.dart';

class CsKuCunManageController extends GetxController {
  RxList<List> detailList = <List>[[], []].obs;
  RxList<int> sizeCount = [0,0].obs;
  RxList<int> totalCount = [0,0].obs;

  getDetail({depotId, type, spuId, status}) async {
    var result = await HttpServices().csOnSaleDetail(depotId: depotId, type: type, status: status, spuId: spuId);
    detailList[status] = result["mySaleList"];
    sizeCount[status] = result["sizeCount"];
    totalCount[status] = result["totalCount"];
    update();
  }
}
