import 'package:get/get.dart';
import 'package:wms/models/market/market_wares_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class CSKcSubPageController extends GetxController {
  final int categoryId;
  var dataSource = RxList<MarketWaresModel>();

  CSKcSubPageController(this.categoryId);

  @override
  void onInit() {
    super.onInit();
    print('categoryId =  $categoryId');
    EasyLoadingUtil.showLoading();

    requestData();
  }

  void requestData() {
    HttpServices.getInventoryList(
      pageSize: 10,
      pageNum: 1,
      categoryId: categoryId,
      success: (data, total) {
        EasyLoadingUtil.hidden();
        List<MarketWaresModel> _data = data.map((e) {
          e.categoryId = categoryId;
          return e;
        }).toList();
        dataSource.value = _data;

        dataSource.forEach((element) {
          print(element.toJson());
        });
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  // 渲染对应 钩子
  bool isSelected(
      Map<int, List<MarketWaresModel>> selectCommodityData, int qty) {
    Map<int, List<MarketWaresModel>> _data = selectCommodityData;
    if (_data == null) {
      return false;
    }
    // print('_data $_data');
    List<int> keys = _data.keys.toList();
    // print('keys $keys');
    List<bool> _selected = [];
    for (var _k in keys) {
      _data[_k].forEach((element) {
        if (element.selected == true) {
          _selected.add(true);
        }
      });
    }

    if (_selected.length == qty) {
      return true;
    } else if (_selected.length == 0) {
      return false;
    }

    return null;
  }

  Future<void> onRefresh() async {
    requestData();
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.hidden();
  }
}
