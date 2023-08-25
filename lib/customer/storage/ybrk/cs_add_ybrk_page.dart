// 预约入库、添加商品页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'cs_post_ybrk_page.dart';
import '../../../views/common/common_search_bar.dart';
import 'cs_add_commodity_page.dart';
import 'cs_serach_commodity_page.dart';
import 'package:wms/views/commodity_cell_widget.dart';
import 'package:wms/views/commodity_ybrk_choose_size_cell.dart';
import 'package:wms/views/commodity_table_head_cell_widget.dart';
import 'package:wms/views/commodity_sku_cell_widget.dart';
import 'cs_ybrk_tab_page.dart';

class CSYbrkAddPage extends StatefulWidget {
  final String orderIdName;
  const CSYbrkAddPage({Key key, this.orderIdName}) : super(key: key);

  @override
  _CSYbrkAddPageState createState() => _CSYbrkAddPageState();
}

class _CSYbrkAddPageState extends State<CSYbrkAddPage> {
  List depotList = [];
  List tempCommodityList = []; //临时商品列表
  List ybrkCommodityList = []; //预约清单商品列表
  var _depotValue = 1;
  var _orderOperationalRequirements = 0;
  var orderIdName; //获取orderIdName

//获取仓库数据
  Future<bool> requestDepotData() async {
    var data = await HttpServices().prepareOrderDepotList();
    if (data != null) {
      print(data);
      setState(() {
        depotList = data;
        _depotValue = data[0]['id'];
        print(depotList);
      });

      return true;
    } else {
      return false;
    }
  }

  // 请求数据
  void requestData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();

