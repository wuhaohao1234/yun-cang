import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/common/basePage/wv_success.dart';
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';
// import 'package:wms/customer/storage/common/kc_up_widget.dart';
// import 'package:wms/customer/storage/old/cs_ck_page.dart.old';
// import 'package:wms/customer/storage/wv_ck_success_page.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/models/market/market_wares_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

import 'kc_select_widget_state.dart';
import 'kc_select_widget_view.dart';
import 'package:wms/customer/storage/kucun/common/kc_up_widget.dart';

class KcSelectWidgetLogic extends GetxController {
  final state = KcSelectWidgetState();

  /*============= 弹出框使用 =============*/

  ///写入主数据
  void setDate(MarketWaresModel data) {
    print('data $data');
    state.data = data;
    // 初始化选择商品数据
    // if (state.selectCommodityData[state.data.spuId] == null) {
    //   state.selectCommodityData[state.data.spuId] = {};
    // }
    loadData();
  }

  /// 添加商品
  void addData(int k, List<MarketWaresModel> v) {
    print('v $v');
    int _spuId = state.data.spuId;

    //state.spuSelectAllCheckbox[_spuId] != null &&
    if (state.sizeQty.isNotEmpty) {
      // 收集商品id信息
      List _idsData = [];
      Map<String, List> _childData = {};

      // 查看spu下有多少商品
      int _dataListLength = 0;

      // 查找商品信息
      state.sizeQty.forEach((element) {
        print('element ${element.size}');
        element.childrenList.forEach((elementChild) {
          _dataListLength++;
          if (elementChild.selected == true) {
            _idsData.add(elementChild.id);
            if (_childData[element.size] == null) {
              _childData[element.size] = [];
            }
            _childData[element.size].add(elementChild);
          }
        });
      });

      if (_idsData.isEmpty) {
        // 锁
        ToastUtil.showMessage(message: '选择选择商品!');
        return;
      }

      if (_idsData.length == _dataListLength) {
        state.spuSelectAllCheckbox[_spuId] = {
          "selected": true,
          "ids": _idsData,
          'model': state.data,
          'childData': _childData
        };
      } else {
        state.spuSelectAllCheckbox[_spuId] = {
          "selected": null,
          "ids": _idsData,
          'model': state.data,
          'childData': _childData
        };
      }

      print('state.spuSelectAllCheckbox0 ${state.spuSelectAllCheckbox}');
    }

    linkage();

    ToastUtil.showMessage(message: '操作成功!');

    update();
  }

