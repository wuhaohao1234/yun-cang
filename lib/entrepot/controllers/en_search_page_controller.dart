// 搜索页面
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/models/entrepot/ruku/en_rkd_model.dart';
import 'package:wms/models/entrepot/ruku/en_wzd_model.dart';
import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';
import 'package:wms/models/entrepot/ruku/en_ycd_model.dart';
import 'package:wms/models/entrepot/chuku/en_fenjian_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class ENSearchPageController extends GetxController {
  TextEditingController textC;

  var dataSource = RxList<ENYbrkModel>();
  var dataSource1 = RxList<ENRkdModel>();
  var dataSource2 = RxList<ENYcdModel>();
  var dataSource3 = RxList<ENWzdModel>();
  var dataSourceMail = RxList<ENYbrkModel>();
  var dataSourceFenJian = RxList<ENFenJianModel>();
  var dataSourceChuCang = RxList<dynamic>();
  var dataLength = 0.obs;
  var dataType = '';

  @override
  void onInit() {
    super.onInit();
    textC = TextEditingController();
  }

  void request(List<String> listType) {
    if (listType.contains('mail')) {
      print("mail");
      requestmMail();
    }

    if (listType.contains('1')) {
      requestYcd();
    }
    if (listType.contains('4')) {
      requestYbrkd();
    }
    //查询分拣单；
    if (listType.contains('outStoreName')) {
      print("fenjian");
      requestFenJianDan();
    }
    //查询出仓单；
    if (listType.contains('chucang')) {
      print("chucang");
      requestChuCangDan();
    }
    if (listType.contains('wzdMailNo')) {
      print("wuzhudan");
      requestWuZhuDan();
    }
  }

//搜物流单号
  void requestmMail() {
    EasyLoadingUtil.showLoading();
    HttpServices.enQueryByMailNo(
        mailNo: textC.text,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          dataSourceMail.value = data;
          // dataSourceMail.value =
          //     data.map((e) => ENYbrkModel.fromJson(e)).toList();
          dataLength.value = data.length;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
          dataLength.value = 0;
          // requestYbrkd();
        });
    if (dataLength.value == 0) {
      // requestRkd();
    }
  }

  // 搜预约入库单
  void requestYbrkd() {
    EasyLoadingUtil.showLoading();
    HttpServices.enPrepareOrderList(
        mailNo: textC.text,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          dataSource.value = data;
          dataLength.value = data.length;
          if (dataLength.value == 0) {
            requestRkd();
          }
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
    if (dataLength.value == 0) {
      requestRkd();
    }
  }

  // 搜入库单
  void requestRkd() {
    EasyLoadingUtil.showLoading();
    HttpServices.enInStoreOrderList(
        mailNo: textC.text,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          dataSource1.value = data;
          dataLength.value = data.length;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  // 搜异常单
  void requestYcd() {
    EasyLoadingUtil.showLoading();

    HttpServices.enExceptionOrderList(
        mailNo: textC.text,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          dataSource2.value = data;
          dataLength.value = data.length;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  // 搜无主单
  void requestWuZhuDan() async {
    EasyLoadingUtil.showLoading();
    var data = await HttpServices().enOwnerLessList(
      mailNo: textC.text,
      pageSize: 10,
      pageNum: 1,
    );
    if (data != null) {
      EasyLoadingUtil.hidden();
      dataSource.value = data;
      dataLength.value = data.length;
    }
    // HttpServices.wzdList(
    //     mailNo: textC.text,
    //     success: (data, total) {
    //       EasyLoadingUtil.hidden();
    //       dataSource.value = data;
    //       dataLength.value = data.length;
    //     },
    //     error: (error) {
    //       EasyLoadingUtil.hidden();
    //       ToastUtil.showMessage(message: error.message);
    //     });
  }

//搜索分拣单
  void requestFenJianDan() {
    EasyLoadingUtil.showLoading();
    HttpServices.enSortingList(
        transportType: 5,
        outStoreName: textC.text,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          dataSourceFenJian.value = data;
          dataLength.value = data.length;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
    //获取自提数据
    // HttpServices.enSortingList(
    //     transportType: 6,
    //     outStoreName: textC.text,
    //     success: (data, total) {
    //       EasyLoadingUtil.hidden();

    //       print("获取分拣数据:自提 $data");
    //       dataSourceFenJian.value = data;
    //       dataLength.value = data.length;
    //     },
    //     error: (error) {
    //       EasyLoadingUtil.hidden();
    //       ToastUtil.showMessage(message: error.message);
    //     });
    //获取车送数据
    // HttpServices.enSortingList(
    //     transportType: 7,
    //     outStoreName: textC.text,
    //     success: (data, total) {
    //       EasyLoadingUtil.hidden();
    //       print("获取分拣数据:车送 $data");
    //       dataSourceFenJian.value = data;
    //       dataLength.value = data.length;
    //     },
    //     error: (error) {
    //       EasyLoadingUtil.hidden();
    //       ToastUtil.showMessage(message: error.message);
    //     });
  }

  Future<void> requestChuCangDan() async {
    EasyLoadingUtil.showLoading();

    final res = await HttpServices().enWillOrAlreadyList(
        outStoreType: 'will',
        pageNum: null,
        crossBorder: 0,
        pageSize: 10,
        outStoreName: textC.text);

    EasyLoadingUtil.hidden();
    dataSourceChuCang.value = res["data"];
    dataLength.value = res["total"];

    EasyLoadingUtil.hidden();
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
    textC?.dispose();
  }
}
