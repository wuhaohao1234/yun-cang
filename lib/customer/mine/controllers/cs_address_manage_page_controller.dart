import 'package:get/get.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

import '../address/cs_add_address_page.dart';

class CSAddressManagePageController extends GetxController {
  var dataSource = RxList<AddressModel>();
  num pageNum = 1;
  final num pageSize = 10;
  var canMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    print('CSAddressManagePageController init ');
    EasyLoadingUtil.showLoading();
    requestData();
  }

  // 获取数据
  void requestData() {
    HttpServices.getAddressList(
        pageNum: pageNum.toString(),
        pageSize: pageSize.toString(),
        success: (data, total) {
          EasyLoadingUtil.hidden();
          if (pageNum == 1) {
            dataSource.value = data;
          } else {
            dataSource.addAll(data);
            update();
          }
          if (data.length == total) {
            canMore.value = false;
          } else {
            canMore.value = true;
          }
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  Future onRefresh() async {
    print('onRefresh');
    pageNum = 1;
    requestData();
  }

  Future onLoad() async {
    print('onLoad');
    pageNum += 1;
    requestData();
  }

  // 跳转到添加地址页面
  void toAddPage() {
    Get.to(() => CSAddAddressPage()).then((value) {
      if (value == true) {
        requestData();
      }
    });
  }

  // 跳转到编辑地址页面
  void toEditPage(int index) {
    Get.to(() => CSAddAddressPage(
          isAdd: false,
          addressModel: dataSource[index],
        )).then((value) {
      if (value == true) {
        requestData();
      }
    });
  }
}
