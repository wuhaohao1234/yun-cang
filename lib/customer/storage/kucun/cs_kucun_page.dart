// 库存的列表界面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/commodity_kucun_cell_widget.dart';
import 'package:wms/views/commodity_kucun_chuku_cell_widget.dart';
import 'package:wms/models/storage/kucun_commodity_model.dart';
import '../zizhucang/cs_zizhucang_add_order_page.dart';
import 'cs_kucun_chuku_page.dart';
import 'cs_kucun_detail_page.dart';
import '../common/kc_select_widget/kc_select_widget_logic.dart';
import '../common/kc_select_widget/kc_select_widget_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';
import 'cs_kucun_sale_page.dart';
import 'cs_kucun_sale_xiaci_page.dart';
import '../../main/cs_main_page.dart';
import 'package:wms/views/customer/storage/cs_kucun_defect_data_table.dart';

// import 'package:wms/views/commodity_cell_widget.dart';
import 'package:wms/views/commodity_ybrk_choose_size_cell.dart';
// import 'package:wms/customer/storage/wv_ck_success_page.dart';
import 'package:wms/configs/wms_user.dart';

class KuCunPage extends StatefulWidget {
  const KuCunPage({Key key}) : super(key: key);

  State<KuCunPage> createState() => KuCunPageState();
}

class KuCunPageState extends State<KuCunPage> {
  final KcSelectWidgetLogic logic = Get.put(KcSelectWidgetLogic());
  final KcSelectWidgetState state = Get.find<KcSelectWidgetLogic>().state;

  int pageNum = 1;
  bool canMore = true;
  var searchContent = TextEditingController();
  var depotId;
  var oldDepotId;
  var categoryId;
  var status = 0; //商品状态
  var depotTagList = [];
  var commodityStatusList = ['正常件', '瑕疵件'];
  var commodityFilterList = [];
  var categoryList = [];
  var chukuList = [];
  var sellList = [];
  var xiaciInfoList = [];
  Timer _debounce;

  void onCellChuku(model) {
    // 点击出库按钮后的操作
    print(model.toJson());
    setState(() {
      //正常商品
      if (chukuList.indexWhere((element) => element.spuId == model.spuId) !=
          -1) {
        EasyLoadingUtil.showMessage(message: '该商品已在出库列表中');
        return false;
      }
      if (model.status == 0 || model.status == "0") {
        requestOutstoreNormalData(model);
      } else {
        requestOutstoreDefectData(model);
      }

      print(chukuList);
    });
  }

  @override
  void initState() {
    super.initState();

    print(WMSUser.getInstance().depotPower); //测试用户仓库权限
    requestDepotData();
    requestcategoryData();
    requestCommodityData();
  }

