import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wms/common/pages/wms_camera_page.dart';
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/models/oss_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class ENChuCangCellController extends GetxController {
  final int wmsOutStoreId;
  final int skuTotal;
  var itemsImages = RxList<File>(); //商品照片
  List<File> images = [];
  var itemsPaths = '';
  TextEditingController expressNumber = TextEditingController();
  TextEditingController pickUpCode = TextEditingController();

  ENChuCangCellController(this.wmsOutStoreId, this.skuTotal);

  @override
  void onInit() {
    super.onInit();
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
          itemsPaths =
              await uploadImagesList(imageList: itemsImages, ossModel: data);
          print('开始提交数据');
          print('itemsPaths = $itemsPaths');
          return itemsPaths;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          print(error.toString());
        });
    var dataInfo = {
      'wmsOutStoreId': wmsOutStoreId ?? 0,
      'skuTotal': skuTotal ?? 0,
      'expressNumber': expressNumber.text,
      'outOrderImg': itemsPaths ?? "",
      'outSkuOrderImg': itemsPaths ?? "",
      'pickUpCode': pickUpCode.text ?? "",
    };
    requestCommit(dataInfo);

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
    if (itemsImages.length != 0 ||
        pickUpCode.text.length != 0 ||
        expressNumber.text.length != 0) {
      ToastUtil.showMessage(message: '已填写信息');
      return true;
    } else {
      return false;
    }
  }

  // 发送添加请求
  Future<void> requestCommit(dataInfo) async {
    if (pickUpCode.text.length != 0 ||
        expressNumber.text.length != 0 ||
        itemsPaths != '') {
      var data = await HttpServices().enOutStore(
        wmsOutStoreId: dataInfo['wmsOutStoreId'],
        skuTotal: dataInfo['skuTotal'],
        expressNumber: expressNumber.text,
        outOrderImg: dataInfo['outOrderImg'],
        outSkuOrderImg: dataInfo['outSkuOrderImg'],
        pickUpCode: pickUpCode.text ?? "",
      );
      if (data == false) {
        ToastUtil.showMessage(message: '请确认是否输入信息');
      }
    } else {
      ToastUtil.showMessage(message: '请确认是否输入信息');
    }
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
    EasyLoadingUtil.popHidden();
  }
}
