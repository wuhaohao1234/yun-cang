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

class CSZiZhuCangAddCommodityPageController extends GetxController {
  var itemsImages = RxList<File>(); //商品照片
  // var dataInfo = Map<String, dynamic>();
  TextEditingController orderIdName;
  TextEditingController labelBarcode;
  TextEditingController size;
  TextEditingController commodityNumber;
  TextEditingController remark;
  TextEditingController stockCode;
  var sourcePlace = "0".obs;

  CSZiZhuCangAddCommodityPageController();

  @override
  void onInit() {
    super.onInit();
    orderIdName = TextEditingController();
    labelBarcode = TextEditingController();
    size = TextEditingController();
    commodityNumber = TextEditingController();
    remark = TextEditingController();
    stockCode = TextEditingController();
  }

  // 添加按钮点击事件
  Future<void> onTapCommitHandle() async {
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
            // 'orderIdName': orderIdName.text,
            'labelBarcode': labelBarcode.text,
            'size': size.text,
            'commodityNumber': commodityNumber.text,
            'remark': remark.text,
            'stockCode': stockCode.text,
            'picturePath': itemsPaths,
            'sourcePlace': int.parse(sourcePlace.value),
          };
          requestCommit(dataInfo);
          EasyLoadingUtil.showMessage(message: "添加商品成功");

          Get.back(result: {
            'commodityName': dataInfo['stockCode'],
            'stockCode': dataInfo['stockCode'],
            'picturePath': dataInfo['picturePath'],
            'brandName': '',
            'skuDataList': [
              {
                'commodityNumber': dataInfo['commodityNumber'],
                'skuId': null,
                'size': dataInfo['size'],
                'imgUrl': '',
              }
            ],
          });
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
    if (labelBarcode.text.length == 0 && stockCode.text.length == 0) {
      ToastUtil.showMessage(message: '请输入商品货号或者条形码');
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
    return true;
  }

  // 发送添加请求
  Future<void> requestCommit(data) async {
    print(data);
    var available = await HttpServices().entallyStockCode(
        stockCode: data['stockCode'], skuCode: data['labelBarcode']);
    if (!available) {
      EasyLoadingUtil.showMessage(message: "商品${data.labelBarCode}已存在");
      EasyLoadingUtil.hidden();
      return;
    }
    var res = await HttpServices().addVirtualSku(orderInfo: data);
    if (res == false) {
      EasyLoadingUtil.showMessage(message: "无法成功添加");
      return false;
    }
    if (res != null) {
      print(res);
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

//改变商品所在地
  void onChangeSourcePlace(String value) {
    sourcePlace.value = value;
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
