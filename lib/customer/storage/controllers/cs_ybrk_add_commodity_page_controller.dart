import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wms/common/pages/wms_camera_page.dart';
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/customer/storage/scan_test_page.dart';
import 'package:wms/models/oss_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class CSYbrkAddCommodityPageController extends GetxController {
  final List commodityList;
  final String orderIdName;
  var itemsImages = RxList<File>(); //商品照片
  // var dataInfo = Map<String, dynamic>();
  TextEditingController labelBarCode;
  TextEditingController size;
  TextEditingController commodityNumber;
  TextEditingController remark;
  TextEditingController stockCode;

  CSYbrkAddCommodityPageController(this.commodityList, this.orderIdName);

  @override
  void onInit() {
    super.onInit();
    labelBarCode = TextEditingController();
    size = TextEditingController();
    commodityNumber = TextEditingController();
    remark = TextEditingController();
    stockCode = TextEditingController();
  }

  // 添加按钮点击事件
  Future<void> onTapCommitHandle() async {
    // if (checkInput() == false) {
    //   return;
    // }
    // EasyLoadingUtil.showLoading();
    HttpServices.requestOss(
        dir: AppGlobalConfig.imageType3,
        success: (data) async {
          var itemsPaths =
              await uploadImagesList(imageList: itemsImages, ossModel: data);
          print('开始提交数据');
          print('itemsPaths = $itemsPaths');
          var dataInfo = {
            'labelBarcode': labelBarCode.text,
            'size': size.text,
            'commodityNumber': commodityNumber.text == ''
                ? 0
                : int.parse(commodityNumber.text),
            'picturePath': itemsPaths,
            'remark': remark.text,
            'stockCode': stockCode.text,
            'orderIdName': this.orderIdName != '' ? this.orderIdName : null,
          };
          var orderIdName = await requestCommit(dataInfo);
          EasyLoadingUtil.showMessage(message: "添加商品成功");
          var resCommodityList = await HttpServices().csGetSku(
            orderIdName: orderIdName,
            pageNum: 0,
            pageSize: 10000,
          );
          if (resCommodityList != null) {
            final data = resCommodityList[0];
            Get.back(result: data);
          } else {
            Get.back();
          }
          // Get.back(result: {
          //   'commodityName': dataInfo['stockCode'],
          //   'stockCode': dataInfo['stockCode'],
          //   'picturePath': dataInfo['picturePath'],
          //   'orderIdName': orderIdName,
          //   'skuDataList': [
          //     {
          //       'stockCode': dataInfo['stockCode'],
          //       'commodityNumber': dataInfo['commodityNumber'],
          //       'uuid': null,
          //       'skuId': null,
          //       'skuCode': dataInfo['stockCode'],
          //       'size': dataInfo['size'],
          //       'remark': dataInfo['remark']
          //     }
          //   ],
          // });
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
    return imagesPath == ''
        ? imagesPath
        : imagesPath.substring(0, imagesPath.length - 1);
  }

  bool checkInput() {
    print(labelBarCode.text);
    if (labelBarCode.text.length == 0 && stockCode.text.length == 0) {
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
  Future<String> requestCommit(data) async {
    print(data);
    var available = await HttpServices().entallyStockCode(
        stockCode: data['stockCode'], skuCode: data['labelBarcode']);
    if (!available) {
      EasyLoadingUtil.showMessage(message: "商品${data['labelBarcode']}已存在");
      EasyLoadingUtil.hidden();
    }
    var res = await HttpServices().csAddNewOrder(orderInfo: data);
    print(res);
    if (res != null) {
      print(res);
    }
    return res['orderIdName'] ?? null;
  }

  // 扫码条形码
  Future<void> onTapScanBarcode() async {
    await Permission.camera.request();
    Get.to(() => ScanTestPage()).then((value) {
      if (value != null) {
        labelBarCode.text = value;
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
  void onTapAddItemsImage() async {
    var _picker = ImagePicker();
    await showModalBottomSheet(
        context: Get.context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("相机"),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => WMSCameraPage()).then((value) {
                    List temp = value;
                    temp.forEach((element) {
                      itemsImages.add(element);
                    });
                  });
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("相册"),
                onTap: () async {
                  PickedFile image =
                      await _picker.getImage(source: ImageSource.gallery);
                  itemsImages.add(File(image.path));
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text("取消"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
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
    labelBarCode?.dispose();
    size.dispose();
    commodityNumber.dispose();
    remark.dispose();
    stockCode.dispose();
    EasyLoadingUtil.popHidden();
  }
}
