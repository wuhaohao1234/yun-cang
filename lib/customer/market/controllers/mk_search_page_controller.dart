// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:wms/models/market/market_wares_model.dart';
// import 'package:wms/network/http_services.dart';
// import 'package:wms/utils/easy_loading_util.dart';
// import 'package:wms/utils/toast_util.dart';

// class MKSearchPageController extends GetxController{
//   TextEditingController textC;

//   var dataSource = RxList<MarketWaresModel>();


//   @override
//   void onInit() {
//     
//     super.onInit();
//     textC = TextEditingController();
//   }


//   void request(int listType){
//     if(listType == 0){
//       requestMy();

//     }else{
//       requestAll();
//     }

//   }

//   // 搜我的在售
//   void requestMy() {
//     EasyLoadingUtil.showLoading();
//     HttpServices.getMarketMyList(
//         searchValue: textC.text,
//         success: (data,total) {
//           EasyLoadingUtil.hidden();
//           dataSource.value = data;
//         },
//         error: (error) {
//           EasyLoadingUtil.hidden();
//           ToastUtil.showMessage(message: error.message);
//         });
//   }

//   // 搜集市在售
//   void requestAll() {
//     EasyLoadingUtil.showLoading();
//     HttpServices.getMarketAllList(
//       searchValue: textC.text,
//         success: (data,total) {
//           EasyLoadingUtil.hidden();
//           dataSource.value = data;
//         },
//         error: (error) {
//           EasyLoadingUtil.hidden();
//           ToastUtil.showMessage(message: error.message);
//         });
//   }

//   @override
//   void onClose() {
//     
//     super.onClose();
//     EasyLoadingUtil.popHidden();
//     textC?.dispose();
//   }

// }