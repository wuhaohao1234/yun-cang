import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/models/storage/cs_dck_model.dart';
import 'package:wms/views/commodity_kucun_cell_widget.dart';
import 'package:wms/views/commodity_sell_cell_widget.dart';
import 'cs_kucun_sell_succ_page.dart';
import 'cs_kucun_page.dart';

class CSKuCunSalePage extends StatefulWidget {
  final model;
  final int spuId;
  final int depotId;
  final int initIndex;

  const CSKuCunSalePage({
    Key key,
    this.model,
    this.spuId,
    this.depotId,
    this.initIndex,
  }) : super(key: key);

  @override
  _CSKuCunSalePageState createState() => new _CSKuCunSalePageState();
}

class _CSKuCunSalePageState extends State<CSKuCunSalePage> {
// class _CSKuCunSalePageState extends State<CSKuCunSalePage> {
  var dataModel = CsChuKuModel();

  var expirationValue = "0"; //0:3-5天，1:2周内，2:1个月内；
  var applet = false;
  var bazaar = false;
  Map<String, num> appletDetails = {'count': 0, 'price': null};
  Map<String, num> bazaarDetails = {'count': 0, 'price': null};
  var spuInfo = []; //商品尺码性情list；
  var selectedStoreIndex = 0;
  var selectedStoreId;
  var selectedStoreInfo;
  var reqArray = []; //出售提交list

  Map get commonSelectedStoreInfo => selectedStoreInfo;

  @override
  void initState() {
    super.initState();
    requestData();
  }

  void updateSpuInfo(index) {
    setState(() {
      selectedStoreIndex = index;
      selectedStoreId = spuInfo[selectedStoreIndex]['storeId'];
      selectedStoreInfo = spuInfo[selectedStoreIndex];
    });
  }

//设置集市出售信息
  void updateSaleInfo(check, price, count) {
    setState(() {
      bazaarDetails['count'] = count;
      bazaarDetails['price'] = price;
      bazaar = check;
    });
  }

