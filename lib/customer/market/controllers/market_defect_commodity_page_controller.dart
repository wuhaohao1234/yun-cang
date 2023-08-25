import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/common/identify/wms_crossborder_vertify.dart';
import 'package:wms/common/basePage/wv_success.dart';
import 'package:wms/common/baseWidgets/wms_bottom_sheet.dart';
import 'package:wms/common/baseWidgets/wv_pay_dialog_widget.dart';
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';
import 'package:wms/customer/market/defect/mk_defect_order_confirm_page.dart';
import 'package:wms/customer/market/defect/mk_place_defect_order_page.dart';
import 'package:wms/customer/market/shopping_cart_page/shopping_cart_page_view.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/models/market/chu_huo_shipment_defect_model.dart';
import 'package:wms/models/market/market_detail_model.dart';
// import '../shopping_cart_page.dart';
import 'package:wms/customer/orders/wv_order_success.dart';
import 'package:wms/customer/main/cs_main_page.dart';
import 'package:wms/customer/others/webview_page.dart';

class MarketDefectCommodityPageController extends GetxController {
  final num spuId;
  final num status;
  final model;

  MarketDefectCommodityPageController(this.spuId, this.status, this.model);

  var dataModel = MarketDetailModel().obs;
  var dataDefectSource = RxList<ChuHuoShipmentDefectModel>();

  RxInt skuId = 0.obs;
  // 选择的尺码数据
  Rx<SizeListModel> skuIdData = Rx(SizeListModel()); //尺寸详情列表
  // 选择的出货列表
  Rx<ChuHuoShipmentDefectModel> selectDataDefectSource =
      Rx(ChuHuoShipmentDefectModel());
  var skuOrderList = [].obs; //提交订单商品列表
  // 选择出货列表的下标
  RxInt tenantUserIndex = RxInt(-1);

  // 弹出框使用
  var count = 0.obs;
  var checkedNotice = false.obs;

  // 下单或者购物车 1：购物车 2：下单
  int buttonType = 2;

  // 订单确认使用
  /// 地址
  AddressModel consigneeData;

  ///是否跨境
  RxBool isCrossBorder = RxBool(false);
  var totalFee = 0.00.obs;
  var goodsTotalFee = 0.0.obs;
  var freightFee = 0.0.obs;

  var taxFee = 0.0.obs;
  RxBool needRealName = RxBool(false);

  //支付方式
  Map<String, dynamic> payModel = {
    "lable": '支付方式',
  };
  var detailInfoShow = false.obs;

  // 最小etk限数
  RxInt etk = RxInt(0);
  TextEditingController notesController;
  //支付方式

  var detail;
  @override
  void onInit() {
    notesController = TextEditingController();
    super.onInit();
    EasyLoadingUtil.showLoading();
    requestData();
  }

  void requestData() {
    requestInfoData();
    requestDetailData();
  }

