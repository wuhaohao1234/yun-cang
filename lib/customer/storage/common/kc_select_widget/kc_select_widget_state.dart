// https://juejin.cn/post/6924104248275763208#heading-13
import 'package:flutter/material.dart';
import 'package:wms/models/ConfirmOut_model.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/models/inventory_categorys_model.dart';
import 'package:wms/models/market/market_wares_model.dart';
import 'package:wms/models/size_qty_model.dart';

class KcSelectWidgetState {
  /// 弹出框使用
  int skuId;
  int skuIdIndex;

  // 传递过来主数据
  MarketWaresModel data;

  // 尺码数据
  List<SizeQtyModel> sizeQty;

  // 商品数据
  List<MarketWaresModel> commodityData;

  // 选择的商品数据 {spuId:{skuId:[MarketWaresModel]}}
  Map<int, Map<int, List<MarketWaresModel>>> selectCommodityData;

  /// 出库使用 过滤直有被选中的内容 废弃⚠️
  List<MarketWaresModel> selectCommodityDataList;
  List<ConfirmOutModel> confirmOutDataList;

  /// 库存使用
  List<InventoryCategorysModel> dataSource;
  List<bool> listSelectAllState = [];
  bool allCheckbox;

  // spu层勾选状态
  Map<int, Map<String, dynamic>> spuSelectAllCheckbox;

  TabController tabController;
  List<MarketWaresModel> spuDataList;

  /// 出库使用
  AddressModel consigneeData;

  KcSelectWidgetState() {
    /// 弹出框使用
    skuIdIndex = 0;
    sizeQty = [];
    commodityData = [];
    selectCommodityData = {};
    selectCommodityDataList = [];

    /// 库存使用
    dataSource = [];
    allCheckbox = false;
    spuSelectAllCheckbox = {};
    spuDataList = [];
  }
}
