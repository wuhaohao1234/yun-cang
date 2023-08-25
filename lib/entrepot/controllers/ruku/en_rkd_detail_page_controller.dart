// 理货详情页面controller

import 'package:get/get.dart';
import 'package:wms/entrepot/pages/ruku/qianshou/en_ybrk_detail_page.dart';
import 'package:wms/models/entrepot/ruku/en_rkd_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class ENRkdDetailPageController extends GetxController {
  final num instoreOrderId;
  final num prepareOrderId;
  final Function afterSuccess;

  var imageList = RxList<String>();
  RxList commodityList = [].obs;
  var newCommodityList = [];
  var inspectionRequirement = "0";
  var dataInfo = ENRkdModel();
  var data = {};

  ENRkdDetailPageController(this.instoreOrderId, this.prepareOrderId,
      {this.afterSuccess});

  @override
  void onInit() {
    super.onInit();
    print("ENRkdDetailPageController init");
    EasyLoadingUtil.showLoading();
    requestData();
  }

  // 请求数据
  requestData() {
    // 获取理货详情
    print("获取 prepareOrderId=$prepareOrderId 的理货详情");

    HttpServices.getTallyDetail(
        sysPrepareOrderId: prepareOrderId,
        success: (data) {
          // 获取入库单相关信息
          commodityList.clear();
          update();
          dataInfo = ENRkdModel.fromJson({
            'instoreOrderId': data['instoreOrderId'],
            'instoreOrderCode': data['instoreOrderCode'],
            'prepareOrderId': data['prepareOrderId'],
            'boxTotal': data['boxTotal'],
            'skusTotalFact': data['skusTotalFact'],
            'boxTotalFact': data['boxTotalFact'],
            'skusTotal': data['skusTotal'],
            'orderOperationalRequirements':
                data['orderOperationalRequirements'],

            // 上架部分
            'depotPosition': data['depotPosition'],
            'userCode': data['userCode'],
            'spuNumber': data['spuNumber'],
            'mailNo': data['mailNo']
          });
          inspectionRequirement=data['inspectionRequirement'];
          // 获取商品列表信息
          commodityList.value = data['wmsCommodityInfoVOList'];
          data['wmsCommodityInfoVOList'].forEach((item){
            item['sysPrepareOrderSpuList']?.forEach((spu){
              print("spu -- ${spu}");
              spu['sysPrepareSkuList']?.forEach((sku){
                print("sku ++ ${sku}");
              });

            }) ;
          });
          newCommodityList = data['busNewOrders'];
          // 后处理
          afterSuccess?.call();
          EasyLoadingUtil.hidden();
          data = data;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  // void showBottomSheets(BuildContext context) {
  //   WMSBottomSheet.showRkdDetailOptionsSheet(
  //     context,
  //     callback: (index) {
  //       switch (index) {
  //         case 0:
  //           obTapModifyRkd();
  //           break;
  //         case 1:
  //           // obTapYbrk();
  //           break;
  //       }
  //     },
  //   );
  // }

  // 跳转到修改入库单页面
  // void obTapModifyRkd() {
  //   Get.to(()=>
  //     () => ENModifyRkdPage(
  //       dataModel: dataModel.value,
  //     ),
  //   ).then((value) {
  //     if (value == true) {
  //       requestData();
  //     }
  //   });
  // }

  // 跳转预约入库
  void obTapYbrk() {
    Get.to(() => ENYbrkDetailPage(
          orderId: instoreOrderId,
        ));
  }

  Future<void> onRefresh() async {
    requestData();
    print("刷新controller 数据");
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
  }
}