  Future<void> requestInfoData() async {
    // 单品出售,查询出售信息详情
    EasyLoadingUtil.showLoading();
    print('get commodity  info');
    var res = await HttpServices().csMarketInfo(
      spuId: spuId.toString(),
    );
    print(res);
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (res != null) {
      EasyLoadingUtil.hidden();
      detail = res;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestDetailData() async {
    // 单品出售,查询出售信息详情
    EasyLoadingUtil.showLoading();
    print('get commodity sale info');
    var res = await HttpServices().csGetMarketSpuSize(
      spuId: spuId,
      status: status,
    );
    // print(res);
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (res != null) {
      // print(res);
      dataModel.value = res;
      var allCount = dataModel.value.marketSizeList.fold(
          0, (previousValue, element) => previousValue + element.sellerCount);
      dataModel.value.marketSizeList.insert(
          0,
          SizeListModel.fromJson(
              {'storeIdStr': '', 'size': '全部', 'sellerCount': allCount}));
      skuIdData.value = SizeListModel.fromJson({'storeIdStr': ''});
      EasyLoadingUtil.hidden();
      csGetChuHuoDefectList();
      return true;
    } else {
      return false;
    }
  }

  // 单品瑕疵出售,查询出售信息详情
  Future<bool> csGetChuHuoDefectList() async {
    EasyLoadingUtil.showLoading();
    print('get commodity sale info');
    dataDefectSource.clear();
    var res = await HttpServices().csGetChuHuoDefectList(
        spuId: spuId,
        storeIdStr: skuIdData.value.storeIdStr ?? '',
        pageSize: 5,
        pageNum: 1);
    // print(res);
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (res != null) {
      if (res['data'].length == 0) {
        EasyLoadingUtil.showMessage(message: '未获取数据');
        dataDefectSource.value = [];
      } else {
        dataDefectSource.value = res['data'];
      }
      selectDataDefectSource.value = dataDefectSource[0] ?? null;
      skuOrderList.value = dataDefectSource
          .map((e) => {"id": e.id, "status": e.status, 'count': 0.obs})
          .toList(); //设置初始提交列表
      tenantUserIndex.value = 0;

      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

  Future<void> onRefresh() async {
    requestData();
  }

  //  弹出框
  void onTapCommitHandle(BuildContext context, int type) {
    setUpWidget(context, MKPlaceDefectOrderPage());
    buttonType = type;
  }

  void onTapShoppingCartHandle() {
    Get.to(() => ShoppingCartPage());
  }

  // 设置skuId
  void setSkuIdData(SizeListModel data) {
    skuIdData.value = data;
    csGetChuHuoDefectList();
  }

  /// 设置商家信息
  void setTenantUser(ChuHuoShipmentDefectModel data, int index) {
    tenantUserIndex.value = index;
    selectDataDefectSource.value = data;
    skuOrderList.value = dataDefectSource
        .map((e) => {"id": e.id, "status": e.status, 'count': 0.obs})
        .toList();
  }

  /// 改变商品详情显示
  void onChangeDetail() {
    detailInfoShow.value = !detailInfoShow.value;
  }

  bool checkNotice() {
    return checkedNotice.value;
  }

  setNoticeValue(e) {
    this.checkedNotice.value = e;
  }

  // 打开隐私政策页面
  void onTapNoticeBtnHandle() {
    Get.to(
      () => WebviewPage(
        url: AppGlobalConfig.notice,
        title: '跨境消费者告知书',
      ),
    );
  }

  /* ********* 弹出框使用 *********** */
  // 加
  void onTapAddHandle(context, index, count) {
    int maxInt = 1;
    if (count >= maxInt) {
      ToastUtil.showMessage(message: "当前库存$maxInt");
      count.value = maxInt;
      csMarketOrderTaxFee(context);
      return;
    }
    count = count + 1;
    var itemIndex = skuOrderList
        .indexWhere((element) => element['id'] == dataDefectSource[index].id);
    skuOrderList[itemIndex]['count'].value = count;

    csMarketOrderTaxFee(context);
  }

  // 减
  void onTapSubtractionHandle(context, index, count) {
    if (count == 0) {
      csMarketOrderTaxFee(context);
      return;
    }

    count = count - 1;
    var itemIndex = skuOrderList
        .indexWhere((element) => element['id'] == dataDefectSource[index].id);
    skuOrderList[itemIndex]['count'].value = count;
    csMarketOrderTaxFee(context);
  }

  // 弹出框确定
  void onTapCommitOrder() {
    Get.back();
    if (buttonType == 2) {
      onConfirmOrderNumber(false);
      Get.to(() => MKDefectOrderConfirmPage());
      onConfirmOrderNumber(true);
    } else {
      ToastUtil.showMessage(message: '添加购物车成功');
      businessOrderAdd();
    }
  }

  //确定订单数量
  void onConfirmOrderNumber(countConfirm) {
    var temp = skuOrderList;
    List newSkus = [];

    for (var j = 0; j < temp.length; j++) {
      if (temp[j]['count'] == null || temp[j]['count'].value <= 0) {
      } else {
        newSkus.add(temp[j]);
      }
    }
    if (newSkus.length == 0) {
      return;
    } else {
      print(newSkus);
    }
    count.value = newSkus.length;
    if (countConfirm) {
      skuOrderList.value = newSkus;
    }
  }

  // 弹出框确定支付方式
  void onTapPayModel(Map paySelectedModel) {
    payModel = paySelectedModel;
    // Navigator.of(context).pop();
  }

  /* ********* 订单确认使用 *********** */

  /// 写入本地交易数据
  // setShoppingCartData(Map<String, OrderShowModel> val) async {
  //   Map<String, OrderShowModel> _newOrderDataMap = {};
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   String orderDataStr = prefs.getString('orderDataMap');
  //   if (orderDataStr != null) {
  //     Map<String, dynamic> orderDataMap = json.decode(orderDataStr);
  //     _newOrderDataMap = orderDataMap
  //         .map((key, value) => MapEntry(key, OrderShowModel.fromJson(value)));
  //     print('获取 $_newOrderDataMap');
  //   }
  //   _newOrderDataMap[val.keys.last] = val.values.last;
  //   print('整合 $_newOrderDataMap');
  //   await prefs.setString('orderDataMap', json.encode(_newOrderDataMap));
  // }

  /// 设置地址
  void setConsignee(AddressModel v, context) {
    consigneeData = v;
    csMarketOrderTaxFee(context);
    if (v == null) {
      return;
    }
    // if (v.province == '香港特别行政区' || v.province == '澳门特别行政区') {
    //   isCrossBorder.value = false;
    // } else {
    //   isCrossBorder.value = true;
    // }
    if (isCrossBorder.value) {
      getEtk();
    }
    if (isCrossBorder.value) {
      // getEtk();

      // if (needRealName.value) {
      //   showDialog(
      //       context: context,
      //       builder: (BuildContext ctx) => wvDialog(
      //           //构建弹框中的内容
      //           widget: CSCrossBorderVertifyPage(id: consigneeData.id)));
      // }
    }
    update();
  }

  // 获取etk数量
  void getEtk() {
    EasyLoadingUtil.showLoading();
    Map<String, dynamic> _params = {
      "id": consigneeData.id,
      "skuIdList": skuOrderList
          .fold(
            '',
            (previousValue, element) =>
                previousValue + ',' + element['id'].toString(),
          )
          .substring(1),
    };
    HttpServices.getEtk(
      params: _params,
      success: (num) {
        EasyLoadingUtil.hidden();
        if (num != null) {
          etk.value = num;
        }
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  //计算税费；
  Future csMarketOrderTaxFee(context) async {
    onConfirmOrderNumber(false);
    if (consigneeData == null) {
      return false;
    }

    EasyLoadingUtil.showLoading();
    var res = await HttpServices().csMarketOrderTaxFee(
      addressId: consigneeData.id,
      depotId: selectDataDefectSource.value.depotId,
      skuOrderList: skuOrderList
          .map((element) => {
                "id": element['id'],
                "count": element['count'].value,
                "status": element['status']
              })
          .toList(),
    );
    print(res);
    if (res is ErrorEntity) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: "计算税费不成功: ${res.message}");
      return false;
    }
    if (res != null) {
      totalFee.value = res['totalFee'] != 0 ? res['totalFee'] : 0.0;
      freightFee.value = res['freightFee'] != 0 ? res['freightFee'] : 0.0;
      goodsTotalFee.value =
          res['goodsTotalFee'] != 0 ? res['goodsTotalFee'] : 0.0;
      taxFee.value = res['taxFee'] != 0 ? res['taxFee'] : 0.0;
      isCrossBorder.value = !res['notCross'];
      needRealName.value = res['needRealName'] ?? false;
    }
    // if (totalFee.value != null &&
    //     totalFee.value > 5000 &&
    //     isCrossBorder.value) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext ctx) => wvDialog(
    //       widget: Padding(
    //         padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Align(
    //               alignment: Alignment.topCenter,
    //               child: Text(
    //                 '提示',
    //                 style:
    //                     TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             SizedBox(height: 10.0),
    //             Align(
    //               alignment: Alignment.topLeft,
    //               child: Text(
    //                 '商品金额超过5000元，无法完成跨境电商清关，请不要选择跨境地址',
    //                 // "商品金额超过5000元，进行跨境选购将征收20%的税额",
    //                 style: TextStyle(
    //                   fontSize: 16.0,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    //   return false;
    // }
    if (needRealName.value) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) => wvDialog(
              //构建弹框中的内容
              widget: CSCrossBorderVertifyPage(id: consigneeData.id)));
    }
    EasyLoadingUtil.hidden();
    update();
  }

  //提交订单；
  Future<void> csMarketOrderAdd(
    BuildContext context,
  ) async {
    if (consigneeData == null) {
      return false;
    }
    // if (payModel['value'] == null) {
    //   return false;
    // }
    var orderStatus = await csMarketOrderTaxFee(context);
    if (orderStatus == false) {
      return false;
    }
    EasyLoadingUtil.showLoading();
    // print(fee['totalFee']);

    var res = await HttpServices().csMarketOrderAdd(
      addressId: consigneeData.id,
      depotId: selectDataDefectSource.value.depotId,
      userCode: selectDataDefectSource.value.userCode,
      notes: notesController.text ?? '',
      skuOrderList: skuOrderList
          .map((element) => {
                "id": element['id'],
                "count": element['count'].value,
                "status": element['status']
              })
          .toList(),
      picturePath: model.picturePath ?? '',
    );
    print(res);
    if (res == false) {
      EasyLoadingUtil.showMessage(message: '创建订单失败');
      return false;
    }
    if (res != null) {
      EasyLoadingUtil.showMessage(message: '已成功创建订单');
      Get.to(() => SuccessPage(
            title: '成功创建订单',
            content: Text(
              '',
              style: TextStyle(fontSize: 14.0, color: Color(0xff00CCCC)),
            ),
            button: OutlinedButton(
              onPressed: () {
                Get.offAll(() => CSMainPage(defaultIndex: WMSUser.getInstance().depotPower?1:0));
              },
              child: Text(
                '订单列表',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ));
      openPayDialog(
        context,
        res,
        totalFee.value ?? 0,
      );
      print(totalFee.value);
    }
    EasyLoadingUtil.hidden();
  }

  /// 下单
  void businessOrderAdd([BuildContext context, Function(num, num) callback]) {
    // 下单
    if (buttonType == 2) {
      // _params['wmsUserOrderDetailsList'][0]['sysPrepareSkuIds'] = selectDataDefectSource?.value?.sysPrepareSkuId?.sublist(0, selectDataDefectSource?.value?.sysPrepareSkuIdLength ?? 0);
      EasyLoadingUtil.showLoading();
      csMarketOrderAdd(context);
    } else {
      // 加入购物车
      // OrderShowModel orderShowData = OrderShowModel.fromJson(_params);
      // Map<String, OrderShowModel> orderData = {
      // selectDataDefectSource.value.skuMaster: orderShowData
      // };
      // print(json.encode(orderData));
      /*orderData.forEach((key, value) {
        print(key);
        print(value.toJson());
        print(value.wmsUserOrderDetailsList[0].picturePath);
      });*/
      // setShoppingCartData(orderData);
    }
  }

  /// 支付订单
  void openPayDialog(BuildContext context, int _id, num _orderSum) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => wvDialog(
        widget: PayDialogWidget(
          id: _id,
          orderSum: _orderSum,
          forbiddenValue: isCrossBorder.value?[4]:[],
          callBack: (int _id) {
            Get.to(() => OrderSuccessPage(id: _id));
          },
        ),
      ),
    );
  }

  void onTapChuHuoItem(BuildContext context, int index) {
    WMSBottomSheet.showChuHuoListSheet(context,
        dataModel: dataDefectSource[index]);
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoadingUtil.popHidden();
  }
}
