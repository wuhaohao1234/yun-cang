import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/common/basePage/wv_success.dart';
import 'package:wms/customer/storage/yichangdan/cs_ycd_out.dart';
// import 'package:wms/entrepot/pages/xcj_detail_page.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/models/storage/exception_list_detail_model.dart';
import 'package:wms/models/storage/sku_list_item.dart';
import 'package:wms/models/select_exception_sku_send_back_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class CSYcjDetailPageController extends GetxController {
  CSYcjDetailPageController(this.exceptionOrderId);

  final int exceptionOrderId;
  Rx<ExceptionListDetailModel> data = ExceptionListDetailModel().obs;

  // RxList<int> skuIds = [].obs;
  RxList<int> skuIds = RxList<int>([]);
  RxList<int> ids = RxList<int>([]);

  /// 被选择的列表数据
  RxList<SkuListItem> selectListData = RxList<SkuListItem>([]);
  RxList<SelectExceptionSkuSendBack> selectExceptionSkuSendBackData =
      RxList<SelectExceptionSkuSendBack>([]);

  /// _skuIds

  /// 地址
  AddressModel consigneeData;

  @override
  void onInit() {
    super.onInit();
    EasyLoadingUtil.showLoading();
    requestData();
  }

  void requestData() {
    HttpServices.exceptionListDetail(
        query: exceptionOrderId.toString(),
        success: (res) {
          print(res.toJson());
          // data.value = res;
          data(res);
          // data.update((val){
          //   val.exceptionOrderCode = 'sdfsdf';
          // });
          EasyLoadingUtil.hidden();
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  /// 选择
  void onSelectChanged() {
    List<SkuListItem> _from = new List.from(data.value.skuDetai.skus);
    selectListData.value =
        _from.where((element) => element.selected == true).toList();

    List<int> _skuIds = selectListData.map((e) => e.skuId).toList();

    selectListData.forEach((element) {
      print(element.toJson());
    });
    List<int> _ids = selectListData.map((e) => e.id).toList();
    // 赋值
    skuIds(_skuIds);
    ids(_ids);
  }

  /// 瑕疵件退回
  void selectExceptionSkuSendBack() {
    EasyLoadingUtil.showLoading();
    Map<String, dynamic> params = {"ids": ids};
    print('params $params');
    HttpServices.selectExceptionSkuSendBack(
      params: params,
      success: (res, total) {
        selectExceptionSkuSendBackData(res);
        Get.to(() => CsYcdOut());
        EasyLoadingUtil.hidden();
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  /// 设置地址
  void setConsignee(AddressModel v) {
    consigneeData = v;
    update();
  }

  /// 客户端app瑕疵件退回
  void exceptionSkuSendBackAndCommit() {
    // EasyLoadingUtil.showLoading();
    Map<String, dynamic> params = {
      "ids": ids,
      "userAdressId": consigneeData.id
    }; //"skuIds": skuIds,
    print('params $params');
    HttpServices.exceptionSkuSendBackAndCommit(
      params: params,
      success: (res) {
        // data(res);
        Get.to(() => SuccessPage(
              title: '瑕疵件退货已提交',
              content: Text(
                '待仓库发货',
                style: TextStyle(fontSize: 14.0, color: Color(0xff00CCCC)),
              ),
              /*button: OutlinedButton(
            onPressed: () {
              Get.to(()=>() => XcjDetailPage(id: data.value.exceptionOrderId));
            },
            child: Text(
              '查看订单',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),*/
            ));
        EasyLoadingUtil.hidden();
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
  }
}
