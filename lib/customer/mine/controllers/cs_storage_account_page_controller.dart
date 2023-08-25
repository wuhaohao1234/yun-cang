// //账户明细Controller
// import 'package:get/get.dart';
// import 'package:wms/models/mine/moneys_log_model.dart';
// import 'package:wms/network/http_services.dart';
// import 'package:wms/utils/easy_loading_util.dart';
// import 'package:wms/utils/toast_util.dart';

// class CSStorageAccountPageController extends GetxController {
//   // final dateTime;
//   var dataSource = RxList<MoneysLogModel>();
//   var canMore = true.obs;
//   var pageNum = 1;
//   var pageSize;
//   var dateTime;

//   // CSStorageAccountPageController(this.dateTime); // 反面

//   @override
//   void onInit() {
//     super.onInit();
//     EasyLoadingUtil.showLoading();
//     requestData();
//   }

//   // 请求数据
//   void requestData() {
//     HttpServices.shopMoneysLog(
//         pageNum: pageNum,
//         pageSize: 10,
//         dateTime: dateTime,
//         success: (data, total) {
//           EasyLoadingUtil.hidden();
//           if (data.length == total) {
//             canMore.value = false;
//           } else {
//             canMore.value = true;
//           }
//           if (pageNum == 1) {
//             dataSource.value = data;
//           } else {
//             dataSource.addAll(data);
//           }
//           update();
//         },
//         error: (error) {
//           EasyLoadingUtil.hidden();
//           ToastUtil.showMessage(message: error.message);
//         });
//   }

//   Future<void> onRefresh() async {
//     pageNum = 1;
//     requestData();
//   }

//   Future<void> onLoad() async {
//     pageNum += 1;
//     requestData();
//   }

//   @override
//   void onClose() {
//     super.onClose();
//     EasyLoadingUtil.popHidden();
//   }
// }
