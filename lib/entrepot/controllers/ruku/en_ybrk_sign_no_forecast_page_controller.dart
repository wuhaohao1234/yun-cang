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
import '../../pages/ruku/en_RuKuTabs.dart'; // 商品界面

class ENYbrkSignNoForecastPageController extends GetxController {
  final String mailNo;
  var itemsImages = RxList<File>(); //商品照片

  TextEditingController customerCode;
  TextEditingController boxTotalFact;

  var orderOperationalRequirements = 1.obs;

  var buttonContent = '确认签收，提交客户代码';

  ENYbrkSignNoForecastPageController(this.mailNo);

  @override
  void onInit() {
    super.onInit();

    customerCode = TextEditingController();
    boxTotalFact = TextEditingController();
    orderOperationalRequirements.value = 1;
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
            'customerCode': customerCode.text,
            'boxTotal': boxTotalFact.text,
            'instoreOrderImg': itemsPaths,
            'mailNo': mailNo,
            'orderOperationalRequirements': orderOperationalRequirements.value,
          };
          if (customerCode.text.length == 0) {
            buttonContent = '确认签收，生成无主单';
          }
          requestCommit(dataInfo);
        },
        error: (error) {
          EasyLoadingUtil.showMessage(message: error.message);
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
    print(customerCode.text);
    if (orderOperationalRequirements.value == null) {
      ToastUtil.showMessage(message: '请选择商品入库要求');
      return false;
    }
    if (boxTotalFact.text.length == 0) {
      ToastUtil.showMessage(message: '请输入商品数量');
      return false;
    }
    if (itemsImages.length == 0) {
      ToastUtil.showMessage(message: '请添加商品照片');
      return false;
    } else {
      if (customerCode.text.length == 0) {
        ToastUtil.showMessage(message: '请确认是否有客户代码');
        buttonContent = '确认签收，生成无主单';
        return true;
      }
      return true;
    }
  }

  changeorderOperationalRequirements(value) {
    orderOperationalRequirements.value = int.parse(value);
  }

  // 发送添加请求
  Future<void> requestCommit(data) async {
    print(data);

    if (customerCode.text.length != 0) {
      //有客户代码，待理货
      HttpServices.enSignNoForecastOrder(
          mailNo: this.mailNo,
          customerCode: customerCode.text,
          boxTotalFact: boxTotalFact.text,
          instoreOrderImg: data['instoreOrderImg'],
          orderOperationalRequirements: orderOperationalRequirements.value,
          success: (result) {
            print(result);
            EasyLoadingUtil.showMessage(message: "无预约签收成功");
            Get.to(() => ENRkdShPage(defaultIndex: 0));
          },
          error: (e) {
            print(e.message);
            EasyLoadingUtil.showMessage(message: e.message);
          });
    } else {
      HttpServices.enCreateWzd(
          mailNo: this.mailNo,
          ownerlessImg: data['instoreOrderImg'],
          boxTotalFact: int.parse(boxTotalFact.text),
          orderOperationalRequirements: orderOperationalRequirements.value,
          success: (result) {
            print(result);
            EasyLoadingUtil.showMessage(message: "无主单创建成功");
            Get.to(() => ENRkdShPage(defaultIndex: 0));
          },
          error: (e) {
            print(e.message);
            EasyLoadingUtil.showMessage(message: e.message);
          });
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
    customerCode?.dispose();
    boxTotalFact.dispose();
    EasyLoadingUtil.popHidden();
  }
}
