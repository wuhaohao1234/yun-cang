import 'package:get/get.dart';
import 'package:wms/models/storage/perpare_order_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:flutter/material.dart';

class CSYbrkDetailPageController extends GetxController {
  final String orderId;
  final String status;

  var dataModel = PerpareOrderModel().obs;
  var commodityList = [];
  var mailNo = TextEditingController();

  CSYbrkDetailPageController(this.orderId, this.status);

  @override
  void onInit() {
    super.onInit();
    EasyLoadingUtil.showLoading();
    var res = requestData();
  }

  // 请求数据
  void requestData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var data = await HttpServices().prepareOrderDetailList(
      orderId: orderId,
      status: status,
    );
    print(data);
    if (data == false) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: '未获取相关数据');
    }
    if (data != null) {
      print(data);

      dataModel.value = data;
      mailNo.text = dataModel.value.mailNo ?? '';
      commodityList = data.wmsCommodityInfoVOList;
      print(dataModel);

      EasyLoadingUtil.hidden();
    } else {}
  }

  Future<void> onRefresh() async {
    requestData();
  }

//修改快递单号
  onTapCommitHandle() async {
    if (mailNo.text == null || mailNo.text.length == 0) {
      EasyLoadingUtil.showMessage(message: '请添加快递单号');
      return false;
    }
    var data = await HttpServices().updPrepareOrder(
      orderId: dataModel.value.prepareOrderId,
      mailNo: mailNo.text ?? dataModel.value.mailNo, //修改后的单号,或者未修改前的单号
    );
    if (data != false) {
      requestData();
      EasyLoadingUtil.showMessage(message: '已提交并修改入库单号');
    }
  }
}