    var data = await HttpServices().prepareOrderDetailList(
      orderId: '0',
      status: '0',
    );
    print(data);
    if (data == false) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: '未获取相关数据');
    }
    if (data != null) {
      print(data);
      ybrkCommodityList = data.wmsCommodityInfoVOList;
      EasyLoadingUtil.hidden();
    } else {}
  }

  //获取预约入库绑定商品数据；
  Future<bool> requestCommodityData() async {
    EasyLoadingUtil.showLoading();
    var resCommodityList = await HttpServices().csGetSku(
      orderIdName: widget.orderIdName ?? orderIdName,
      pageNum: 0,
      pageSize: 10000,
    );
    if (resCommodityList == false) {
      setState(() {
        ybrkCommodityList = ybrkCommodityList;
      });
    }
    if (resCommodityList != null) {
      final data = resCommodityList;
      setState(() {
        ybrkCommodityList = data;
      });
      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    requestDepotData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '预约入库-添加商品',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: TextButton(
          child: WMSText(
            content: '取消',
            color: Colors.grey,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        WMSText(content: '预约仓库'),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          child: DropdownButton(
                            value: _depotValue,
                            onChanged: (value) {
                              setState(() => {_depotValue = value});
                            },
                            items: List<DropdownMenuItem>.generate(
                                depotList.length,
                                (int index) => DropdownMenuItem(
                                    child: Text(depotList[index]['depotName']),
                                    value: depotList[index]['id'])),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        WMSText(content: '入库要求'),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          child: DropdownButton(
                            items: [
                              DropdownMenuItem(
                                  child: Text('仅理货点数'), value: '0'),
                              DropdownMenuItem(child: Text('质检拍照'), value: '1'),
                              DropdownMenuItem(child: Text('临时存放'), value: '2')
                            ],
                            onChanged: (value) {
                              setState(() => {
                                    _orderOperationalRequirements =
                                        int.parse(value)
                                  });
                            },
                            value: _orderOperationalRequirements.toString(),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionTitleWidget(
                          title: '商品信息',
                        ),
                        // WMSButton(
                        //     height: 20.h,
                        //     width: 70.w,
                        //     fontSize: 12.sp,
                        //     bgColor: Colors.transparent,
                        //     textColor: Colors.black,
                        //     showBorder: true,
                        //     title: '申请新品',
                        //     callback: () async {
                        //       //新增其他页面商品数据
                        //       var commoditydata =
                        //           await Get.to(() => CSYbrkAddCommodityPage(
                        //                 orderIdName: orderIdName,
                        //               ));
                        //       if (commoditydata != null) {
                        //         setState(() {
                        //           if (commoditydata['orderIdName'] != null) {
                        //             orderIdName = commoditydata['orderIdName'];
                        //             requestCommodityData();
                        //           }
                        //           EasyLoadingUtil.hidden();
                        //           return true;
                        //         });
                        //       }
                        //     }),
                      ],
                    ),
                    Container(
                      child: CommonSearchBar(
                          placeHolder: '添加预约商品',
                          width: 300.w,
                          showScanIcon: false,
                          searchCallBack: () async {
                            //获取其他页面搜索数据
                            var commoditydata = await Get.to(() =>
                                CSSearchCommodityPage(
                                    postCommodityList:
                                        tempCommodityList + ybrkCommodityList));
                            print("back");
                            print(commoditydata);
                            if (commoditydata != null) {
                              setState(() {
                                tempCommodityList.addAll(commoditydata);

                                print(tempCommodityList);
                                EasyLoadingUtil.hidden();
                                return true;
                              });
                            }
                          }
                          ),
                    ),

                    if (tempCommodityList.length != 0)
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: buildList(tempCommodityList),
                            // child: Text("good")
                          ),
                        ],
                      ),
                    Column(
                      children: [
                        if (ybrkCommodityList.length != 0) ...[
                          SectionTitleWidget(
                            title: '预约入库商品信息',
                          ),
                          Column(
                            children: [
                              Container(
                                color: Colors.white,
                                child: buildCommodityList(ybrkCommodityList),
                                // child: Text("goodx"),
                              ),
                            ],
                          )
                        ],
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(140.w, 34.w)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => ybrkCommodityList.length != null &&
                                    ybrkCommodityList.length != 0
                                ? AppStyleConfig.btnColor
                                : null),
                      ),
                      onPressed: ybrkCommodityList.length == null ||
                              ybrkCommodityList.length == 0
                          ? null
                          : () async {
                              FocusScope.of(context).requestFocus(FocusNode());

                              EasyLoadingUtil.showLoading();

                              final value =
                                  await HttpServices().addPrepareOrder(
                                depotId: _depotValue,
                                orderOperationalRequirements:
                                    _orderOperationalRequirements,
                                orderIdName: orderIdName,
                                status: '4',
                              );
                              if (value == false) {
                                EasyLoadingUtil.hidden();
                                EasyLoadingUtil.showMessage(
                                    message: '未成功提交预约数据');
                                return false;
                              }
                              if (value != null) {
                                EasyLoadingUtil.showMessage(
                                    message: '已提交预约入库数据');
                              }

                              Get.to(() => CSYbrkTabPage(defaultIndex: 0));
                            },
                      child: Text(
                        '暂存',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(140.w, 34.w)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => ybrkCommodityList.length != null &&
                                    ybrkCommodityList.length != 0
                                ? AppStyleConfig.btnColor
                                : null),
                      ),
                      onPressed: ybrkCommodityList.length == null ||
                              ybrkCommodityList.length == 0
                          ? null
                          : () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              Get.to(() => CSYbrkPostPage(
                                    depotId: _depotValue,
                                    orderIdName: orderIdName,
                                    orderOperationalRequirements:
                                        _orderOperationalRequirements,
                                    httpType: 0, //直接新建预约入库api
                                  ));
                            },
                      child: Text(
                        '生成预约单',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //temp商品清单
  Widget buildList(comodityList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.h,
                color: Colors.grey[200],
              ),
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  CommodityCellWidget(
                    picturePath: comodityList[index]['picturePath'] ?? '',
                    name: comodityList[index]['commodityName'],
                    brandName: comodityList[index]['brandName'],
                    stockCode: comodityList[index]['stockCode'] ?? '',
                  ),
                  Positioned(
                    child: IconButton(
                      icon: new Icon(Icons.cancel),
                      color: Colors.grey,
                      iconSize: 18.0,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) => AlertDialog(
                                  title: Text("删除提示"),
                                  content: Text("确认删除此商品？"),
                                  actions: <Widget>[
                                    buildButtonWidget(
                                      width: 120.w,
                                      height: 34.h,
                                      buttonContent: '取消',
                                      handelClick: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      radius: 2.0,
                                    ),
                                    buildButtonWidget(
                                      width: 120.w,
                                      height: 34.h,
                                      bgColor: AppConfig.themeColor,
                                      contentColor: Colors.white,
                                      buttonContent: '确认',
                                      handelClick: () {
                                        // widget.onDeleteFunc(widget.skuIndex);
                                        Navigator.of(context).pop(true);
                                        setState(() {
                                          // tempCommodityList.removeAt(index);
                                          comodityList.removeAt(index);
                                        });
                                        EasyLoadingUtil.showMessage(
                                            message: '已删除此数据');
                                      },
                                      radius: 2.0,
                                    ),
                                  ],
                                ));
                      },
                    ),
                    top: 5,
                    right: 5,
                  )
                ],
              ),
              // 商品的尺码选择信息
              CommoditySizeList(
                skuSizeList: comodityList[index]['skuDataList'],
                stockCode: comodityList[index]['stockCode'],
                onCommodityNumChange: (id, value) {
                  print(
                      "${comodityList[index]['skuDataList']}的第$id 个变成了 $value ");
                  setState(() {
                    comodityList[index]['skuDataList'][id]['commodityNumber'] =
                        value;
                  });
                },
              ),
              Container(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  child: Text("添加"),
                  onPressed: () async {
                    //设置加入清单时提交的内容；

                    var temp = comodityList[index];
                    List newSkus = [];

                    for (var j = 0; j < temp['skuDataList'].length; j++) {
                      if (temp['skuDataList'][j]['commodityNumber'] == null ||
                          temp['skuDataList'][j]['commodityNumber'] <= 0) {
                        // temp['skuDataList'].removeAt(j);
                        // 这一行没有必要, 删去
                      } else {
                        newSkus.add(temp['skuDataList'][j]);
                      }
                    }
                    if (newSkus.length == 0) {
                      EasyLoadingUtil.showMessage(message: '商品数量不可为0');
                      return false;
                    } else {
                      print(newSkus);
                      EasyLoadingUtil.showMessage(message: '已添加该商品');
                    }
                    print(temp['skuDataList']);
                    temp['skuDataList'] = newSkus;

                    var data = await HttpServices().csAddSku(
                        orderIdName: orderIdName ?? null,
                        wmsSpuDetailList: [temp]);
                    if (data == false) {
                      EasyLoadingUtil.showMessage(message: '当前orderIdName不存在');
                      return false;
                    }
                    print(data);
                    if (data != null) {
                      EasyLoadingUtil.showMessage(message: '已加入预约入库清单');

                      setState(() {
                        orderIdName = data['orderIdName'] ?? '';
                        requestCommodityData();
                        comodityList.removeAt(index);
                      });

                      return true;
                    } else {
                      return false;
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
      itemCount: comodityList.length ?? 0,
    );
  }

  Widget buildCommodityList(list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        //index为预报入库商品清单的index
        return Column(
          children: [
            CommodityCellWidget(
              picturePath: list[index]['picturePath'] ?? '',
              name: list[index]['commodityName'],
              brandName: list[index]['brandName'],
              stockCode: list[index]['stockCode'] ?? '',
            ),
            if (list[index]['skuDataList'].length != 0)
              buildTableHeadWdidget([
                '尺码/规格',
                '入库数量',
                '操作',
              ]),
            buildSKuInfoWdidget(
              skuCodeShow: false,
              editable: true,
              list: list[index]['skuDataList'],
              removeButton: true,
              onDeleteFunc: (skuIndex) async {
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
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              '删除提示',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '您确定要删除选中的尺码吗？',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '若需增加该商品其他尺码，请删除所有尺码，重新搜索添加商品',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildButtonWidget(
                                width: 120.w,
                                height: 34.h,
                                buttonContent: '取消',
                                handelClick: () {
                                  Navigator.of(context).pop(false);
                                },
                                radius: 2.0,
                              ),
                              buildButtonWidget(
                                width: 120.w,
                                height: 34.h,
                                buttonContent: '确认',
                                bgColor: AppConfig.themeColor,
                                contentColor: Colors.white,
                                handelClick: () async {
                                  // widget.onDeleteFunc(widget.skuIndex);
                                  Navigator.of(context).pop(true);
                                  final value = await HttpServices().csDeleSku(
                                    orderIdName: orderIdName,
                                    uuid: list[index]['skuDataList'][skuIndex]
                                        ['uuid'],
                                  );
                                  print(value);
                                  if (value == null) {
                                    // setState(() {
                                    //   list[index]['skuDataList']
                                    //       .removeAt(skuIndex);
                                    // });
                                    // EasyLoadingUtil.showLoading(statusText: "...");
                                    EasyLoadingUtil.showMessage(
                                        message: '已删除此数据');
                                  }
                                  requestCommodityData();
                                  EasyLoadingUtil.hidden();
                                },
                                radius: 2.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                // Navigator.of(context).pop(true);
              },
              onEditNumFunc: (skuIndex, setNumber) async {
                // Navigator.of(context).pop(true);

                final value = await HttpServices().csUpdataCommodityNumber(
                  orderIdName: orderIdName,
                  uuid: list[index]['skuDataList'][skuIndex]['uuid'],
                  commodityNumber: int.parse(setNumber),
                );
                print(value);
                if (value == false) {
                  EasyLoadingUtil.showMessage(message: '出现错误');
                  return false;
                }
                //正常结果
                if (value == null) {
                  EasyLoadingUtil.showMessage(message: '已更新数量');
                  setState(() {
                    list[index]['skuDataList'][skuIndex]['commodityNumber'] =
                        int.parse(setNumber);
                  });

                  // Get.to(() => CSYbrkTabPage(defaultIndex: 0));
                }

                requestCommodityData();
              },
              onChangeCallback: (skuIndex, value) {
                print(value);
                setState(() {
                  ybrkCommodityList[index]['skuDataList'][skuIndex]
                      ['commodityNumber'] = int.parse(value);
                });
              },
            )
          ],
        );
      },
      itemCount: list.length ?? 0,
    );
  }
}