  Future<bool> requestDepotData() async {
    // 请求特定页面的数据
    var res = await HttpServices().getDepotTagList();
    if (res == false) {
      EasyLoadingUtil.showMessage(message: "获取后台仓库数据出错");
      return false;
    }
    final data = res["data"];

    if (data != null) {
      if (data.length == 0) {
        EasyLoadingUtil.showMessage(message: "获取后台仓库数据为空，使用构造数据");
      }
      print(data);
      setState(() {
        depotTagList = data;
        final depotCountNum = depotTagList.fold(
            0, (previousValue, element) => previousValue + element['countNum']);
        depotTagList.insert(
            0, {'depotName': '全仓', 'depotId': null, 'countNum': depotCountNum});
        print(depotTagList);
      });

      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestcategoryData() async {
    // 请求商品品类的数据
    var res = await HttpServices()
        .getCategoryList(depotId: depotId != null ? depotId : null);
    if (res == false) {
      EasyLoadingUtil.showMessage(message: "获取后台品类数据出错");
      return false;
    }
    final data = res["data"];

    if (data != null) {
      if (data.length == 0) {
        EasyLoadingUtil.hidden();
        setState(() {
          categoryList = [];
        });
        EasyLoadingUtil.showMessage(message: "获取后台品类数据为空");
      }
      print(data);
      setState(() {
        categoryList = data;
        final countNum = categoryList.fold(
            0, (previousValue, element) => previousValue + element['countNum']);
        categoryList.insert(0,
            {'categoryName': '全部', 'categoryId': null, 'countNum': countNum});
        print(categoryList);
      });

      return true;
    } else {
      return false;
    }
  }

  Future<void> onRefresh() async {
    setState(() {
      pageNum = 1;
      canMore = true;
    });
    await requestCommodityData();
  }

  Future<void> onLoad() async {
    if (canMore) {
      setState(() {
        pageNum += 1;
        EasyLoadingUtil.showMessage(message: "加载更多");
        requestCommodityData();
      });
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }

  Future<bool> requestCommodityData() async {
    // 搜索商品
    EasyLoadingUtil.showLoading();
    print('search commodity');

    final res = await HttpServices().getSpuList(
      pageSize: AppConfig.pageSize,
      pageNum: pageNum,
      status: status,
      categoryId: categoryId,
      depotId: depotId,
      searchContent: searchContent.text == '' ? null : searchContent.text,
    );
    if (res == false) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: "未查询到相关商品数据");
      return false;
    }
    if (res != null) {
      final data = res["data"];
      final total = res["total"];
      print(data);
      setState(() {
        if (pageNum == 1) {
          commodityFilterList =
              data.map((each) => KuCunCommodityModel.fromJson(each)).toList();
        } else {
          commodityFilterList.addAll(
              data.map((each) => KuCunCommodityModel.fromJson(each)).toList());
        }
        if (commodityFilterList.length == total) {
          // 可以加载更多
          canMore = false;
        } else {
          // 不可以加载更多
          canMore = true;
        }
        print("共计 $total, 目前${commodityFilterList.length}");
        EasyLoadingUtil.hidden();
      });
    }
    return true;
  }

  Future<bool> requestOutstoreNormalData(model) async {
    //客户端库存正常件spu尺码详情
    EasyLoadingUtil.showLoading();
    print('get commodity normal outstore info');
    var res = await HttpServices().csPostOutStoreNormalSize(
      depotId: model.depotId,
      spuId: model.spuId,
    );
    print(res);
    if (res['result'] == false) {
      EasyLoadingUtil.hidden();

      setState(() {
        model.wmsSkuList = [];
      });
      showDialog(
          context: context,
          builder: (BuildContext ctx) => wvDialog(
              widget: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                res['data'].message,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Icon(Icons.cancel))),
                          ],
                        ),
                      ]))));

      return false;
    }
    if (res['result'] == true) {
      final data = res['data'];

      setState(() {
        data.forEach((each) => each['maxCount'] = each['count']);
        data.forEach((each) => each['count'] = 0);

        model.wmsSkuList = data;
        if (data.length > 0) {
          setUpWidget(context, chooseOutStoreNormalContainer(model));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext ctx) => wvDialog(
                  widget: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 24.w),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '此商品无库存可出库',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Icon(Icons.cancel))),
                              ],
                            ),
                          ]))));
        }
      });
      EasyLoadingUtil.hidden();
      return true;
    } else {
      EasyLoadingUtil.showMessage(message: '未获取到正常商品出库尺码数据');

      return false;
    }
  }

  Future<bool> requestOutstoreDefectData(model) async {
    //客户端库存瑕疵spu尺码详情
    EasyLoadingUtil.showLoading();
    print('get commodity defect outStore info');
    var res = await HttpServices().csPostOutStoreDefectSize(
      depotId: model.depotId,
      spuId: model.spuId,
    );
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (res != null) {
      final data = res['data'];

      var all = data.map((e) => e['storeId']).toSet().toList();

      setState(() {
        if (data.length != 0) {
          model.skuList = data;
          model.skuList.insert(0, {'storeId': all, 'size': '全部'});
        } else {
          showDialog(
              context: context,
              builder: (BuildContext ctx) => wvDialog(
                  widget: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 24.w),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '此商品无库存可出库',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Icon(Icons.cancel))),
                              ],
                            ),
                          ]))));
        }
      });
      //设置所有瑕疵尺码列表信息；

      var defectListInit =
          await requestOutStoreDefectSizeList(model, all, data.sublist(1));
      // 首先进入页面时选择展示全部的瑕疵商品信息；

      setUpWidget(
          context,
          DefectWidgetBottomContainer(
              model: model, defectList: defectListInit, depotId: depotId));
      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

  Future requestOutStoreDefectSizeList(model, storeId, sizeList) async {
    // 查询瑕疵商品的列表

    EasyLoadingUtil.showLoading();
    print('get commodity defect outstore  detail info');
    var res = await HttpServices().csPostOutStoreDefectSizeList(
      condition: storeId,
      pageNum: 1,
      pageSize: 10,
    );
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (res != null) {
      final data = res['data'];
      // print(data);
      setState(() {
        var defectList;
        if (data.length == 0) {
          defectList = [];
          showDialog(
              context: context,
              builder: (BuildContext ctx) => wvDialog(
                  widget: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 24.w),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '此商品无库存可出库',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Icon(Icons.cancel))),
                              ],
                            ),
                          ]))));
        } else {
          defectList = data;
        }
        defectList.forEach((each) => each['maxCount'] = 1);
        // defectList.forEach((each) => each['id'] = each['storeId']);
        defectList.forEach((each) => each['count'] = 0);
        defectList.forEach((each) => each['status'] = 1);
        // defectList.forEach(
        //     (each) => each['size'] = sizeList.forEach((each) => each['size']));
        print(sizeList.length);
        print(defectList.length);
        for (var i = 0; i < defectList.length; i++) {
          if (i < sizeList.length) {
            defectList[i]['size'] = sizeList[i]['size'];
          } else {
            defectList[i]['size'] = sizeList[0]['size'];
          }
        }
        model.wmsSkuList = defectList;
      });

      EasyLoadingUtil.hidden();
      return model.wmsSkuList;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '库存列表',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => CSMainPage());
          },
        ),
      ),
      body: Container(
          // padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ScrollConfiguration(
              behavior: JKOverScrollBehavior(),
              child: Container(
                child: Column(
                  children: [
                    // 搜索栏
                    Padding(
                      padding: EdgeInsets.only(top: 0.h),
                      child: Container(
                        height: 52.0,
                        child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      if (WMSUser.getInstance().depotPower) {
                                        // EasyLoadingUtil.showMessage(
                                        //     message: "进入库存自主仓页面");

                                        Get.to(() => CSZiZhuCangAddOrderPage(
                                            commodityList: []));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext ctx) =>
                                                wvDialog(
                                                    widget: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 20.h,
                                                                horizontal:
                                                                    24.w),
                                                        child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    child: Text(
                                                                      '普通商户无自主仓权限，升级请联系客服',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            Navigator.of(context).pop(false);
                                                                          },
                                                                          child: Icon(Icons.cancel))),
                                                                ],
                                                              ),
                                                            ]))));
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      'assets/svgs/新增1.svg',
                                      width: 17.w,
                                    )),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey[200]),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: TextField(
                                              onSubmitted: (value) {
                                                FocusScopeNode currentFocus =
                                                    FocusScope.of(context);

                                                if (!currentFocus
                                                    .hasPrimaryFocus) {
                                                  currentFocus.unfocus();
                                                }
                                                requestCommodityData();
                                              },
                                              onChanged: (value) {
                                                if (_debounce?.isActive ??
                                                    false) _debounce.cancel();
                                                _debounce = Timer(
                                                    const Duration(
                                                        milliseconds: 1000),
                                                    () {
                                                  // do something with query
                                                  setState(() {});
                                                  requestCommodityData();
                                                  FocusScopeNode currentFocus =
                                                      FocusScope.of(context);

                                                  if (!currentFocus
                                                      .hasPrimaryFocus) {
                                                    currentFocus.unfocus();
                                                  }
                                                });
                                              },

                                              controller: searchContent,
                                              keyboardType: TextInputType.text,

                                              ///控制键盘的功能键 指enter键，比如此处设置为next时，enter键
                                              textInputAction:
                                                  TextInputAction.search,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: -8.h),
                                                  hintText: '请输入商品搜索内容',
                                                  hintStyle: TextStyle(
                                                      fontSize: 13.sp),
                                                  border: InputBorder.none),
                                              // onChanged: onSearchTextChanged,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: new Icon(Icons.cancel),
                                          color: Colors.grey,
                                          iconSize: 18.0,
                                          onPressed: () {
                                            searchContent.text = '';
                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);

                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                            requestCommodityData();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    // 全仓国内仓等

                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 2.w,
                          runSpacing: 5.h,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: List<Widget>.generate(
                            depotTagList.length,
                            (int index) => TagWidget(
                                width: 100,
                                activeBgColor: Colors.black,
                                activeFgColor: Colors.white,
                                baseFgColor: Colors.black,
                                chooseValue: depotId,
                                value: depotTagList[index]['depotId'],
                                text: '${depotTagList[index]['depotName']}',
                                // +
                                //     '(${depotTagList[index]['countNum'].toString()})',
                                callback: () {
                                  setState(() {
                                    oldDepotId = depotId;
                                    depotId = depotTagList[index]['depotId'];
                                    // print(depotId);
                                    // print(depotTagList[index]['depotName']);
                                    setState(() {
                                      pageNum=1;
                                    });
                                    requestCommodityData();
                                  });
                                }),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: Row(
                        children: [
                          // 左侧
                          //样式问题，键盘弹出后有黄色溢出区域，键盘挤占了原先品类列表的空间
                          Container(
                            color: Colors.grey[200],
                            width: 80,
                            child: categoryList.length == 0
                                ? null
                                : ListView.builder(
                                    itemCount: categoryList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return TagWidget(
                                          width: 80,
                                          chooseValue: categoryId,
                                          height: 30,
                                          horizontalMargin: 0,
                                          hasRadius: false,
                                          padding: 10,
                                          baseBgColor: Colors.grey[200],
                                          text:
                                              // '${categoryList[index]['categoryName']}(${categoryList[index]['countNum']})',
                                              '${categoryList[index]['categoryName']}',
                                          value: categoryList[index]
                                              ['categoryId'],
                                          callback: () {
                                            setState(() {
                                              categoryId = categoryList[index]
                                                  ['categoryId'];
                                              // print(this.categoryList[index]);
                                              // print(categoryId);
                                              requestCommodityData();
                                            });
                                          });
                                    },
                                  ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          // 右侧
                          Expanded(
                            child: Column(
                              children: [
                                // 区分正常瑕疵
                                Container(
                                  height: 30.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List<Widget>.generate(
                                      commodityStatusList.length,
                                      (int index) => TagWidget(
                                        chooseValue: status,
                                        value: index,
                                        width: 100,
                                        height: 30,
                                        activeBgColor: Colors.black,
                                        activeFgColor: Colors.white,
                                        baseFgColor: Colors.black,
                                        text: commodityStatusList[index],
                                        callback: () {
                                          setState(() {
                                            status = index;
                                            requestCommodityData();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // 显示缩小的正常件或者瑕疵件
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          height: 20.h,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.h),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.h, horizontal: 2.h),
                                          color: Colors.grey[200],
                                          child: Text(
                                            commodityStatusList[status],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 10),
                                          )),
                                    ),
                                  ],
                                ),
                                // 商品列表
                                Expanded(
                                  child: RefreshView(
                                    header: MaterialHeader(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                    ),
                                    onRefresh: onRefresh,
                                    onLoad: onLoad,
                                    child: commodityFilterList.length != 0
                                        ? ListView.builder(
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {

                                                  Get.to(() => CSKuCunDetailPage(
                                                      status:status,
                                                      spuId:
                                                          commodityFilterList[
                                                                  index]
                                                              .spuId,
                                                      depotId:
                                                          commodityFilterList[
                                                                  index]
                                                              .depotId,
                                                      model:
                                                          commodityFilterList[
                                                              index]));
                                                },
                                                child: CommodityKuCunCellWidget(
                                                  model: commodityFilterList[
                                                      index],
                                                  buttonVisibility:
                                                      depotId != null
                                                          ? true
                                                          : false,
                                                  userCountShow: true,
                                                  // 点击出库按钮
                                                  onCellChuku: (model) {
                                                    onCellChuku(model);
                                                  },
                                                  // 点击出售按钮
                                                  onCellSell: (model) {
                                                    if (model.status == 1) {
                                                      Get.to(() => CSKuCunSaleXiaCiPage(
                                                          spuId:
                                                              commodityFilterList[
                                                                      index]
                                                                  .spuId,
                                                          depotId:
                                                              commodityFilterList[
                                                                      index]
                                                                  .depotId,
                                                          model:
                                                              commodityFilterList[
                                                                  index]));
                                                    } else {
                                                      Get.to(
                                                        () {
                                                          return CSKuCunSalePage(
                                                            spuId:
                                                                commodityFilterList[
                                                                        index]
                                                                    .spuId,
                                                            depotId:
                                                                commodityFilterList[
                                                                        index]
                                                                    .depotId,
                                                            model:
                                                                commodityFilterList[
                                                                    index],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                            itemCount:
                                                commodityFilterList.length,
                                          )
                                        : Center(
                                            child: Text('暂无数据'),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: '',

              child: Icon(Icons.insert_drive_file,color: chukuList.length==0?Colors.grey:Colors.green),
              onPressed: () {
                setUpWidget(context, upContainer());

                // 弹出出仓物品清单接口
              },
            ),
            FloatingActionButton(
              heroTag: '待出库',
              child: Text('待出库'),
              onPressed: () {
                if (chukuList.length == 0) {
                  EasyLoadingUtil.showMessage(message: "出库商品列表为空，请添加出库商品");
                }
                if (chukuList.length != 0) {
                  if (oldDepotId == depotId) {
                    EasyLoadingUtil.showMessage(message: "进入库存商品出库页面");

                    Get.to(() => CSKuCunChuKuPostPage(model: chukuList));
                  } else {
                    WMSDialog.showOperationPromptDialog(context,
                        content: '您有未完成的出库单，是否继续完成，或新建出库？',
                        confirmStr: '新建出库',
                        handle: () async {
                          setState(() {
                            EasyLoadingUtil.showMessage(message: '已清空出库单');
                            chukuList = [];
                          });
                          // EasyLoadingUtil.showLoading(statusText: "...");
                        },
                        cancelStr: '继续完成',
                        cancelHandle: () {
                          setUpWidget(context, upContainer());
                        });
                  }
                }

                // logic.onTapCommitHandle(context);
                // 调获取出仓物品清单接口《/app/inventory/confirm_out/list》
                // 弹出出仓物品清单接口
              },
            ),
          ],
        ),
      ),
    );
  }

//设置正常件出库尺寸选择
  Widget chooseOutStoreNormalContainer(model) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 30.0,
                bottom: 10.0,
                left: 15.0,
                right: 15.0,
              ),
              child: Text('手动选择'),
            ),
            Divider(),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: Color(0xfff2f2f2)))),
                      child: IntrinsicHeight(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (model.wmsSkuList != null &&
                              model.wmsSkuList.length != 0)
                            Container(
                                height: model.wmsSkuList != null
                                    ? (model.wmsSkuList.length ?? 0) * 40.h
                                    : 0.h,
                                child: buildCommoditySizeList(
                                    context, model.wmsSkuList, true)),
                        ],
                        mainAxisSize: MainAxisSize.max,
                      )),
                    )),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Center(
                child: WMSButton(
                    title: '确定',
                    bgColor: AppConfig.themeColor,
                    callback: () {
                      setState(() {
                        for (var j = 0; j < model.wmsSkuList.length; j++) {
                          if (model.wmsSkuList[j]['count'] == null) {
                            model.wmsSkuList.removeAt(j);
                          }
                        }
                        chukuList.add(model);
                        EasyLoadingUtil.showMessage(message: "该商品已加入出库单");
                      });
                      Navigator.pop(context);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

//底部待出库清单
  Widget upContainer() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('清单(${chukuList.length.toString() ?? ''})'),
                  IconButton(
                      icon: new Icon(Icons.cancel),
                      color: Colors.grey,
                      iconSize: 18.0,
                      onPressed: () {
                        setState(() {
                          EasyLoadingUtil.showMessage(message: '已清空出库单');
                          chukuList = [];
                        });
                        Navigator.of(context).pop(false);
                      }),
                ],
              ),
            ),
            Divider(),
            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2.5),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      chukuList.length,
                      (index) {
                        var _item = chukuList[index];
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Color(0xfff2f2f2)))),
                          child: IntrinsicHeight(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommodityKuCunChuKuCellWidget(
                                  model: _item, status: "0"),
                              Visibility(
                                visible: _item.wmsSkuList != null &&
                                    _item.wmsSkuList.length != 0,
                                child: Container(
                                    height: _item.wmsSkuList != null
                                        ? (_item.wmsSkuList.length ?? 0) * 40.h
                                        : 0.h,
                                    child: buildCommoditySizeList(
                                        context, _item.wmsSkuList, true)),
                              )
                            ],
                            mainAxisSize: MainAxisSize.max,
                          )),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Center(
                child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(343.w, 34.w)),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => chukuList.length == 0
                              ? null
                              : AppStyleConfig.btnColor),
                    ),
                    child: Text(
                      '提交出库信息',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    onPressed: chukuList.length == 0
                        // chukuList.fold(
                        //         0,
                        //         (previousValue, element) =>
                        //             previousValue +
                        //             element.wmsSkuList.fold(
                        //                 0,
                        //                 (previousValue, e) =>
                        //                     previousValue + e['count'])) ==
                        //     0
                        ? null
                        : () {
                            print(depotId);
                            Navigator.of(context).pop(false);
                            Get.to(() => CSKuCunChuKuPostPage(
                                model: chukuList,
                                depotId: depotId,
                                status: "0"));
                          }),
              ),
            )
          ],
        ),
      ),
    );
  }

