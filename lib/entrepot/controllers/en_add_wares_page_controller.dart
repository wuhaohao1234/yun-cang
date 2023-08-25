import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wms/common/pages/wms_camera_page.dart';
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/customer/storage/scan_test_page.dart';
import 'package:wms/models/oss_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class ENAddWaresPageController extends GetxController {
  final num orderId;
  // final List wmsCommodityInfoVOList;//Huzi:暂时移除,看不到使用必要性
  var itemsImages = RxList<File>(); //商品照片
  // var dataInfo = Map<String, dynamic>();

  TextEditingController labelBarcode;
  TextEditingController size;
  TextEditingController commodityNumber;
  TextEditingController remark;
  TextEditingController stockCode;

  ENAddWaresPageController(
    this.orderId,
    // this.wmsCommodityInfoVOList
  );

  @override
  void onInit() {
    super.onInit();

    labelBarcode = TextEditingController();
    size = TextEditingController();
    commodityNumber = TextEditingController();
    remark = TextEditingController();
    stockCode = TextEditingController();
  }

  // 添加按钮点击事件
  void onTapCommitHandle() async {
    if (checkInput() == false) {
      return;
    }
    // EasyLoadingUtil.showLoading();
    HttpServices.requestOss(
        dir: AppGlobalConfig.imageType3,
        success: (data) async {
          var itemsPaths =
              await uploadImagesList(imageList: itemsImages, ossModel: data);
          print('开始提交数据');
          print('itemsPaths = $itemsPaths');
          var dataInfo = {
            'stockCode': stockCode.text,
            'labelBarcode': labelBarcode.text,
            'size': size.text,
            'orderId': orderId,
            'commodityNumber': commodityNumber.text,
            'remark': remark.text,
            'picturePath': itemsPaths,
          };
          requestCommit(dataInfo);

          Get.back();
          // Get.back(
          //     result: wmsCommodityInfoVOList.add({
          //   commodityNumber: dataInfo['commodityNumber'],
          // }));
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
    print(labelBarcode.text);
    if (labelBarcode.text.length == 0) {
      ToastUtil.showMessage(message: '请输入条形码');
      return false;
    }
    if (commodityNumber.text.length == 0) {
      ToastUtil.showMessage(message: '请输入商品数量');
      return false;
    }
    if (size.text.length == 0) {
      size.text = 'OS';
      ToastUtil.showMessage(message: '尺寸默认为OS');
      return true;
    }
    if (itemsImages.length == 0) {
      ToastUtil.showMessage(message: '请添加商品照片');
      return false;
    }
  }

  // 发送添加请求
  Future<void> requestCommit(data) async {
    print(data);
    var available = await HttpServices().entallyStockCode(
        stockCode: data["stockCode"], skuCode: data["labelBarcode"]);
    if (!available) {
      EasyLoadingUtil.showMessage(message: "商品${data['labelBarcode']}已存在");
      EasyLoadingUtil.hidden();
      return;
    }
    var res = await HttpServices().enAddNewOrder(orderInfo: data);
    if (res != null) {
      print(res);
      EasyLoadingUtil.showMessage(message: "添加商品成功");
    }
  }

  // 扫码条形码
  Future<void> onTapScanBarcode() async {
    await Permission.camera.request();
    Get.to(() => ScanTestPage()).then((value) {
      if (value != null) {
        labelBarcode.text = value;
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
    labelBarcode?.dispose();
    size.dispose();
    commodityNumber.dispose();
    remark.dispose();
    stockCode.dispose();
    EasyLoadingUtil.popHidden();
  }
}
