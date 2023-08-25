 // 客户端-仓储模块-获取待出库列表
  // static void getWillList(
  //     {String pageNum,
  //     String pageSize,
  //     String date,
  //     Function(List<DckModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //     'monthTime': date,
  //   };

  //   HttpManager().requestList<DckModel>(HttpApis.getWillList,
  //       params: params, method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

   // 获取已出库单列表
  // static void getAlreadyList(
  //     {String pageNum,
  //     String pageSize,
  //     String date,
  //     Function(List<CSYckdModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //     'monthOutTime': date
  //   };
  //   HttpManager().requestList<CSYckdModel>(HttpApis.getAlreadyList,
  //       params: params, method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // static void prepareOrderList(
  //     {String pageNum,
  //     String pageSize,
  //     String date,
  //     String depotId,
  //     String mailNo,
  //     String status,
  //     Function(List<PerpareOrderModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //     'date': date,
  //     'depotId': depotId,
  //     'mailNo': mailNo,
  //     'status': status,
  //   };

  //   HttpManager().requestList<PerpareOrderModel>(HttpApis.prepareOrderList,
  //       params: params, method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // Future addOwnerLessSysPrepareOrder({
  //   String mailNo,
  //   String ownerlessImg,
  //   num boxTotalFact,
  // }) async {
  //   Completer completer = new Completer();
  //   Map<String, dynamic> params = {
  //     'mailNo': mailNo,
  //     'ownerlessImg': ownerlessImg,
  //     'boxTotalFact': boxTotalFact
  //   };
  //   HttpManager().request(HttpApis.addOwnerLessSysPrepareOrder,
  //       method: NWMethod.POST, params: params, success: (data) {
  //     completer.complete(data);
  //   }, error: (e) {
  //     // error(e);
  //     print("$e");
  //   });
  //   return completer.future;
  // }

  // 客户端查询入库单
  // static void getinstoreOrderList(
  //     {String pageNum,
  //     String pageSize,
  //     String date,
  //     Function(List<RkdModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //     'date': date
  //   };
  //   HttpManager().requestList<RkdModel>(HttpApis.getinstoreOrderList,
  //       params: params, method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

   // 客户端查询异常单列表
  // static void getExceptionOrderList(
  //     {String pageNum,
  //     String pageSize,
  //     String date,
  //     Function(List<YcjModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //     'date': date,
  //   };
  //   HttpManager().requestList<YcjModel>(HttpApis.getExceptionOrderList,
  //       params: params, method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // 客户端获取临存出库单详情
  // static void csTemporaryExistenceListDetail(
  //     {int prepareOrderId,
  //     Function(CsChuKuModel) success,
  //     Function(ErrorEntity) error}) {
  //   HttpManager().request<CsChuKuModel>(
  //       '${HttpApis.csTemporaryExistenceListDetail}/${prepareOrderId}',
  //       method: NWMethod.GET, success: (data) {
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // 客户端获取待出库详情
  // static void csOutStoreDetail(
  //     {String wmsOutStoreId,
  //     Function(CsChuKuModel) success,
  //     Function(ErrorEntity) error}) {
  //   HttpManager().request<CsChuKuModel>(
  //       '${HttpApis.csOutStoreDetail}/${wmsOutStoreId}',
  //       method: NWMethod.GET, success: (data) {
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // 客户端获取已出库详情
  // static void already(
  //     {String wmsOutStoreId,
  //     Function(CkdDetailModel) success,
  //     Function(ErrorEntity) error}) {
  //   HttpManager().request<CkdDetailModel>(
  //       '${HttpApis.already}/${wmsOutStoreId}',
  //       method: NWMethod.GET, success: (data) {
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // 预入库单详情
  // static void prepareOrderDetailList(
  //     {String orderId,
  //     String status,
  //     Function(PerpareOrderModel model) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'status': status,
  //   };
  //   HttpManager().request<PerpareOrderModel>(
  //       '${HttpApis.prepareOrderDetailList}/${orderId}',
  //       params: params,
  //       method: NWMethod.GET, success: (data) {
  //     print(data.toString());
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // 客户app集市在售列表
  // static void getMarketAllList(
  //     {String pageNum,
  //     String pageSize,
  //     String searchValue,
  //     Function(List<MarketWaresModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //   };
  //   if (searchValue != null) {
  //     params['searchValue'] = searchValue;
  //   }
  //   HttpManager().requestList<MarketWaresModel>(HttpApis.marketAllList,
  //       params: params, method: NWMethod.GET, success: (data, tatol) {
  //     print(data.toString());
  //     success(data, tatol);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

  // 客户app集市我的在售列表
  // static void getMarketMyList(
  //     {String pageNum,
  //     String pageSize,
  //     String searchValue,
  //     Function(List<MarketWaresModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': 10,
  //   };
  //   if (searchValue != null) {
  //     params['searchValue'] = searchValue;
  //   }
  //   HttpManager().requestList<MarketWaresModel>(HttpApis.marketMyList,
  //       params: params, method: NWMethod.GET, success: (data, tatol) {
  //     print(data.toString());
  //     success(data, tatol);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

  // 客户app集市我的在售详情
  // static void getMarketAllDetail(
  //     {num spuId,
  //     Function(MarketAllDetailModel) success,
  //     Function(ErrorEntity) error}) {
  //   HttpManager().request<MarketAllDetailModel>(
  //       '${HttpApis.marketAllDetail}/${spuId}',
  //       method: NWMethod.GET, success: (data) {
  //     print(data.toString());
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

  // 客户app集市在售详情
  // static void getMarketMyDetail(
  //     {num spuId,
  //     Function(MarketAllDetailModel) success,
  //     Function(ErrorEntity) error}) {
  //   HttpManager().request<MarketAllDetailModel>(
  //       '${HttpApis.marketMyDetail}/${spuId}',
  //       method: NWMethod.GET, success: (data) {
  //     print(data.toString());
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // 集市在售商品详情页查询出货列表
  // static void getChuHuoList(
  //     {num pageNum,
  //     num pageSize,
  //     num skuId,
  //     Function(List<ChuHuoShipmentModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //   };
  //   HttpManager().requestList<ChuHuoShipmentModel>(
  //       '${HttpApis.getChuHuoList}/${skuId}',
  //       params: params,
  //       method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // 集市在售商品详情页查询出货列表 -V2
  // static void getChuHuoList2(
  //     {num pageNum,
  //     num pageSize,
  //     num skuId,
  //     Function(List<ChuHuoShipmentNormalModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //   };
  //   HttpManager().requestList<ChuHuoShipmentNormalModel>(
  //       '${HttpApis.getChuHuoList2}/${skuId}',
  //       params: params,
  //       method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }
  // 查询店铺流水
    // static void shopMoneysLog(
  //     {num pageNum,
  //     num pageSize,
  //     String dateTime,
  //     Function(List<MoneysLogModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //     'dateTime': dateTime,
  //   };

  //   HttpManager().requestList<MoneysLogModel>(HttpApis.shopMoneysLog,
  //       params: params, method: NWMethod.GET, success: (data, total) {
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

   // 仓库端无主单列表
  // static void wzdList(
  //     {String pageNum,
  //     String pageSize,
  //     String mailNo,
  //     Function(List<ENYbrkModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': 10,
  //     'mailNo': mailNo
  //   };
  //   HttpManager().requestList<ENYbrkModel>(HttpApis.enOwnerLessList,
  //       params: params, method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

    // 订单模块-出售-订单列表
  // static void getTenantlist(
  //     {int pageNum,
  //     int pageSize,
  //     int orderStatus,
  //     Function(List<OrderModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //   };
  //   if (orderStatus != null) {
  //     params['orderStatus'] = orderStatus;
  //   }
  //   HttpManager().requestList<OrderModel>(HttpApis.getTenantlist,
  //       params: params, method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

  // 订单模块-购买 -订单列表
  // static void getBuyerslist(
  //     {int pageNum,
  //     int pageSize,
  //     int orderStatus,
  //     Function(List<OrderModel>, num) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'pageNum': pageNum,
  //     'pageSize': pageSize,
  //   };
  //   if (orderStatus != null) {
  //     params['orderStatus'] = orderStatus;
  //   }
  //   HttpManager().requestList<OrderModel>(HttpApis.getBuyerslist,
  //       params: params, method: NWMethod.GET, success: (data, total) {
  //     print(data.toString());
  //     success(data, total);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }
  //订单收货
  // static void receivingGoods(
  //     {int orderId,
  //     String payPassword,
  //     String moneyType,
  //     Function(dynamic) success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'orderId': orderId,
  //     'payPassword': payPassword,
  //   };

  //   HttpManager().requestList<dynamic>(HttpApis.receivingGoods,
  //       params: params, method: NWMethod.POST, success: (data, total) {
  //     print(data.toString());
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

  // WV 下订单
  // static void businessOrderAdd(
  //     {Map<String, dynamic> params,
  //     Function(Map<String, dynamic>) success,
  //     Function(ErrorEntity) error}) {
  //   HttpManager().request<Map<String, dynamic>>(HttpApis.businessOrderAdd,
  //       params: params, method: NWMethod.POST, success: (data) {
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }
