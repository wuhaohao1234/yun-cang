import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/models/storage/cs_dck_model.dart';
import 'package:wms/views/commodity_kucun_cell_widget.dart';
import 'package:wms/views/commodity_sell_cell_widget.dart';
import 'cs_kucun_sell_succ_page.dart';
import 'package:wms/views/customer/storage/cs_kucun_defect_data_table.dart';
import 'cs_kucun_page.dart';

class CSKuCunSaleXiaCiPage extends StatefulWidget {
  final model;
  final int spuId;
  final int depotId;

  const CSKuCunSaleXiaCiPage({Key key, this.model, this.spuId, this.depotId})
      : super(key: key);

  @override
  _CSKuCunSaleXiaCiPageState createState() => _CSKuCunSaleXiaCiPageState();
}

class _CSKuCunSaleXiaCiPageState extends State<CSKuCunSaleXiaCiPage> {
  var dataModel = CsChuKuModel();
  var spuInfo = [];
  var spuXiaCiInfo = [];
  int expirationValue = 0; //0:3-5天，1:2周内，2:1个月内；
  var applet = false;
  var bazaar = false;
  double appletPrice;
  double bazaarPrice;
  bool xiaciInfo = false;
  var selectedStoreIndex = 0; //所选尺寸列表的索引
  var selectedDefectIndex = 0; //所选尺寸瑕疵列表的索引
  var selectedStoreId; //storeId
  var showDefectTableList = [];
  var reqArray = []; //出售提交list
  void initState() {
    super.initState();

    requestData();
    // requestDefectData();
  }

