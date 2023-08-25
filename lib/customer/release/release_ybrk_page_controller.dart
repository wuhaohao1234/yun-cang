// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:wms/common/baseWidgets/wms_bottom_sheet.dart';
// import 'package:wms/common/pages/wms_camera_page.dart';
// import 'package:wms/configs/app_global_config.dart';
// import 'package:wms/customer/storage/ybrk/cs_ybd_detail_page.dart';
// import 'package:wms/customer/storage/scan_test_page.dart';
// import 'package:wms/network/http_services.dart';
// import 'package:wms/utils/easy_loading_util.dart';
// import 'package:wms/utils/toast_util.dart';
// // import 'package:qrscan/qrscan.dart' as scanner;

// class ReleaseYbrkPageController extends GetxController {
//   TextEditingController mailController;
//   TextEditingController boxController;
//   TextEditingController countController;
//   TextEditingController remarkController;

//   var pictures = RxList<File>([]);
//   final picker = ImagePicker();

//   @override
//   void onInit() {
//     
//     super.onInit();
//     mailController = TextEditingController();
//     boxController = TextEditingController();
//     countController = TextEditingController();
//     remarkController = TextEditingController();
//   }

//   // 点击扫码按钮事件处理
//   void onTapScanBtnHandle() {}

//   // 点击添加图片事件处理
//   void onTapAddPictureHandle(BuildContext context) async {
//     WMSBottomSheet.showCameraSheet(context, handle1: () async {
//       Get.back();
//       if (await Permission.camera.request().isGranted) {
//         _getCamera();
//       }
//     }, handle2: () async {
//       Get.back();
//       if (await Permission.camera.request().isGranted) {
//         _getPhotoAlbum();
//       }
//     });
//   }

//   Future _getCamera() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);
//     pictures.add(File(pickedFile.path));
//   }

//   Future _getPhotoAlbum() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     pictures.add(File(pickedFile.path));
//   }

//   // 点击提交事件处理
//   void onTapSubmitHandle() {
//     if (pictures.length == 0) {
//       requestSubmit();
//     } else {
//       uploadImage();
//     }
//   }

//   // 删除照片
//   void onTapDelArticleNumberImage(int index) {
//     if (pictures.length > 0) {
//       pictures.removeAt(index);
//     }
//   }

//   requestSubmit({String imagePaths}) {
//     if (boxController.text.length == 0) {
//       ToastUtil.showMessage(message: '请输入快递箱数量');
//       return;
//     }
//     if (mailController.text.length == 0) {
//       ToastUtil.showMessage(message: '请输入快递单号');
//       return;
//     }
//     if (countController.text.length == 0) {
//       ToastUtil.showMessage(message: '请输入货品数量');
//       return;
//     }

//     EasyLoadingUtil.showLoading();
//     HttpServices.releaseYbrk(
//         mailNo: mailController.text,
//         skusTotal: countController.text,
//         prepareImgUrl: imagePaths,
//         remark: remarkController.text,
//         boxTotal: boxController.text,
//         success: () {
//           EasyLoadingUtil.hidden();
//           ToastUtil.showMessage(message: '发布成功');
//           Get.back();
//         },
//         error: (error) {
//           EasyLoadingUtil.hidden();
//           ToastUtil.showMessage(message: error.message);
//         });
//   }

//   // 拍照
//   void onTapAddImageHandle() {
//     Get.to(() => WMSCameraPage()).then((value) {
//       List temp = value;
//       temp?.forEach((element) {
//         pictures.add(element);
//       });
//     });
//   }

//   uploadImage() async {
//     EasyLoadingUtil.showLoading();
//     int count = 0;
//     String imagePaths = '';
//     HttpServices.requestOss(
//         dir: AppGlobalConfig.imageType3,
//         success: (data) {
//           print(data.toJson().toString());
//           for (int i = 0; i < pictures.length; i++) {
//             File imaeFlie = pictures[i];
//             String path = imaeFlie.path;
//             HttpServices.upLoadImage(
//                 file: pictures[i],
//                 model: data,
//                 success: (imageUrl) {
//                   count++;
//                   print(imageUrl.toString());
//                   imagePaths += imageUrl;
//                   imagePaths += ';';
//                   if (count == pictures.length) {
//                     imagePaths = imagePaths.substring(0, imagePaths.length - 1);
//                     print(imagePaths);
//                     requestSubmit(imagePaths: imagePaths);
//                   }
//                 },
//                 error: (error) {
//                   count++;
//                   if (count == pictures.length) {}
//                   print(error.toString());
//                   EasyLoadingUtil.hidden();
//                   ToastUtil.showMessage(message: '图片上传失败');
//                 });
//           }
//         },
//         error: (error) {
//           EasyLoadingUtil.hidden();
//           print(error.toString());
//         });
//   }

//   // 扫码条形码
//   Future<void> onTapScanBarcode() async {
//     await Permission.camera.request();
//     // String barcode = await scanner.scan();
//     // if (barcode == null) {
//     //   print('nothing return.');
//     //   ToastUtil.showMessage(message: '识别失败');
//     // } else {
//     //   print('barcode == ${barcode}');
//     //   mailController.text = barcode;
//     // }
//     print('点击扫码按钮');
//     await Permission.camera.request();
//     Get.to(() => ScanTestPage()).then((value) {
//       if (value != null) {
//         mailController.text = value;
//       }
//     });
//   }

//   @override
//   void onClose() {
//     
//     super.onClose();
//     mailController?.dispose();
//     boxController?.dispose();
//     countController?.dispose();
//     remarkController?.dispose();

//     EasyLoadingUtil.popHidden();
//   }
// }
