import 'package:get/get.dart';
import 'package:wms/models/mine/wallet_account_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class CSWalletAccountPageController extends GetxController {
  var dataModel = WalletAccountModel().obs;

  var bond = 0.0.obs;
  var warehouseMoney = 0.0.obs;
  var shopMoney = 0.0.obs; //店铺账户余额
  var territoryMoney = 0.0.obs; //境内余额
  var abroadMoney = 0.0.obs; //境外余额
  @override
  void onInit() {
    super.onInit();
    EasyLoadingUtil.showLoading();
    requestData();
  }

  // 获取数据
  void requestData() {
    HttpServices.walletAccount(success: (data) {
      EasyLoadingUtil.hidden();
      dataModel.value = data;
      bond.value = data.bond.toDouble();
      warehouseMoney.value = data.warehouseMoney.toDouble();
      shopMoney.value = data.shopMoney.toDouble();
      territoryMoney.value = data.territoryMoney.toDouble();
      abroadMoney.value = data.abroadMoney.toDouble();
    }, error: (error) {
      EasyLoadingUtil.hidden();
      ToastUtil.showMessage(message: error.message);
    });
  }

  Future<void> onRefresh() async {
    requestData();
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
  }
}
