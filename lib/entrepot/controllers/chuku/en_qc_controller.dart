import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wms/common/pages/wms_camera_page.dart';
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/models/oss_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';

class ENQcController extends GetxController {
  var itemsImages = RxList<File>(); // 商品照片
  RxList flawLevelSelected = [].obs;
  RxString snCode = "".obs;
  RxBool spuFlaw = true.obs;

  // RxString flawLevelSelected = "".obs;
  RxString remark = "".obs;

  dynamic model;
  int modelIndex = 0;

  initController(model, modelIndex) {
    this.model = model;
    this.modelIndex = modelIndex;
    print("modelIndex${modelIndex}");
    print("model${model}");
    update();
  }

  changeSnCode(value) {
    this.snCode.value = value;
    update();
  }

  changeRemark(value) {
    this.remark.value = value;
    update();
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

  void setStatus(value) {
    this.spuFlaw.value = value;
    update();
  }

  void changeFlawLevel(value) {
    var index = flawLevelSelected.indexWhere((element) => element == value);
    if (index != -1) {
      flawLevelSelected.removeAt(index);
    } else {
      flawLevelSelected.add(value);
    }
    update();
  }

  cleanForm() {
    modelIndex = 0;
    model = "";
    snCode.value = "";
    itemsImages.value = [];
    spuFlaw.value = true;
    flawLevelSelected.value = [];
    remark.value = "";
  }

  Future submitPostInfo() async {
    print("model-----${model}");
    EasyLoadingUtil.showLoading(statusText: "确认提交信息...");
    if (snCode.value != '') {
      print("首先上传照片");
      final imagePaths = await uploadQianShouImages();
      // 上传图片URL到服务器 并且签收
      await inspectionComplete(imagePaths);
      itemsImages.value = [];
    }

    // if (widget.orderOperationalRequirements == 1) {
    //   //理货点数
    //   // 上传图片URL到服务器 并且签收
    //   await noInspectionComplete();
    //   lihuoFinished = true;
    // }
    EasyLoadingUtil.hidden();

    EasyLoadingUtil.showMessage(message: "提交完成");
    return true;
    // EasyLoadingUtil.showMessage(message: "提交理货信息错误");
  }

  //签收(质检)
  Future inspectionComplete(String imgPaths) async {
    Completer completer = new Completer();

    var spuList = [
      {
        'spuId': model['sysPrepareOrderSpuList'][modelIndex]['spuId'],
        'skuId': model['sysPrepareOrderSpuList'][modelIndex]['skuId'],
        'spuFlaw': spuFlaw.value ? 0 : 1, //0 为正常，1为瑕疵。默认为false，0
        'skuCode': model['sysPrepareOrderSpuList'][modelIndex]['skuCode'] ?? "",
        'snCode': snCode.value,
        'defectiveImg': imgPaths,
        'defectDegree': spuFlaw.value ? "" : flawLevelSelected.join(","),
        'remark': remark.value
      }
    ];
    HttpServices.inspectionComplete(
        sysPrepareOrderId: model['sysPrepareOrderSpuList'][modelIndex]['sysPrepareOrderId'],
        sysPrepareOrderSpuList: spuList,
        success: (data) {
          cleanForm();

          completer.complete(data);
          return data;
        },
        error: (e) {
          print(e.message);
          //显示修改信息
          EasyLoadingUtil.showMessage(message: e.message);
        });
    return completer.future;
  }

  // 上传入库单图片
  uploadQianShouImages() async {
    String imagePaths = '';
    if (itemsImages.length == 0) {
      return imagePaths;
    }
    EasyLoadingUtil.showLoading(statusText: "上传照片中...");

    final ossObj = await getOssObj();
    for (int i = 0; i < itemsImages.length; i++) {
      String imgUrl = await uploadImageAsync(ossObj, itemsImages[i]);
      print("第 $i 张照片上传成功");
      imagePaths += imgUrl;
      if (i < itemsImages.length - 1) {
        imagePaths += ";";
      }
    }
    EasyLoadingUtil.hidden();
    return imagePaths;
  }

  Future getOssObj() async {
    Completer completer = new Completer();
    HttpServices.requestOss(
        dir: AppGlobalConfig.imageType3,
        success: (data) {
          completer.complete(data);
        });
    return completer.future;
  }

  Future uploadImageAsync(OssModel model, File image) async {
    Completer completer = new Completer();
    HttpServices.upLoadImage(
        file: image,
        model: model,
        success: (imgUrl) {
          completer.complete(imgUrl);
        },
        error: (data) {
          completer.completeError(data);
        });
    return completer.future;
  }
}