  //设置小程序出售信息
  void updateSaleAppInfo(check, price, count) {
    setState(() {
      appletDetails['count'] = count;
      appletDetails['price'] = price;
      applet = check;
    });
  }

//获取商品信息
  Future<bool> requestData() async {
    // 单品出售,查询出售信息详情
    EasyLoadingUtil.showLoading();
    print('get commodity sale info');
    var res = await HttpServices().spuShelfNormalDetail(
      depotId: widget.depotId,
      spuId: widget.spuId,
    );
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (res != null) {
      final data = res['data'];
      print(data);
      setState(() {
        spuInfo = data;
        selectedStoreIndex = widget.initIndex ?? 0;
        selectedStoreId = spuInfo[selectedStoreIndex]['storeId'];
        selectedStoreInfo = spuInfo[selectedStoreIndex];
      });

      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

  //提交商品出售信息
  Future<bool> postData() async {
    // 单品出售
    // EasyLoadingUtil.showLoading(statusText: '出售商品中……');
    print('sell commodity');
    print(reqArray);
    var data = await HttpServices().postSpuNormalShelf(reqArray: reqArray);
    if (data is ErrorEntity) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: "请求错误: ${data.message}");
      return false;
    }
    if (data != null) {
      print(data);
      // EasyLoadingUtil.showMessage(message: '出售操作成功');
      var pageInfo = {'model': widget.model, 'depotId': widget.depotId, 'spuId': widget.spuId};
      print(pageInfo);
      Get.to(() => CSkuCunSellSuccessPage(
          model: pageInfo['model'], depotId: pageInfo['depotId'], spuId: pageInfo['spuId'], status: '0'));
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
                    // BuildSizeWidget(spuInfo: spuInfo),

                    Visibility(
                      visible: spuInfo.length != 0 || spuInfo != null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
                        child: Wrap(
                          children: List.generate(
                            spuInfo.length,
                            (index) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => {
                                print(index),
                                setState(() {
                                  selectedStoreIndex = index;
                                  selectedStoreId = spuInfo[selectedStoreIndex]['storeId'];
                                  selectedStoreInfo = null;
                                  selectedStoreInfo = spuInfo[selectedStoreIndex];
                                  print(selectedStoreInfo);
                                  // state.updateItem();
                                }),
                              },
                              child: spuInfo.length != 0
                                  ? Container(
                                      margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
                                      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 2.w),
                                      alignment: Alignment.center,
                                      width: 50.w,
                                      // height: 50.w,
                                      decoration: BoxDecoration(
                                        color: Color(0xfff2f2f2),
                                        border: selectedStoreIndex == index
                                            ? Border.all(width: 2.0, color: AppStyleConfig.btnColor)
                                            : null,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${spuInfo[index]['size'] ?? '无尺码'}${spuInfo[index]['specification'] != null ? '/' + spuInfo[index]['specification'] : ""}',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                          // Text(
                                          //   ((spuInfo[index]['useCount'] ?? 0))
                                          //       .toString(),
                                          //   style: TextStyle(
                                          //       fontWeight: FontWeight.bold,
                                          //       color: Colors.black38),
                                          // ),
                                        ],
                                      ),
                                    )
                                  : Center(child: Text('暂无数据')),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //等待加载
                    if (spuInfo.length != 0 && selectedStoreInfo != null)
                      new CSKuCunSaleInheritedWidget(
                        spuInfo: selectedStoreInfo,
                        child: new CommodityChoosePlatformWidget(
                            normalMode: true,
                            storeInfo: selectedStoreInfo,
                            choosePlatform: 'bazaar',
                            onChangeCallback: (check, price, count) {
                              if (price == null) {
                                EasyLoadingUtil.showMessage(message: '当前价格为null，请重新勾选商品设置数量，更新价格');
                              }
                              updateSaleInfo(check, price, count);
                            }),
                      ),
                    if (spuInfo.length != 0 && selectedStoreInfo != null)
                      new CSKuCunSaleInheritedWidget(
                          spuInfo: selectedStoreInfo,
                          child: new CommodityChoosePlatformWidget(
                              normalMode: true,
                              storeInfo: selectedStoreInfo,
                              choosePlatform: 'app',
                              onChangeCallback: (check, price, count) {
                                if (price == null) {
                                  EasyLoadingUtil.showMessage(message: '当前价格为null，请重新勾选商品设置数量，更新价格');
                                }
                                updateSaleAppInfo(check, price, count);
                              })),

                    // new CommodityChoosePlatformWidget(
                    //     normalMode: true,
                    //     storeInfo: selectedStoreInfo,
                    //     choosePlatform: 'bazaar',
                    //     onChangeCallback: (check, price, count) {
                    //       if (price == null) {
                    //         EasyLoadingUtil.showMessage(
                    //             message: '当前价格为null，请重新勾选商品设置数量，更新价格');
                    //       }
                    //       setState(() {
                    //         bazaarDetails['count'] = count;
                    //         bazaarDetails['price'] = price;
                    //         bazaar = check;
                    //       });
                    //     }),
                    //等待加载

                    SizedBox(height: 20.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("到货时效"), // Huzi@04/25: 这里可能要多加hinttext, 可能要多行
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: FittedBox(
                            child: Row(
                              children: [
                                Radio(
                                  value: '0',
                                  groupValue: expirationValue,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      expirationValue = value;
                                    });
                                  },
                                ),
                                WMSText(
                                  content: '3-5日',
                                ),
                                Radio(
                                  value: '1',
                                  groupValue: expirationValue,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      expirationValue = value;
                                    });
                                  },
                                ),
                                WMSText(
                                  content: '2周内',
                                ),
                                Radio(
                                  value: '2',
                                  groupValue: expirationValue,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      expirationValue = value;
                                    });
                                  },
                                ),
                                WMSText(
                                  content: '1个月内',
                                ),
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
                      color: Colors.grey,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10.h),
                    Visibility(visible: spuInfo.length != 0, child: buildCommodityPriceTable(context)),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(90.w, 34.w)),
                    fixedSize: MaterialStateProperty.all(Size(343.w, 34.w)),
                    backgroundColor: MaterialStateProperty.resolveWith((states) =>
                        ((appletDetails['count'] != 0 && applet) || bazaarDetails['count'] != 0 && bazaar)
                            ? AppStyleConfig.btnColor
                            : null),
                  ),
                  onPressed: !((appletDetails['count'] != 0 && applet) || bazaarDetails['count'] != 0 && bazaar)
                      ? null
                      : () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          setState(() {
                            //增加单个商品上架；
                            reqArray = [
                              {
                                "applet": applet == true ? true : false,
                                "appletDetails": appletDetails,
                                "bazaar": bazaar == true ? true : false,
                                "bazaarDetails": bazaarDetails,
                                "expiration": int.parse(expirationValue),
                                "storeId": selectedStoreId,
                              }
                            ];
                            postData();
                          });
                        },
                  child: Text(
                    '上架完成',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                // ],
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Theme buildCommodityPriceTable(BuildContext context) {
    var sizeList = spuInfo.map((e) => e['size']).toList();
    sizeList.insert(0, '尺码');
    var appList = spuInfo.map((e) => e['appPrice'] != null ? e['appPrice'] : '-').toList();
    appList.insert(0, '小程序');
    var bazaarList = spuInfo.map((e) => e['bazaarPrice'] != null ? e['bazaarPrice'] : '-').toList();
    bazaarList.insert(0, '集市');
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(primary: Colors.black, onPrimary: Colors.white),
      ),
      child: Visibility(
        visible: sizeList.length != 0,
        child: Container(
          color: Theme.of(context).colorScheme.onPrimary,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 30.0),
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Color(0xfff2f2f2)),
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
                headingTextStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                columnSpacing: 20.0,
                columns: List.generate(
                  sizeList.length,
                  (index) => DataColumn(
                    label: Text(sizeList[index] ?? '无尺码'),
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
      ),
    );
  }
}
