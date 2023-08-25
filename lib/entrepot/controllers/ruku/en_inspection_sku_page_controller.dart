import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wms/common/pages/wms_camera_page.dart';
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/customer/storage/scan_test_page.dart';
import 'package:wms/models/oss_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class ENInspectionSKuPageController extends GetxController {
  final String orderId;

  var itemsState = 0.obs; // 0 正常  1 瑕疵
  var itemSize = ""; //
  var itemsImages = RxList<File>(); //商品照片

  TextEditingController skucodeC;
  TextEditingController sncodeC;
  ENInspectionSKuPageController(this.orderId);

  @override
  void onInit() {
    super.onInit();

    skucodeC = TextEditingController();
    sncodeC = TextEditingController();
    skucodeC.text = "test";
    sncodeC.text = "test";
  }

  void changeItemsState(int value) {
    itemsState.value = value;
  }

  void setItemSize(size) {
    //为什么数据不更新？buildSizeWdidget(pageController),
    itemSize = size;
    print(itemSize);
    return;
  }

  // 添加按钮点击事件
  void onTapCommitHandle() async {
    if (checkInput() == false) {
      return;
    }
    EasyLoadingUtil.showLoading();

    HttpServices.requestOss(
        dir: AppGlobalConfig.imageType3,
        success: (data) async {
          var itemsPaths =
              await uploadImagesList(imageList: itemsImages, ossModel: data);
          print('开始提交数据');
          print('itemsPaths = $itemsPaths');
          requestCommit();
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          print(error.toString());
        });

    // 上传商品照片
  }

  // 上传照片
  Future<String> uploadImagesList(
      {List<File> imageList, OssModel ossModel}) async {
    String imagesPath = '';
    for (int i = 0; i < imageList.length; i++) {
      String path = await HttpServices.asyncUpLoadImage(
        model: ossModel,
        file: imageList[i],
      );
      imagesPath += path;
      imagesPath += ';';
    }
    return imagesPath.substring(0, imagesPath.length - 1);
  }

  bool checkInput() {
    if (sncodeC.text.length == 0) {
      ToastUtil.showMessage(message: '请输入SN码');
      return false;
    }
    if (skucodeC.text.length == 0) {
      ToastUtil.showMessage(message: '请输入SKU码');
      return false;
    }

    if (itemsImages.length == 0) {
      ToastUtil.showMessage(message: '请添加商品照片');
      return false;
    }
    return true;
  }

  // 发送添加请求
  requestCommit({
    String sysPrepareOrderId,
    List sysPrepareOrderSpuList,
  }) {
    HttpServices.inspectionComplete(
        // spuId: spuId,
        // skuId: skuId,
        // spuFlaw: spuFlaw,
        // skuCode: skucodeC.text,
        // snCode: sncodeC.text,
        // defectiveImg: defectiveImg,
        success: (data) {
      EasyLoadingUtil.hidden();
      ToastUtil.showMessage(message: '添加成功');
      // ENSkusModel model = ENSkusModel(
      //   id: int.parse(orderId),
      //   barCode: sncodeC.text,
      //   skuCode: skucodeC.text,
      //   status: itemsState,
      // );

      // print('商品' + model.toJson().toString());
      // Get.back(result: model);
    }, error: (error) {
      EasyLoadingUtil.hidden();
      ToastUtil.showMessage(message: error.message);
    });
  }

  // 扫码条形码
  Future<void> onTapScanBarcode() async {
    await Permission.camera.request();
    Get.to(() => ScanTestPage()).then((value) {
      if (value != null) {
        sncodeC.text = value;
      }
    });
    // String barcode = await scanner.scan();
    // if (barcode == null) {
    //   print('nothing return.');
    //   ToastUtil.showMessage(message: '识别失败');
    // } else {
    //   print('barcode == ${barcode}');
    //   barcodeC.text = barcode;
    // }
  }

// 扫码SKU码
  Future<void> onTapScanSKUcode() async {
    await Permission.camera.request();
    Get.to(() => ScanTestPage()).then((value) {
      if (value != null) {
        skucodeC.text = value;
      }
    });
    // String barcode = await scanner.scan();
    // if (barcode == null) {
    //   print('nothing return.');
    //   ToastUtil.showMessage(message: '识别失败');
    // } else {
    //   print('barcode == ${barcode}');
    //   skucodeC.text = barcode;
    // }
  }

// 添加商品照片
  void onTapAddItemsImage() {
    Get.to(() => WMSCameraPage()).then((value) {
      List temp = value;
      temp.forEach((element) {
        itemsImages.add(element);
      });
    });
  }

// 删除商品照片
  void onTapDelItemsImage(int index) {
    if (itemsImages.length > 0) {
      itemsImages.removeAt(index);
    }
  }

  @override
  void onClose() {
    super.onClose();
    sncodeC?.dispose();
    skucodeC?.dispose();
    EasyLoadingUtil.popHidden();
  }
}
