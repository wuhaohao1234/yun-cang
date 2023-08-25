// 出仓-车送单controller
import 'package:get/get.dart';
import 'package:wms/models/entrepot/chuku/en_fenjian_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/configs/app_config.dart';

class ENFenJianCheSongPageController extends GetxController {
  final String outStoreName;

  var dataSource = RxList<ENFenJianModel>();
  num pageNum = 1;
  var canMore = true.obs;

  ENFenJianCheSongPageController(this.outStoreName);

  @override
  void onInit() {
    super.onInit();
    EasyLoadingUtil.showLoading();
    requestData();
  }

  requestData() {
    //获取快递数据
    HttpServices.enSortingList(
        transportType: 7,
        pageSize: AppConfig.pageSize,
        pageNum: pageNum,
        outStoreName: outStoreName,
        success: (data, total) {
          if (pageNum == 1) {
            dataSource.value = data;
          } else {
            dataSource.addAll(data);
          }

          if (dataSource.length == total) {
            // 可以加载更多
            canMore.value = false;
          } else {
            // 不可以加载更多
            canMore.value = true;
          }
          print("共计 $total, 目前${dataSource.length}");
          EasyLoadingUtil.hidden();
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  Future<void> onRefresh() async {
    pageNum = 1;
    requestData();
  }

  Future<void> onLoad() async {
    if (canMore.value) {
      pageNum += 1;
      EasyLoadingUtil.showMessage(message: "加载更多");
      await requestData();
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }
}
