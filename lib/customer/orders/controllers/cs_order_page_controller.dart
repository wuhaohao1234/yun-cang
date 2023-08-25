import 'package:get/get.dart';
import 'package:wms/models/order/order_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/event_bus_util.dart';

class CSOrderPageController extends GetxController {
  final navStatus;
  final String orderStatus;

  CSOrderPageController(this.navStatus, this.orderStatus);
  int pageSize = 10;
  int pageNumber = 1;

  var canMore = false.obs;

  RxInt orderType = 0.obs; //0出售 1 购买

  var dataSource = RxList<OrderModel>();

  //check if order
  RxBool allCheckbox = false.obs;

  @override
  void onInit() {
    super.onInit();
    print(navStatus);
    print('orderStatus===$orderStatus');
    orderType.value = navStatus;
    // EasyLoadingUtil.showLoading();
    EventBusUtil.getInstance().on<ChangeOrderModel>().listen((event) {
      orderType.value = event.model;
      print(orderType.value);
      requestData();
    });
    requestData();
  }

  void requestData() {
    EasyLoadingUtil.showLoading();
    print(orderType.value);
    HttpServices.getOrderlist(
        orderType: orderType.value,
        orderStatus: orderStatus,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          if (data.length == total) {
            canMore.value = false;
          } else {
            canMore.value = true;
          }
          if (pageNumber == 1) {
            dataSource.value = data;
          } else {
            dataSource.addAll(data);
            // data..sort((a, b) => b.createTime.compareTo(a.createTime)));
          }
          update();
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          EasyLoadingUtil.showMessage(message: error.message);
        });
  }

  Future onRefresh() async {
    print('onRefresh');
    pageNumber = 1;
    requestData();
  }

  Future onLoad() async {
    pageNumber += 1;
    requestData();
  }

  /// 全选
  // void onChangedAllCheckbox(bool val) {
  //   bool _val = val == null ? false : val;
  //   allCheckbox.value = !_val;
  //   dataSource.map((element) {
  //     element.selected = allCheckbox.value;
  //     return element;
  //   }).toList();
  // }

  /// 选择某一项
  // void onChangedCheckbox(Map<String, dynamic> val) {
  //   List<OrderModel> _dataSource = dataSource.map((element) {
  //     if (element.orderId == val['orderId']) {
  //       element.selected = val['selected'];
  //     }
  //     return element;
  //   }).toList();
  //   dataSource(_dataSource);

  //   //   // 选择框联动
  //   List<OrderModel> selectListData =
  //       dataSource.where((element) => element.selected == true).toList();
  //   if (selectListData.length == dataSource.length) {
  //     allCheckbox.value = true;
  //   } else if (selectListData.length > 0) {
  //     allCheckbox.value = null;
  //   } else {
  //     allCheckbox.value = false;
  //   }
  // }

  /// 一键配发
  // void outStoreOrder() {
  //   List<OrderModel> selectListData =
  //       dataSource.where((element) => element.selected == true).toList();
  //   List<int> _ids = [];
  //   selectListData.forEach((element) {
  //     _ids.add(element.orderId);
  //   });
  //   print('一键配发IDS $_ids');
  //   if (_ids.isNotEmpty) {
  //     Map<String, dynamic> params = {"ids": _ids};
  //     HttpServices.outOrderExpress(
  //       params: params,
  //       success: (data) {
  //         EasyLoadingUtil.hidden();
  //         // 刷新数据
  //         Get.to(() => SuccessPage(
  //               title: '订单配发成功',
  //               content: Text(
  //                 '（待仓库操作出库）',
  //                 style: TextStyle(fontSize: 14.0, color: Color(0xff00CCCC)),
  //               ),
  //               // button: OutlinedButton(
  //               //   onPressed: () {},
  //               //   child: Text(
  //               //     '查看订单',
  //               //     style: TextStyle(fontWeight: FontWeight.bold),
  //               //   ),
  //               // ),
  //             ));
  //       },
  //       error: (error) {
  //         EasyLoadingUtil.hidden();
  //         ToastUtil.showMessage(message: error.message);
  //       },
  //     );
  //   } else {
  //     ToastUtil.showMessage(message: '请选择订单！');
  //   }
  // }

  @override
  void onClose() {
    super.onClose();
    Get.delete<CSOrderPageController>();
  }
}
