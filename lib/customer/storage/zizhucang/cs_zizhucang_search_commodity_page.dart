// 自主仓添加订单、搜索商品页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
// import '../common_search_bar.dart';
import 'package:wms/views/commodity_cell_widget.dart';
// import 'cs_add_ybrk_page.dart';
import 'package:wms/views/common/input_search_bar_widget.dart';

class CSZiZhuCangSearchCommodityPage extends StatefulWidget {
  final List postCommodityList;
  const CSZiZhuCangSearchCommodityPage({
    Key key,
    this.postCommodityList,
  }) : super(key: key);

  @override
  _CSZiZhuCangSearchCommodityPageState createState() =>
      _CSZiZhuCangSearchCommodityPageState();
}

class _CSZiZhuCangSearchCommodityPageState
    extends State<CSZiZhuCangSearchCommodityPage> {
  List ybrkComodityList = []; //商品查询列表
  var searchType = '0';
  var searchWords = {'spuName': '', 'skuCode': '', 'orderIdName': ''};

  var searchPostList = []; //搜索提交列表
  var orderIdName = '';
  int pageNum = 1;
  bool canMore = true;
  bool zizhucangInfo = true;
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: "");
    // requestCommodityData();
    onRefresh();
  }

  Future<void> onRefresh() async {
    setState(() {
      pageNum = 1;
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
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().getSpuSkuList(
      pageSize: 10,
      pageNum: pageNum,
      spuName: searchWords['spuName'] ?? '',
      skuCode: searchWords['skuCode'] ?? '',
      orderIdName: searchWords['orderIdName'] ?? '',
    );
    if (res == false) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: '未查询到相关数据');
      return false; // 这里得先return, 不然会继续往下处理
    }
    final data = res["data"];
    final total = res["total"];

    setState(() {
      if (pageNum == 1) {
        ybrkComodityList = data;
      } else {
        ybrkComodityList.addAll(data);
      }
      if (ybrkComodityList.length == total) {
        // 可以加载更多
        canMore = false;
      } else {
        // 不可以加载更多
        canMore = true;
      }
      print("共计 $total, 目前${ybrkComodityList.length}");
      EasyLoadingUtil.hidden();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: WMSText(
            content: '自主仓-添加商品',
            size: AppStyleConfig.navTitleSize,
          ),
          leading: TextButton(
            child: WMSText(
              content: '取消',
              color: Colors.grey,
            ),
            onPressed: () => Get.back(),
          ),
          actions: [
            TextButton(
              child: WMSText(
                content: '确认',
                color: Colors.green,
                bold: true,
              ),
              onPressed: () => Get.back(result: searchPostList),
            ),
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
                child: ScrollConfiguration(
              behavior: JKOverScrollBehavior(),
              child: Column(
                children: [
                  InputSearchBarWidget(
                      searchHinterText: '添加预约商品',
                      scanHinterText: '扫码',
                      submitCallback: (value) {
                        setState(() {
                          zizhucangInfo = false;

                          if (searchType == '0') {
                            searchWords['spuName'] = value;
                            searchWords['skuCode'] = '';
                            searchWords['orderIdName'] = '';
                          }
                          if (searchType == '1') {
                            searchWords['skuCode'] = value;
                            searchWords['spuName'] = '';
                            searchWords['orderIdName'] = '';
                          }
                          if (searchType == '2') {
                            searchWords['orderIdName'] = value;
                            searchWords['skuCode'] = '';
                            searchWords['spuName'] = '';
                          }
                        });
                        onRefresh();
                      },
                      cancelCallback: () {
                        setState(() {
                          if (searchType == '0') {
                            searchWords['spuName'] = '';
                            searchWords['skuCode'] = '';
                            searchWords['orderIdName'] = '';
                          }
                          onRefresh();
                        });
                      }),
                  // Row(
                  // children: [
                  // DropdownButton(
                  //   items: [
                  //     DropdownMenuItem(child: Text('名称、货号'), value: '0'),
                  //     DropdownMenuItem(child: Text('条形码'), value: '1'),
                  //     // DropdownMenuItem(child: Text('预约入库单号'), value: '2')
                  //   ],
                  //   onChanged: (value) {
                  //     setState(() {
                  //       searchType = value;
                  //     });
                  //     requestCommodityData();
                  //   },
                  //   value: searchType,
                  // ),])

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionTitleWidget(
                        title: '已加入自主仓的商品信息',
                        textColor: Colors.grey,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              zizhucangInfo = !zizhucangInfo;
                            });
                          },
                          child: zizhucangInfo
                              ? Icon(Icons.arrow_drop_up)
                              : Icon(Icons.arrow_drop_down))
                    ],
                  ),
                  Visibility(
                    visible: zizhucangInfo,
                    child: widget.postCommodityList.length != 0
                        ? Column(
                            children: [
                              Container(
                                height: 200.h,
                                color: Colors.grey[100],
                                child: buildList(widget.postCommodityList,false),
                                // child: Text("good")
                              ),
                            ],
                          )
                        : Center(child: Text('未查询到相关数据')),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionTitleWidget(
                        title: '商品信息',
                      ),
                    ],
                  ),
                  Container(
                    child: Expanded(
                        child: RefreshView(
                      header: MaterialHeader(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                      onLoad: onLoad,
                      onRefresh: onRefresh,
                      child: ybrkComodityList.length != 0
                          ? buildList(ybrkComodityList,true)
                          : Center(child: Text('未查询到相关数据')),
                    )),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(Size(90.w, 34.w)),
                              fixedSize:
                                  MaterialStateProperty.all(Size(343.w, 34.w)),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) =>
                                      searchPostList.length != 0
                                          ? AppStyleConfig.btnColor
                                          : null),
                            ),
                            onPressed: searchPostList.length == 0
                                ? null
                                : () {
                                    Get.back(result: searchPostList);
                                  },
                            child: Text(
                              '提交并返回自主仓详情 (${searchPostList.length})',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))));
  }

  //预约入库商品清单
  Widget buildList(comodityList, clickable) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              onTap:clickable? () {
                setState(() {
                  var i_p = widget.postCommodityList.indexWhere(
                          (i) => i['spuId'] == comodityList[index]['spuId']);
                  var i_s = searchPostList.indexWhere(
                          (i) => i['spuId'] == comodityList[index]['spuId']);
                  if (i_s == -1 && i_p == -1) {
                    if (comodityList[index]['skuDataList'].length == 0) {
                      comodityList[index]['skuDataList'] = [
                        {
                          "size": null,
                          "skuId": null,
                          "commodityNumber": 0,
                          "uuid": null,
                        },
                      ];
                    }
                    searchPostList.add(comodityList[index]);
                    EasyLoadingUtil.showMessage(
                        message: '该商品已添加至预约入库商品清单');
                  } else {
                    if (i_s != -1) {
                      searchPostList.removeAt(i_s);
                    }
                    if (i_p != -1) {
                      widget.postCommodityList.removeAt(i_p);
                    }
                  }
                  // if (widget.postCommodityList.any((element) =>
                  //         element['spuId'] == comodityList[index]['spuId']) ||
                  //     searchPostList.contains(comodityList[index])) {
                  //   EasyLoadingUtil.showMessage(
                  //       message: '该商品在自主仓商品清单中已存在，请勿重复添加');
                  //   return false;
                  // } else {
                  //   if (comodityList[index]['skuDataList'].length == 0) {
                  //     comodityList[index]['skuDataList'] = [
                  //       {
                  //         "size": "无尺码",
                  //         "skuId": null,
                  //         "commodityNumber": 0,
                  //         "uuid": null,
                  //       },
                  //     ];
                  //   }
                  //   searchPostList.add(comodityList[index]);
                  //   EasyLoadingUtil.showMessage(message: '该商品已添加至自主仓商品清单');
                  //   print(searchPostList);
                  // }
                });
              }:null,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: clickable
                          ? ((widget.postCommodityList.any((element) =>
                      element['spuId'] ==
                          comodityList[index]['spuId']) ||
                          searchPostList.any((i) =>
                          i['spuId'] ==
                              comodityList[index]['spuId']))
                          ? Color(0xFF33D3BA)
                          : Colors.transparent)
                          : Colors.transparent),
                ),
                child: CommodityCellWidget(
                  picturePath: comodityList[index]['picturePath'] ?? '',
                  name: comodityList[index]['commodityName'],
                  brandName: comodityList[index]['brandName'],
                  stockCode: comodityList[index]['stockCode'] ?? '',
                ),
              ),
            ),
          ],
        );
      },
      itemCount: comodityList.length ?? 0,
    );
  }
}