  Future<bool> requestData() async {
    // 获得瑕疵件点击出售详情
    EasyLoadingUtil.showLoading();
    print('get commodity sale info');
    var res = await HttpServices().spuShelfDefectDetail(
      depotId: widget.depotId,
      spuId: widget.spuId,
    );
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (res != null) {
      final data = res;
      // final total = res['total'];
      print(data);
      var all = data.map((e) => e['storeId']).toSet().toList();

      setState(() {
        spuInfo = data; //返回storeId与size
        spuInfo.insert(0, {'storeId': all, 'size': '全部'});

        selectedStoreId = spuInfo[selectedStoreIndex]['storeId'];
      });
      EasyLoadingUtil.hidden();
      requestDefectData(all, data.sublist(1));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestDefectData(storeId, sizeList) async {
    // 获得瑕疵件点击出售详情
    EasyLoadingUtil.showLoading();
    print('get commodity sale info');

    var res = await HttpServices()
        .spuShelfDefect(condition: storeId, pageSize: 10, pageNum: 1);
    if (res == false) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: '未获取到瑕疵品数据');
      setState(() {
        xiaciInfo = false;
        xiaciInfo = true;
        spuXiaCiInfo = [];
      });
      return false;
    }
    if (res != null) {
      final data = res;
      // final total = res['total'];
      print(data);
      if (data.length != 0) {
        setState(() {
          spuXiaCiInfo = data; //返回瑕疵件详细信息
          spuXiaCiInfo.forEach((each) => each['maxCount'] = 1);
          // spuXiaCiInfo.forEach((each) => each['id'] = each['storeId']);
          spuXiaCiInfo.forEach((each) => each['count'] = 0);
          spuXiaCiInfo.forEach((each) => each['status'] = 1);
          // defectList.forEach(
          //     (each) => each['size'] = sizeList.forEach((each) => each['size']));
          print(sizeList.length);
          print(spuXiaCiInfo.length);
          for (var i = 0; i < spuXiaCiInfo.length; i++) {
            if (i < sizeList.length) {
              spuXiaCiInfo[i]['size'] = sizeList[i]['size'];
            } else {
              spuXiaCiInfo[i]['size'] = sizeList[0]['size'];
            }
          }
          showDefectTableList = spuXiaCiInfo;
          xiaciInfo = true;
        });
      } else {
        EasyLoadingUtil.showMessage(message: '未获取到瑕疵品数据,测试数据');
        setState(() {
          xiaciInfo = true;
          spuXiaCiInfo = [];
        });
      }

      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

  //设置集市出售信息
  void updateSaleInfo(check, price, count) {
    setState(() {
      bazaarPrice = price;
      bazaar = check;
      print('ddfdf $bazaar');
      print('bp $bazaarPrice ');
    });
  }

  //设置小程序出售信息
  void updateSaleAppInfo(check, price, count) {
    setState(() {
      appletPrice = price;
      applet = check;
    });
  }

  Future<bool> postData() async {
    // 单品出售
    EasyLoadingUtil.showLoading(statusText: '出售商品中……');
    print('sale commodity');

    var data = await HttpServices().postSpuDefectShelf(
      reqArray: reqArray,
    );
    if (data is ErrorEntity) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: "请求错误: ${data.message}");
      return false;
    }
    if (data != null) {
      print(data);
      setState(() {});
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: '出售操作成功');
      var pageInfo = {
        'model': widget.model,
        'depotId': widget.depotId,
        'spuId': widget.spuId
      };
      print(pageInfo);
      Get.to(() => CSkuCunSellSuccessPage(
          model: pageInfo['model'],
          depotId: pageInfo['depotId'],
          spuId: pageInfo['spuId'],
          status: '1'));
      EasyLoadingUtil.hidden();
      return true;
    } else {
      EasyLoadingUtil.hidden();
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
            content: '单品出售',
            size: AppStyleConfig.navTitleSize,
          ),
          leading: BackButton(
            onPressed: () {
              Get.offAll(() => KuCunPage());
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: ScrollConfiguration(
            behavior: JKOverScrollBehavior(),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      CommodityKuCunCellWidget(model: widget.model),
                      SectionTitleWidget(title: '价格配置'),
                      if (spuInfo.length > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Wrap(
                                    children: List.generate(
                                      spuInfo.length,
                                      (index) => GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () => {
                                          print("cool"),
                                          setState(() {
                                            selectedDefectIndex =
                                                null ?? 0; //每次切换尺码按钮时设置瑕疵列表未选中；
                                            selectedStoreIndex = index;
                                            selectedStoreId =
                                                spuInfo[selectedStoreIndex]
                                                    ['storeId'];
                                            print(spuInfo.length);
                                            if (index == 0) {
                                              showDefectTableList =
                                                  spuXiaCiInfo;
                                            } else {
                                              showDefectTableList = spuXiaCiInfo
                                                  .where((each) =>
                                                      each['size'] ==
                                                      spuInfo[index]['size'])
                                                  .toList();
                                            }
                                            // expirationValue =
                                            //     spuXiaCiInfo[selectedStoreIndex]
                                            //         ['expiration'];
                                          })
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 10.w, bottom: 10.h),
                                          alignment: Alignment.center,
                                          width: 50.w,
                                          height: 50.w,
                                          decoration: BoxDecoration(
                                            color: Color(0xfff2f2f2),
                                            border: selectedStoreIndex == index
                                                ? Border.all(
                                                    width: 2.0,
                                                    color:
                                                        AppStyleConfig.btnColor)
                                                : null,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                spuInfo[index]['size'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SectionTitleWidget(title: '库存列表'),
                      if (xiaciInfo && showDefectTableList.length > 0)
                        Column(
                          children: [
                            DefectDataTable(
                              model: showDefectTableList,
                              selectedMultiModel: false,
                              onModelChangeCallback:
                                  (model, indexSelected, selected) {
                                setState(() {
                                  model[indexSelected]['selected'] = selected;

                                  if (selected) {
                                    model[indexSelected]['count'] = 1;
                                    print("model[indexSelected]['expiration']${model[indexSelected]['expiration']}");
                                    selectedDefectIndex = indexSelected;
                                    expirationValue =
                                        model[indexSelected]['expiration']??0;
                                  }
                                });
                              },
                            ),
                            if (showDefectTableList.length >
                                selectedDefectIndex)
                              CSKuCunSaleInheritedWidget(
                                  spuInfo:
                                      showDefectTableList[selectedDefectIndex],
                                  child: CommodityChoosePlatformWidget(
                                      normalMode: false,
                                      storeInfo: showDefectTableList[
                                          selectedDefectIndex],
                                      choosePlatform: 'bazaar',
                                      onChangeCallback: (check, price, count) {
                                        if (price == null) {
                                          EasyLoadingUtil.showMessage(
                                              message:
                                                  '当前价格为null，请重新勾选商品设置数量，更新价格');
                                        }
                                        updateSaleInfo(check, price, count);
                                      })),
                            if (showDefectTableList.length >
                                selectedDefectIndex)
                              CSKuCunSaleInheritedWidget(
                                  spuInfo:
                                      showDefectTableList[selectedDefectIndex],
                                  child: CommodityChoosePlatformWidget(
                                      normalMode: false,
                                      storeInfo: showDefectTableList[
                                          selectedDefectIndex],
                                      choosePlatform: 'app',
                                      onChangeCallback: (check, price, count) {
                                        if (price == null) {
                                          EasyLoadingUtil.showMessage(
                                              message:
                                                  '当前价格为null，请重新勾选商品设置数量，更新价格');
                                        }
                                        updateSaleAppInfo(check, price, count);
                                      })),

                            // CommodityChoosePlatformWidget(
                            //     choosePlatform: 'bazaar',
                            //     normalMode: false,
                            //     storeInfo:
                            //         showDefectTableList[selectedDefectIndex],
                            //     onChangeCallback: (check, price, count) {
                            //       if (price == null) {
                            //         EasyLoadingUtil.showMessage(
                            //             message:
                            //                 '当前价格为null，请重新勾选商品设置数量，更新价格');
                            //       }
                            //       setState(() {
                            //         bazaarPrice = price;
                            //         bazaar = check;
                            //         print('ddfdf $bazaar');
                            //         print('bp $bazaarPrice ');
                            //       });
                            //     }),
                            // if (showDefectTableList.length >
                            //     selectedDefectIndex)
                            //   CommodityChoosePlatformWidget(
                            //       choosePlatform: 'app',
                            //       normalMode: false,
                            //       storeInfo:
                            //           showDefectTableList[selectedDefectIndex],
                            //       onChangeCallback: (check, price, count) {
                            //         if (price == null) {
                            //           EasyLoadingUtil.showMessage(
                            //               message:
                            //                   '当前价格为null，请重新勾选商品设置数量，更新价格');
                            //         }
                            //         setState(() {
                            //           appletPrice = price;
                            //           applet = check;
                            //         });
                            //       }),
                            SizedBox(height: 20.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      "到货时效"), // Huzi@04/25: 这里可能要多加hinttext, 可能要多行
                                ),
                                SizedBox(width: 10.w),
                                // flawLevels,
                                Expanded(
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: '0',
                                          groupValue:
                                              expirationValue.toString(),
                                          activeColor: Colors.blue,
                                          onChanged: (value) {
                                            setState(() {
                                              expirationValue =
                                                  int.parse(value);
                                            });
                                          },
                                        ),
                                        WMSText(
                                          content: '3-5日',
                                        ),
                                        Radio(
                                          value: '1',
                                          groupValue:
                                              expirationValue.toString(),
                                          activeColor: Colors.blue,
                                          onChanged: (value) {
                                            setState(() {
                                              expirationValue =
                                                  int.parse(value);
                                            });
                                          },
                                        ),
                                        WMSText(
                                          content: '2周内',
                                        ),
                                        Radio(
                                          value: '2',
                                          groupValue:
                                              expirationValue.toString(),
                                          activeColor: Colors.blue,
                                          onChanged: (value) {
                                            setState(() {
                                              expirationValue =
                                                  int.parse(value);
                                            });
                                          },
                                        ),
                                        WMSText(
                                          content: '1个月内',
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SectionTitleWidget(title: '价格表'),
                            WMSText(
                              content: '此价格为历史销售价格，可用于参考。',
                              color: Colors.grey,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10.h),
                            WMSText(
                                content: '当以新的价格价格出售成功后，将覆盖更新价格信息。',
                                textAlign: TextAlign.start,
                                color: Colors.grey),
                            SizedBox(height: 10.h),
                            buildCommodityPriceTable(context),
                          ],
                        ),
                      // if (xiaciInfo ||
                      //     spuXiaCiInfo == [] ||
                      //     showDefectTableList == [])
                      //   Text('未查找到相关瑕疵品信息'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(90.w, 34.w)),
                      fixedSize: MaterialStateProperty.all(Size(343.w, 34.w)),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => !(applet == false &&
                                  bazaar == false &&
                                  expirationValue == null)
                              ? AppStyleConfig.btnColor
                              : null),
                    ),
                    onPressed: (applet == false &&
                            bazaar == false &&
                            expirationValue == null)
                        ? null
                        : () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            print(expirationValue);
                            //增加单个商品上架；
                            setState(() {
                              reqArray = [
                                {
                                  "prepareId":
                                      showDefectTableList[selectedDefectIndex]
                                          ['prepareId'],
                                  "applet": applet == true ? true : false,
                                  "appletPrice": appletPrice,
                                  "bazaar": bazaar == true ? true : false,
                                  "bazaarPrice": bazaarPrice,
                                  "expiration": expirationValue,
                                  "storeId":
                                      showDefectTableList[selectedDefectIndex]
                                          ['storeId'],
                                }
                              ];
                              print(reqArray);
                            });

                            postData();
                            // requestData();
                          },
                    child: Text(
                      xiaciInfo ? '瑕疵品上架' : '瑕疵品不可售',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

//创建价格表格

  Theme buildCommodityPriceTable(BuildContext context) {
    // var sizeList = spuInfo.map((e) => e['size']).toList().toSet().toList();
    // sizeList.insert(0, '尺码');
    var sizeList = spuXiaCiInfo.map((e) => e['prepareId'].toString()).toList();
    sizeList.insert(0, '编码');
    var appList = spuXiaCiInfo
        .map((e) => e['appPrice'] != null ? e['appPrice'] : '-')
        .toList();
    appList.insert(0, '小程序');
    var bazaarList = spuXiaCiInfo
        .map((e) => e['bazaarPrice'] != null ? e['bazaarPrice'] : '-')
        .toList();
    bazaarList.insert(0, '集市');
    print(sizeList.length);
    print(appList.length);
    print(bazaarList.length);
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: Colors.black, onPrimary: Colors.white),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 30.0),
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) => Color(0xfff2f2f2)),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12)),
              headingTextStyle:
                  TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
              columnSpacing: 20.0,
              columns: List.generate(
                sizeList.length,
                (index) => DataColumn(
                  label: Text(sizeList[index]),
                ),
              ),
              rows: [
                DataRow(
                  cells: List.generate(
                    bazaarList.length,
                    (index) => DataCell(Text(bazaarList[index].toString())),
                  ),
                ),
                DataRow(
                  cells: List.generate(
                    appList.length,
                    (index) => DataCell(Text(appList[index].toString())),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
