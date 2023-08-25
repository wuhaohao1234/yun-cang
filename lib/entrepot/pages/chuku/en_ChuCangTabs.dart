// 出仓页面,包含了: 待出仓、已出仓
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

import 'package:wms/customer/storage/scan_test_page.dart';
import 'package:wms/utils/jk_over_scroll_behavior.dart';
import '../scan/en_scan_result_page.dart';
import 'chucang_list.dart';
// import '../scan/en_search_page.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import '../en_main_page.dart';
import 'package:wms/views/common/input_search_bar_widget.dart';

// import 'package:qrscan/qrscan.dart' as scanner;

class ENChuCangPage extends StatefulWidget {
  const ENChuCangPage({
    Key key,
  }) : super(key: key);
  @override
  _ENChuCangPageState createState() => _ENChuCangPageState();
}

class _ENChuCangPageState extends State<ENChuCangPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> tabTitles = [
    '待出库',
    '已出库',
  ];
  List tabKeys = [
    GlobalKey<ChuCangListState>(),
    GlobalKey<ChuCangListState>(),
  ];
  List<Widget> pages = [
    ChuCangList(outStoreType: 'will'),
    ChuCangList(outStoreType: 'already'),
  ];
  TabController controller;
  var searchContentController = TextEditingController();
  int activeIndex = 0;
  var sortingCounts = {
    '待出库': '',
    '已出库': '',
  };
  @override
  void initState() {
    super.initState();
    setState(() {
      //设置初始index
      activeIndex = 0;
    });
    controller = TabController(
      length: 2,
      vsync: this,
    );
    enQueryNumber();
    controller.addListener(() {
      enQueryNumber();
      print(controller.index.toString() + '@@@@@@@@@@@@@@@');
      setState(() {
        activeIndex = controller.index ?? 0;
        searchContentController.text = '';
      });
    });
    searchContentController.text = '';
  }

  // 开始获取数据
  enQueryNumber() async {
    var data = await HttpServices().enQueryNumber();
    if (data != null) {
      print(data);
      setState(() {
        print(data);
        sortingCounts['待出库'] = data['stayExWarehouse'].toString();
        sortingCounts['已出库'] = data['alreadyExWarehouse'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("出仓单列表"),
          leading: BackButton(
            onPressed: () {
              Get.offAll(() => ENMainPage());
            },
          ),
        ),
        body: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Container(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: InputSearchBarWidget(
                      searchHinterText: '请输入出库单号或物流单号',
                      submitCallback: (value) {
                        print(activeIndex);
                        print(tabKeys[activeIndex ?? 0]);
                        setState(() {
                          tabKeys[activeIndex ?? 0].currentState.onRefresh(
                              searchContent: value != null ? value : '');
                        });
                      },
                      cancelCallback: () {
                        setState(() {
                          tabKeys[activeIndex]
                              .currentState
                              .onRefresh(searchContent: '');
                        });
                      }),
                ),

                // Container(
                //   color: Colors.white,
                //   child: CommonSearchBar(
                //       placeHolder: '请输入出库单号',
                //       width: 360.w,
                //       showScanIcon: true,
                //       searchCallBack: () {
                //         //获取其他页面搜索数据
                //         print(controller.index);
                //         Get.to(
                //           () => ENSearchPage(
                //             placeHolder: '请输入出库单号',
                //             listType: ['chucang'],
                //           ),
                //         );
                //       }
                //       // requestCommodityData(value);
                //       ),
                // ),
                TabBar(
                  controller: controller,
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                  tabs: tabTitles
                      .map((title) => Tab(
                            child: Text(
                              '$title(${sortingCounts[title]})',
                            ),
                          ))
                      .toList(),
                ),
                Flexible(
                  child: TabBarView(
                    children: [
                      ChuCangList(
                        key: tabKeys[0],
                        outStoreType: 'will',
                        searchContent: activeIndex == 0
                            ? searchContentController.text
                            : '',
                      ),
                      ChuCangList(
                        key: tabKeys[1],
                        outStoreType: 'already',
                        searchContent: activeIndex == 1
                            ? searchContentController.text
                            : '',
                      ),
                    ],
                    controller: controller,
                  ),
                ),
                // Expanded(
                //     child: TabBarView(
                //   children: pages,
                //   controller: controller,
                // )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 点击扫码按钮事件处理
  void onTapScanBtnHandle(BuildContext context) {
    // Get.to(()=>WMSScanPagae());
    // _scan();
    print('直接进入扫码');
    _scan();
    // WMSBottomSheet.showScanSheet(context, handle1: () {
    //   _scan();
    // }, handle2: () {
    //   Get.to(()=>() => ManuallyEnterPage());
    // });
  }

  Future _scan() async {
    await Permission.camera.request();
    Get.to(() => ScanTestPage()).then((value) {
      if (value != null) {
        HttpServices.enQueryByMailNo(
            mailNo: value,
            success: (data, total) {
              if (data != null && (data?.length ?? 0) > 0) {
                // Get.to(()=>
                //   ENYbrkDetailPage(orderId: data.first.orderId),
                // );
              } else {
                Get.to(() => ENScanResultPage(
                      mailNo: value,
                    ));
              }
            },
            error: (error) {
              Get.to(() => ENScanResultPage(
                    mailNo: value,
                  ));
            });
      }
    });
    // String barcode = await scanner.scan();
    // // Get.to(()=>ENScanResultPage());
    // if (barcode == null) {
    //   print('nothing return.');
    //   ToastUtil.showMessage(message: '识别条码失败');
    // } else {
    //   HttpServices.enQueryByMailNo(
    //       mailNo: barcode,
    //       success: (data) {
    //         if (data != null && (data?.length ?? 0) > 0) {
    //           Get.to(()=>
    //             ENYbrkDetailPage(orderId: data.first.orderId),
    //           );
    //         } else {
    //           Get.to(()=>ENScanResultPage(
    //             mailNo: barcode,
    //           ));
    //         }
    //       },
    //       error: (error) {
    //         Get.to(()=>ENScanResultPage(
    //           mailNo: barcode,
    //         ));
    //       });
    // }
  }
}
