import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class CsStSearchPageController extends GetxController {
  TextEditingController textC;

  var dataSource = RxList<ENYbrkModel>();

  @override
  void onInit() {
    super.onInit();
    textC = TextEditingController();
  }

  // 搜预约入库单
  void requestYbrkd(String mailNo) {
    EasyLoadingUtil.showLoading();
    HttpServices.enQueryByMailNo(
        mailNo: mailNo,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          dataSource.value = data;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  // 搜入库单
  void requestRkd(String mailNo) {
    EasyLoadingUtil.showLoading();
    HttpServices.enQueryByMailNo(
        mailNo: mailNo,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          dataSource.value = data;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  // 搜异常单
  void requestYcd(String mailNo) {
    EasyLoadingUtil.showLoading();
    HttpServices.enQueryByMailNo(
        mailNo: mailNo,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          dataSource.value = data;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  // 搜无主单
  void requestWzd(String mailNo) {
    EasyLoadingUtil.showLoading();
    HttpServices.enQueryByMailNo(
        mailNo: mailNo,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          dataSource.value = data;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  @override
  void onClose() {
    super.onClose();
    textC?.dispose();
  }
}
