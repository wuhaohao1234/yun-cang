// // 发布预约入库单页面
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:wms/common/baseWidgets/wms_text.dart';
// import 'package:wms/common/baseWidgets/wms_upload_image_widget.dart';
// import 'package:wms/configs/app_style_config.dart';
// import 'package:wms/customer/release/release_ybrk_page_controller.dart';

// class ReleaseYbrkPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     ReleaseYbrkPageController pageController = Get.put(ReleaseYbrkPageController());

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0.0,
//         title: WMSText(
//           content: '预约入库',
//           size: AppStyleConfig.navTitleSize,
//         ),
//         leading: TextButton(
//           child: WMSText(
//             content: '取消',
//             color: Colors.grey,
//           ),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               children: [
//                 // 快递单号
//                 buildCourierNumberWidget(pageController),
//                 // 快递箱数
//                 buildBoxCountWidget(pageController),
//                 // 货品数量
//                 buildItemNumberWidget(pageController),
//                 // 添加照片
//                 buildPictureWidget(pageController, context),
//                 // 备注
//                 buildRemarkWidget(pageController),
//                 // 提交按钮
//                 buildSubmitBtnWidget(pageController),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // 快递单号
//   Widget buildCourierNumberWidget(ReleaseYbrkPageController pageController) {
//     return Container(
//       margin: EdgeInsets.only(top: 16.h),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(width: 1, color: Colors.grey[200]),
//         ),
//       ),
//       child: Row(
//         children: [
//           WMSText(
//             content: '快递单号',
//             bold: true,
//           ),
//           SizedBox(
//             width: 8.w,
//           ),
//           Expanded(
//               child: TextField(
//             cursorColor: Colors.black,
//             controller: pageController.mailController,
//             decoration: InputDecoration(
//               hintText: '必填',
//               border: InputBorder.none,
//               hintStyle: TextStyle(fontSize: 13.sp),
//             ),
//           )),
//           SizedBox(
//             width: 8.w,
//           ),
//           IconButton(icon: SvgPicture.asset('assets/svgs/scan.svg',width: 17.w,), onPressed: pageController.onTapScanBarcode)
//         ],
//       ),
//     );
//   }

//   // 快递箱数
//   Widget buildBoxCountWidget(ReleaseYbrkPageController pageController) {
//     return Container(
//       margin: EdgeInsets.only(top: 16.h),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(width: 1, color: Colors.grey[200]),
//         ),
//       ),
//       child: Row(
//         children: [
//           WMSText(
//             content: '快递箱数',
//             bold: true,
//           ),
//           SizedBox(
//             width: 8.w,
//           ),
//           Expanded(
//               child: TextField(
//             cursorColor: Colors.black,
//             controller: pageController.boxController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               hintText: '必填',
//               border: InputBorder.none,
//               hintStyle: TextStyle(fontSize: 13.sp),
//             ),
//           )),
//         ],
//       ),
//     );
//   }

//   // 货品数量
//   Widget buildItemNumberWidget(ReleaseYbrkPageController pageController) {
//     return Container(
//       margin: EdgeInsets.only(top: 16.h),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(width: 1, color: Colors.grey[200]),
//         ),
//       ),
//       child: Row(
//         children: [
//           WMSText(
//             content: '货品数量',
//             bold: true,
//           ),
//           SizedBox(
//             width: 8.w,
//           ),
//           Expanded(
//               child: TextField(
//             cursorColor: Colors.black,
//             controller: pageController.countController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               hintText: '必填',
//               border: InputBorder.none,
//               hintStyle: TextStyle(fontSize: 13.sp),
//             ),
//           )),
//         ],
//       ),
//     );
//   }

//   // 添加照片
//   Widget buildPictureWidget(ReleaseYbrkPageController pageController, BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 16.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               WMSText(
//                 content: '添加照片',
//                 bold: true,
//               ),
//               WMSText(
//                 content: '(货单/截图/货品图)',
//                 size: 12,
//                 color: Colors.grey,
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 16.h,
//           ),
//           Obx(
//             () => WMSUploadImageWidget(
//               canDelete: true,
//               images: pageController.pictures.value,
//               addCallBack: pageController.onTapAddImageHandle,
//               delCallBack: pageController.onTapDelArticleNumberImage,
//             ),
//           ),
//         ],
//       ),
//     );
//   }


//   // 备注
//   Widget buildRemarkWidget(ReleaseYbrkPageController pageController) {
//     return Container(
//       margin: EdgeInsets.only(top: 16.h),
//       padding: EdgeInsets.symmetric(horizontal: 8.w),
//       height: 100.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5.r),
//         border: Border.all(width: 1, color: Colors.grey[200]),
//       ),
//       child: TextField(
//         cursorColor: Colors.black,
//         keyboardType: TextInputType.multiline,
//         controller: pageController.remarkController,
//         style: TextStyle(fontSize: 13.sp),
//         maxLines: 5,
//         decoration: InputDecoration(
//           hintText: '添加备注',
//           border: InputBorder.none,
//           hintStyle: TextStyle(fontSize: 13.sp),
//         ),
//       ),
//     );
//   }

//   // 提交按钮
//   Widget buildSubmitBtnWidget(ReleaseYbrkPageController pageController) {
//     return Container(
//       margin: EdgeInsets.only(top: 80.h, bottom: 44.h),
//       height: 34.h,
//       width: (375 - 32).w,
//       child: GestureDetector(
//         onTap: pageController.onTapSubmitHandle,
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppStyleConfig.btnColor,
//             borderRadius: BorderRadius.circular(5.r),
//           ),
//           child: Center(
//             child: Text(
//               '提交',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
