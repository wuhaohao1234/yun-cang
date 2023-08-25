import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wms/common/baseWidgets/wms_bottom_sheet.dart';
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/event_bus_util.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/utils/wms_check_util.dart';

class CSAddAddressPageController extends GetxController {
  TextEditingController nameController;
  TextEditingController idController;
  TextEditingController phoneController;
  TextEditingController areaController;
  TextEditingController addressController;

  final AddressModel addressModel;

  var province = ''.obs; // 省
  var city = ''.obs; // 市
  var area = ''.obs; // 区
  var image1 = ''.obs; // 正面
  var image2 = ''.obs;

  CSAddAddressPageController(this.addressModel); // 反面

  setAddressModel(AddressModel model) {
    // addressModel = model;
    nameController.text = model.userName;
    idController.text = model.cardNum;
    phoneController.text = model.userPhone;
    addressController.text = model.userAddress;
    areaController.text = model.province + model.city + model.area;
    province.value = model.province;
    city.value = model.city;
    area.value = model.area;
    image1.value = addressModel.cardJust ?? '';
    image2.value = addressModel.cardBack ?? '';
  }

  var isDefalut = true.obs;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    idController = TextEditingController();
    phoneController = TextEditingController();
    areaController = TextEditingController();
    addressController = TextEditingController();
    if (addressModel != null) {
      setAddressModel(addressModel);
    }

    EventBusUtil.getInstance().on<SelectedArea>().listen((event) {
      if (event.area != null) {
        print('更新用户数据');
        province.value = event.area['province'];
        city.value = event.area['city'];
        area.value = event.area['area'];
      }
    });
  }

  // 保存按钮点击事件处理
  void onTapSaveHandle(bool isAdd) {
    if (isAdd) {
      print('添加');
      requestAdd();
    } else {
      print('保存');
      requestSave();
    }
  }

  // 省市区点击事件处理
  void onTapSelectAddressHandle(BuildContext context) {
    WMSBottomSheet.showAreaSheet(context);
  }

  // Switch 点击事件
  void onTapSwitchHandle(value) {
    isDefalut.value = value;
  }

  /*
  * userName      收件人名称
  * userphone     收件人电话
  * province      省名称
  * city          市名称
  * area          区县名称
  * useraddress   详细地址
  * isdefault     是否默认地址 0：否 1：是
  * dataflag      有效状态 0：无效 1：有效
  * cardNum      身份证号码
  * */

  // 发送网络请求  新增地址
  void requestAdd() {
    if (checkInput() == false) return;
    EasyLoadingUtil.showLoading();
    HttpServices.addAddress(
        userName: nameController.text,
        userPhone: phoneController.text,
        province: province.value,
        city: city.value,
        area: area.value,
        cardJust: image1.value,
        cardBack: image2.value,
        cardNum: idController.text,
        userAddress: addressController.text,
        isdefault: isDefalut.value ? 1 : 0,
        success: () {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: '保存成功');
          Get.back(result: true);
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  // 校验输入
  bool checkInput() {
    if (nameController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入姓名');
      return false;
    }
    // if(idController.text.length == 0){
    //   ToastUtil.showMessage(message: '请输入身份证号');return false;
    // }
    if (phoneController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入手机号');
      return false;
    }
    if (area.value == '') {
      ToastUtil.showMessage(message: '请选择地区');
      return false;
    }
    // 校验手机号
    if (!WMSCheckUtil.isPhoneNumber(phoneController.text)) {
      ToastUtil.showMessage(message: '手机号格式错误');
      print("号码错误");
      return false;
    }
    if (addressController.text.length == 0) {
      ToastUtil.showMessage(message: '请输入详细地址');
      return false;
    }
    // if(image1.value == ''){
    //   ToastUtil.showMessage(message: '请上传身份证正面照');return false;
    // }
    // if(image2.value == ''){
    //   ToastUtil.showMessage(message: '请上传身份证反面照');return false;
    // }
    return true;
  }

  // 发送网络请求  编辑地址
  void requestSave() {
    if (checkInput() == false) return;
    EasyLoadingUtil.showLoading();
    HttpServices.editAddress(
        id: addressModel.id,
        userName: nameController.text,
        userPhone: phoneController.text,
        province: province.value,
        city: city.value,
        area: area.value,
        userAddress: addressController.text,
        isdefault: isDefalut.value ? 1 : 0,
        cardNum: idController.text,
        cardJust: image1.value,
        cardBack: image2.value,
        success: () {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: '保存成功');
          Get.back(result: true);
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  void onTapAddImagBtnHandel(BuildContext context, int tag) {
    WMSBottomSheet.showCameraSheet(context, handle1: () async {
      Get.back();
      if (await Permission.camera.request().isGranted) {
        _getCamera(tag);
      }
    }, handle2: () async {
      Get.back();
      if (await Permission.camera.request().isGranted) {
        _getPhotoAlbum(tag);
      }
    });
  }

  Future _getCamera(int tag) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    uploadImage(File(pickedFile.path), tag);
  }

  Future _getPhotoAlbum(int tag) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    uploadImage(File(pickedFile.path), tag);
  }

  // 上传图片
  void uploadImage(File imageFile, int tag) async {
    EasyLoadingUtil.showLoading();
    HttpServices.requestOss(
        dir: AppGlobalConfig.imageType4,
        success: (data) async {
          String url = await HttpServices.asyncUpLoadImage(
            model: data,
            file: imageFile,
          );
          print('图片url= ' + url);
          EasyLoadingUtil.hidden();
          if (url == null) {
            ToastUtil.showMessage(message: '上传图片失败');
            return;
          }
          if (tag == 1) {
            image1.value = url;
          } else if (tag == 2) {
            image2.value = url;
          }
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          print(error.toString());
        });
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
    nameController?.dispose();
    idController?.dispose();
    phoneController?.dispose();
    addressController?.dispose();
  }
}
