// 已经废弃
import 'package:get/get.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class ENChuCangPageController extends GetxController {
  final String outStoreType;
  Map<String, List> orders = {'本地': [], '跨境': []}; //两种类型的出仓单.
  var alreadyMap = Map<String, List>();
  var pageNum = 1;
  var canMore = true.obs;
  var model = 0.obs;
  var crossBorderType = "本地".obs;

  ENChuCangPageController({this.outStoreType});
  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  requestDataList(
    outStoreType,
    crossBorderName,
  ) {
    var crossBorder;
    if (crossBorderName == "本地") {
      crossBorder = 0;
    } else {
      crossBorder = 1;
    }
    if (outStoreType == 'will') {
      print("获取待出库数据" + crossBorderName);
      HttpServices.enWillList(
          pageSize: 10,
          pageNum: pageNum,
          outStoreName: '',
          crossBorder: crossBorder,
          success: (data, total) {
            EasyLoadingUtil.hidden();
            if (data.length == total) {
              // 不可以加载更多
              print("不可以加载更多");
              canMore.value = false;
            } else {
              // 可以加载更多
              print("可以加载更多");
              canMore.value = true;
            }
            print(crossBorderName + "数据的长度为: " + data.length.toString());
            if (pageNum == 1) {
              orders[crossBorderName] = data;
            } else {
              orders[crossBorderName].addAll(data);
            }
          },
          error: (error) {
            EasyLoadingUtil.hidden();
            ToastUtil.showMessage(message: error.message);
          });
    }
    // if (outStoreType == 'already') {
    //   print("获取已出库数据" + crossBorderName);
    //   HttpServices.enAlreadyList(
    //       pageSize: 10,
    //       pageNum: pageNum,
    //       outStoreName: '',
    //       crossBorder: crossBorder,
    //       success: (data, total) {
    //         EasyLoadingUtil.hidden();
    //         if (data.length == total) {
    //           // 可以加载更多
    //           print("可以加载更多");
    //           canMore.value = false;
    //         } else {
    //           // 不可以加载更多
    //           print("不可以加载更多");
    //           canMore.value = true;
    //         }
    //         print("获取出库数据");
    //         if (pageNum == 1) {
    //           alreadyMap[crossBorderName] = data;
    //         } else {
    //           alreadyMap[crossBorderName].addAll(data);
    //         }
    //         alreadyMap[crossBorderName] = data;
    //       },
    //       error: (error) {
    //         EasyLoadingUtil.hidden();
    //         ToastUtil.showMessage(message: error.message);
    //       });
    // }
  }

  requestData() {
    EasyLoadingUtil.showLoading();
    requestDataList(outStoreType, crossBorderType.value);
  }

  void switchCrossBorder(newCrossBorderType) {
    if (newCrossBorderType != crossBorderType) {
      pageNum = 1;
      crossBorderType.value = newCrossBorderType;
      EasyLoadingUtil.showLoading();
      requestData();
    }
  }

  Future<void> onRefresh() async {
    pageNum = 1;
    requestData();
  }

  Future<void> onLoad() async {
    pageNum += 1;
    requestData();
  }
}
