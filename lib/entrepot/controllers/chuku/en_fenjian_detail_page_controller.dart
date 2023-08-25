import 'package:get/get.dart';
import 'package:wms/models/entrepot/en_sku_detail_model.dart';
import 'package:wms/models/entrepot/chuku/en_fenjian_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';

class ENFenJianDetailPageController extends GetxController {
  final num outOrderId;
  final Function afterSuccess;

  var dataModel = ENFenJianModel().obs;

  var skusList = RxList<ENSkusModel>();
  var imageList = RxList<String>();
  var commodityList = [];

  final hs = HttpServices();

  ENFenJianDetailPageController(this.outOrderId, {this.afterSuccess});

  @override
  void onInit() {
    super.onInit();
    skusList.value = [];

    requestData();
  }

  // 请求数据
  requestData() async {
    EasyLoadingUtil.showLoading();
    final res = await hs.enSortingDetail(outOrderId: outOrderId);
    dataModel.value = ENFenJianModel.fromJson(res);
    commodityList = res['spuDetailList'];
    EasyLoadingUtil.hidden();
    afterSuccess?.call();
    print("获得数据完毕 ${dataModel.value.outStoreName}");
  }

  Future<void> onRefresh() async {
    await requestData();
    print("刷新controller 数据");
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
  }
}