//设置正常件出库尺寸页面
  Widget buildCommoditySizeList(
      BuildContext context, skuSizeList, itemCheckValue) {
    return skuSizeList != null
        ? ListView.builder(
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var maxCount = skuSizeList[index]['maxCount'];
              return CommodityChooseSizeWidget(
                initNumber: skuSizeList[index]['count'],
                size: skuSizeList[index]['size'],
                specification: skuSizeList[index]['specification'],
                hintText: '库存${maxCount.toString()}',
                checkButtonshow: false,
                compareNumber: maxCount,
                compareStatus: true,
                onChangeCallback: (value) {
                  setState(() {
                    skuSizeList[index]['count'] = value;
                    print(skuSizeList);
                  });
                },
              );
            },
            itemCount: skuSizeList.length ?? 0,
          )
        : Center(child: Text('无尺码数据'));
  }
}

//设置瑕疵商品的列表信息
class DefectWidgetBottomContainer extends StatefulWidget {
  final model;
  final depotId;
  final defectList;
  const DefectWidgetBottomContainer(
      {Key key, this.model, this.defectList, this.depotId})
      : super(key: key);

  @override
  State<DefectWidgetBottomContainer> createState() =>
      _DefectWidgetBottomContainerState();
}

class _DefectWidgetBottomContainerState
    extends State<DefectWidgetBottomContainer> {
  var indexSelected;
  var showModel;
  @override
  void initState() {
    super.initState();
    showModel = widget.defectList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 30.0,
                bottom: 10.0,
                left: 15.0,
                right: 15.0,
              ),
              child: Text('手动选择'),
            ),
            Divider(),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color: Color(0xfff2f2f2),
                            ),
                          ),
                        ),
                        child: IntrinsicHeight(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Visibility(
                              visible: widget.model.skuList.length != 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //设置尺寸列表
                                    Column(
                                      children: [
                                        BuildSizeListwidget(
                                          sizeList: widget.model.skuList,
                                          onChangeCallback: (value) {
                                            print(value);
                                            if (value == 0) {
                                              showModel = widget.defectList;
                                            } else {
                                              showModel = widget.defectList
                                                  .where((each) =>
                                                      each['size'] ==
                                                      widget.model
                                                              .skuList[value]
                                                          ['size'])
                                                  .toList();
                                            }

                                            setState(() {
                                              indexSelected = value;
                                              if (value == 0) {
                                                showModel = widget.defectList;
                                              } else {
                                                showModel = widget.defectList
                                                    .where((each) =>
                                                        each['size'] ==
                                                        widget.model
                                                                .skuList[value]
                                                            ['size'])
                                                    .toList();
                                              }

                                              print("sddssd");
                                              print(showModel);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          mainAxisSize: MainAxisSize.max,
                        )),
                      ),
                      DefectDataTable(
                        model: showModel ?? widget.defectList,
                        onModelChangeCallback:
                            (model, indexSelected, selected) {
                          setState(() {
                            showModel[indexSelected]['selected'] = selected;
                            if (selected) {
                              showModel[indexSelected]['count'] = 1;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 表格部分

            Container(
              padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
              child: Center(
                child: buildButtonWidget(
                  width: 384.w,
                  height: 34.h,
                  buttonContent: '确定出库',
                  bgColor: AppConfig.themeColor,
                  contentColor: Colors.white,
                  handelClick: () {
                    var chukuList = widget.model;

                    // for (var j = 0; j < chukuList.wmsSkuList.length; j++) {
                    //   if (chukuList.wmsSkuList[j]['count'] == 0) {
                    //     chukuList.wmsSkuList.removeAt(j);
                    //   }
                    // }
                    Get.to(() => CSKuCunChuKuPostPage(
                          model: [chukuList],
                          depotId: widget.depotId,
                          status: '1',
                        ));
                  },
                  radius: 2.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
