import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_dialog.dart';
import 'package:wms/models/storage/wzd_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class CSWzjDetailPageController extends GetxController {
  final int id;

  CSWzjDetailPageController(this.id);

  var dataModel = WzdModel().obs;
  var btnable = true.obs;
  var btnTitle = '认领'.obs;

  @override
  void onInit() {
    super.onInit();
    EasyLoadingUtil.showLoading();
    requestData();
  }

  // 请求数据
  void requestData() {
    HttpServices.wzdDetail(
        id: id,
        success: (data) {
          EasyLoadingUtil.hidden();
          dataModel.value = data;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  void onTapCommitHandle(BuildContext context) {
    WMSDialog.showCourierNumberInptDialog(context, (code) {
      requestUserClaimOwnerLessSysPrepareOrder(code);
    });
  }

  // 发送认领请求
  void requestUserClaimOwnerLessSysPrepareOrder(String code) {
    EasyLoadingUtil.showLoading();
    HttpServices.userClaimOwnerLessSysPrepareOrder(
        id: id,
        lastFourCode: code,
        success: (result) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: '认领成功');
          btnable.value = false;
          btnTitle.value = '已认领';
          Get.back();
          Get.back(result: true);
        },
        error: (e) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: e.message);
        });
  }
}