  /// 获取尺码以及商品
  void loadData() {
    int _spuId = state.data.spuId;
    // state.sizeQty.clear();
    EasyLoadingUtil.showLoading();
    HttpServices.sizeQty(
      query: "$_spuId",
      success: (data, total) {
        EasyLoadingUtil.hidden();
        if (data.isNotEmpty) {
          data.forEach((element) {
            // 写入spuid map索引使用
            element.spuId = _spuId;

            if (state.spuSelectAllCheckbox[_spuId] != null &&
                state.spuSelectAllCheckbox[_spuId]['ids'] != null) {
              List _ids = state.spuSelectAllCheckbox[_spuId]['ids'];
              if (_ids.isNotEmpty) {
                element.childrenList.forEach((elementChild) {
                  if (_ids.indexOf(elementChild.id) > -1) {
                    elementChild.selected = true;
                  }
                });
              }
            }

            // if (state.spuSelectAllCheckbox[_spuId] != null && state.spuSelectAllCheckbox[_spuId]["selected"] == true) {
            //   if (element.childrenList.isNotEmpty) {
            //     element.childrenList.forEach((elementChild) {
            //       elementChild.selected = true;
            //     });
            //   }
            // }

            // print('数据 ${element.toJson()}');
          });

          print('state.spuSelectAllCheckbox ${state.spuSelectAllCheckbox}');

          state.skuIdIndex = 0;
          state.skuId = data[state.skuIdIndex].skuId; // 设置默认尺码
          // sizeInventory();
          state.sizeQty = data;
          update();
        }
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  /// 获取尺码对应商品
  /*void sizeInventory() {
    EasyLoadingUtil.showLoading();
    HttpServices.sizeInventory(
      query: "${state.skuId}",
      success: (data) {
        EasyLoadingUtil.hidden();

        // 获取内存中商品信息 为了渲染勾选使用
        Map<int, bool> _data = {};
        List<MarketWaresModel> _a = state.selectCommodityData[state.data.spuId][state.skuId];
        if (_a != null) {
          _a.forEach((element) {
            _data[element.id] = element.selected;
          });
        }
        List<MarketWaresModel> _newData = data.map((e) {
          if (_data[e.id] != null) {
            e.selected = _data[e.id];
            return e;
          }
          return e;
        }).toList();

        state.commodityData = _newData;
        update();
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }*/

  /// 选择尺码
  void setSkuId(int id, int index) {
    state.skuId = id;
    state.skuIdIndex = index;
    // sizeInventory();
    update();
  }

  /*============= 库存使用 =============*/

  ///
  void requestData() {
    HttpServices.getInventoryCategorys(
      success: (data, total) {
        EasyLoadingUtil.hidden();
        state.dataSource = data;
        state.listSelectAllState = [];
        data.forEach((element) {
          state.listSelectAllState.add(false);
        });
        update();
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  // 提取 spuId  id
  Map<String, List> getSpuIdAndId() {
    print('spuSelectAllCheckbox ${state.spuSelectAllCheckbox}');
    List<int> _spuId = state.spuSelectAllCheckbox.keys.toList();
    Map<String, List> _params = {'spuIds': [], 'ids': []};

    _spuId.forEach((element) {
      bool _selected = state.spuSelectAllCheckbox[element]['selected'];
      List _ids = state.spuSelectAllCheckbox[element]['ids'];

      if (_selected == true) {
        _params['spuIds'].addAll([element]);
      } else {
        _params['ids'].addAll(_ids);
      }
    });

    // 删除空数据
    if (_params['spuIds'].isEmpty) {
      _params.remove('spuIds');
    }
    if (_params['ids'].isEmpty) {
      _params.remove('ids');
    }

    // Map<String, List> _params = getSpuIdAndId();
    if ((_params['spuIds'] != null && _params['spuIds'].isEmpty) ||
        (_params['ids'] != null && _params['ids'].isEmpty)) {
      // 上锁
      ToastUtil.showMessage(message: '请选择产品！');
      return null;
    }

    return _params;
  }

  /// 提交可售
  void addForSale() {
    Map<String, List> _params = getSpuIdAndId();
    if (_params == null || _params.isEmpty) return;

    HttpServices.addForSale(
      params: _params,
      success: () {
        EasyLoadingUtil.hidden();
        state.spuSelectAllCheckbox = {};
        state.allCheckbox = false;
        update();
        Get.to(() => SuccessPage(
              title: '添加可售成功',
              button: OutlinedButton(
                onPressed: () {
                  Get.back();
                  // TODO: 此处可能会有问题 单一刷新数据没有重置掉默认选择的分组id
                  requestData();
                },
                child: Text(
                  '库存页',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ));
        ToastUtil.showMessage(message: '提交成功');
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  /// 获取出仓物品清单
  void confirmOut() {
    Map<String, List> _params = getSpuIdAndId();
    if (_params == null || _params.isEmpty) return;

    HttpServices.confirmOut(
      params: _params,
      success: (res, total) {
        EasyLoadingUtil.hidden();
        state.spuSelectAllCheckbox = {};
        state.allCheckbox = false;
        state.confirmOutDataList = res;
        // Get.to(() => ScCkPage());
        update();
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  /// 打开底部弹出框
  void openPicker(BuildContext context, MarketWaresModel data) {
    setUpWidget(context, KcSelectWidgetPage(data: data));
  }

  /// 更改全选
  void onChangedAllCheckbox(val) {
    print(val.toString());
    bool _val = val == null ? false : val;

    state.allCheckbox = !_val;

    if (!_val == false) {
      print('取消全选');
      // state.spuSelectAllCheckbox = {};
      state.spuDataList.forEach((element) {
        state.spuSelectAllCheckbox.remove(element.spuId);
      });
    } else {
      print('全选 ${state.spuDataList.length}');
      state.spuDataList.forEach((element) {
        state.spuSelectAllCheckbox[element.spuId] = {
          "selected": true,
          "model": element
        };
      });
    }

    print('state.spuSelectAllCheckbox ${state.spuSelectAllCheckbox}');

    update();
  }

  /// spu层勾选状态
  void onChangedAllCheckboxChild(v) {
    print('v $v');
    if (state.spuSelectAllCheckbox[v['spuId']] == null &&
        v['selected'] == true) {
      state.spuSelectAllCheckbox[v['spuId']] = {
        "selected": true,
        "model": v['model']
      };
    } else {
      state.spuSelectAllCheckbox.remove(v['spuId']);
    }

    print('onChangedAllCheckboxChild1 ${state.spuSelectAllCheckbox}');

    linkage();

    update();
  }

  /// 联动主控制
  void linkage() {
    int _l = state.spuSelectAllCheckbox.length;
    List<MarketWaresModel> _data = state.spuDataList;
    if (_l == _data.length) {
      state.allCheckbox = true;
    } else if (_l == 0) {
      state.allCheckbox = false;
    } else {
      state.allCheckbox = null;
    }
  }

  /// TabBar切换 清空勾选数据
  void tabBarOnTap(v) {
    print(v.toString());
    // state.spuSelectAllCheckbox = {};
    // state.spuDataList.forEach((element) {
    //   print(element.spuId.toString());
    //   if(state.spuSelectAllCheckbox['spuSelectAllCheckbox'] == null){
    //     state.allCheckbox = false;
    //     update();
    //     return;
    //   }
    // });
    // state.allCheckbox = true;
    update();
  }

  /*============= 出库弹出框使用 =============*/

  /// 下架弹出框
  void onTapCommitHandle(BuildContext context) {
    setUpWidget(context, KcUpWidget());
  }

  String getChildStr(Map<String, List> data) {
    String _str = '';

    data?.forEach((key, value) {
      _str += "$key x ${value.length}\r\r\r";
    });

    return _str;
  }

  /*============= 出库使用 =============*/

  void setConsignee(AddressModel v) {
    state.consigneeData = v;
    update();
  }

  /// 提交出库
  void outStore() {
    if (state.consigneeData == null) {
      ToastUtil.showMessage(message: '请选添加收件人信息！');
      return;
    }
    List<int> ids = [];
    state.confirmOutDataList.forEach((element) {
      ids.add(element.id);
    });

    AddressModel _consigneeData = state.consigneeData;

    Map<String, dynamic> params = {
      "consigneeName": _consigneeData.userName,
      "consigneePhone": _consigneeData.userPhone,
      "consigneeProvince": _consigneeData.province,
      "consigneeCity": _consigneeData.city,
      "consigneeDistrict": _consigneeData.area,
      "consigneeAddress": _consigneeData.userAddress,
      "consigneeZip": _consigneeData.zipCode,
      "consigneeIdentity": _consigneeData.cardNum,
      "ids": ids
    };
    HttpServices.outStore(
      params: params,
      success: (data) {
        EasyLoadingUtil.hidden();
        state.selectCommodityData = {};
        state.selectCommodityDataList = [];
        update();
        // Get.to(()=>CkSuccessPage());

        Get.to(() => SuccessPage(
              title: '出库指令已提交',
              content: Text(
                '（待仓库发货）',
                style: TextStyle(fontSize: 14.0, color: Color(0xff00CCCC)),
              ),
              // button: OutlinedButton(
              //   onPressed: () {},
              //   child: Text(
              //     '查看订单',
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),
            ));
        // ToastUtil.showMessage(message: '提交成功');
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );

    // print(ids);
    // print(state.consigneeData.toJson());
  }

  @override
  void onReady() {
    EasyLoadingUtil.showLoading();
    requestData();
    super.onReady();
  }

  @override
  void onClose() {
    // EasyLoadingUtil.popHidden();
    super.onClose();
  }
}
