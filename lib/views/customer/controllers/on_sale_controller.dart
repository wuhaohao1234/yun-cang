import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:wms/configs/app_config.dart';
import 'package:wms/configs/wv_tool.dart';
import 'package:wms/models/order/order_model.dart';
import 'package:wms/models/storage/onsale_commodity_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';

/// Create by bigv on 21-7-14
/// Description:

class OnSaleController extends GetxController {
  RxString searchStr = "".obs;
  RxInt pageNum = 1.obs;
  RxBool canMore = false.obs;
  RxList<List<OnSaleCommodityModel>> onSaleList = <List<OnSaleCommodityModel>>[[],[],[]].obs;

  setSearchStr({String str}) {
    searchStr.value = str;
    update();
  }

  setPageNum({int num}) {
    pageNum.value = num;
    update();
  }

  Future<bool> requestData({int type,int index}) async {
    print("widget.search Str ${searchStr}");
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().csOnSaleList(
      pageSize: AppConfig.pageSize,
      pageNum: pageNum.value,
      type: type,
      searchStr: searchStr.value,
    );
    final data = res["data"];
    final total = res["total"];
    if (pageNum.value == 1) {
      onSaleList[index].clear();
      onSaleList[index] = data;
    } else {
      onSaleList[index].addAll(data);
    }
    if (onSaleList[index].length == total) {
      // 可以加载更多
      canMore.value = false;
    } else {
      // 不可以加载更多
      canMore.value = true;
    }
    print("共计 $total, 目前${onSaleList[index].length}");
    update();
    EasyLoadingUtil.hidden();
  }
}
