// 入库页面,包含了: 待收货,待理货, 待上架
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

import 'package:image_picker/image_picker.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/login/pages/cs_login_page.dart';

// import 'package:wms/customer/storage/scan_test_page.dart';
import 'package:wms/models/mine/user_info_model.dart';
import 'package:wms/utils/jk_over_scroll_behavior.dart';

import '../scan/en_scan_result_page.dart';
import '../scan/en_search_page.dart';
import '../en_main_page.dart';

// import '../scan/en_scan_qianshou_page.dart';
import '../scan/en_scan_test_page.dart';

import 'qianshou/en_ybrk_detail_page.dart';
import 'daishouhuo_list.dart';
import 'dailihuo_list.dart';
import 'daishangjia_list.dart';
import 'qianshou/en_ybrk_custome_qianshou_page.dart';

// import 'en_ybrk_detail_page.dart';
// import '../scan/en_search_page.dart';

class ENRkdShPage extends StatefulWidget {
  const ENRkdShPage({Key key, @required this.defaultIndex}) : super(key: key);
  final int defaultIndex;

  @override
  _ENRkdShPageState createState() => _ENRkdShPageState();
}

class _ENRkdShPageState extends State<ENRkdShPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> tabTitles = [
    '待收货',
    '待理货',
    '待上架',
  ];
  List<Widget> pages = [];
  TabController controller;
  UserInfoModel userInfo;
  int activeIndex;
  final picker = ImagePicker();
  TextEditingController nameC = TextEditingController();
  var orderCounts = {'待收货': '0', '待理货': '0', '待上架': '0', 'stayShelf': '0'};

  @override
  void initState() {
    super.initState();

    this.setState(() {
      pages = [
        DaiShouhuoList(
          refresh: () {
            enOrderCount();
          },
        ),
        DaiLihuoList(
          refresh: () {
            enOrderCount();
          },
        ),
        DaiShangJiaList(
          refresh: () {
            enOrderCount();
          },
        )
      ];
    });
    setState(() {
      activeIndex = widget.defaultIndex ?? 0;
    });

    // HttpServices.enOrderCount();

    controller = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.defaultIndex,
    );
    EventBusUtil.getInstance().on<ReLogin>().listen((event) {
      String phone = WMSUser.getInstance().userInfoModel.phoneNum;
      WMSUser.getInstance().logOut();
      Get.offAll(CSLoginPage(
        phone: phone,
      ));
    });
    enOrderCount();
    controller.addListener(() {
      enOrderCount();
      print("切换到了 ${controller.index.toString()}");
      setState(() {
        activeIndex = controller.index;
        pages = [DaiShouhuoList(), DaiLihuoList(), DaiShangJiaList()];
      });
    });
    // 开始获取数据, 这里是改变 orderCounts
  }

  // 开始获取数据, 这里是改变 orderCounts
  enOrderCount() async {
    var data = await HttpServices().enOrderCount();
    if (data != null) {
      print(data);
      setState(() {
        orderCounts['待收货'] = (data['stayReceived'] ?? 0).toString();
        orderCounts['待理货'] = (data['stayTally'] ?? 0).toString();
        orderCounts['待上架'] = (data['stayShelf'] ?? 0).toString();
        orderCounts['临存'] = (data['temporaryExistence'] ?? 0).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("入库"),
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
                // Container(
                //   color: Colors.white,
                //   child: CommonSearchBar(
                //       placeHolder: '请输入物流单号',
                //       width: 360.w,
                //       showScanIcon: true,
                //       searchCallBack: () {
                //         print(controller.index);
                //         Get.to(
                //           () => ENSearchPage(
                //             listType: [
                //               'mail',
                //               //  "prepareOrder", "2", "3"
                //             ],
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
                              '$title(${orderCounts[title]})',
                            ),

                            // 列表数量角标

                            // child: Stack(
                            //   children: [
                            //     Center(
                            //       child: Text(
                            //         title,
                            //       ),
                            //     ),
                            //     // 列表数量角标
                            //     Positioned(
                            //         right: 25,
                            //         top: 10,
                            //         child: Text(orderCounts[title],
                            //             style: TextStyle(
                            //                 fontSize: 12,
                            //                 fontWeight: FontWeight.bold)))
                            //   ],
                            // ),
                          ))
                      .toList(),
                ),
                Expanded(
                    child: TabBarView(
                  children: pages,
                  controller: controller,
                )),
              ],
            ),
          ),
        ),
        floatingActionButton: activeIndex == 0
            ? FloatingActionButton(
                // 点击以后扫描并输入单号
                onPressed: () {
                  // Add your onPressed code here!
                  onTapScanBtnHandle(context, controller.index);
                },
                backgroundColor: Colors.grey,
                child: Icon(Icons.qr_code_scanner_sharp),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  // 点击扫码按钮事件处理
  void onTapScanBtnHandle(BuildContext context, int tabIndex) {
    print('目前在 $tabIndex');
    _scanExpress();
    // _scan(tabIndex);
  }

  Future _scanExpress() async {
    await Permission.camera.request();
    Get.to(() => ENScanStandardPage(title: "扫码物流单号")).then((value) {
      // 首先查询物流单号
      print(value);
      if (value != null) {
        HttpServices.enQueryByMailNo(
          mailNo: value,
          success: (data, total) {
            print(data);
            if (data != null && data.length > 0) {
              Get.to(
                () => ENYbrkDetailPage(
                  orderId: data.first.orderId,
                  ybrkModel: data.first,
                ),
              );
            } else {
              Get.to(() => ENYbrkSignNoForecastPage(
                    mailNo: value,
                  ));
            }
          },
          error: (error) {
            Get.to(() => ENSearchPage(
                  filledValue: value,
                ));
          },
        );
      }
    });
  }

  Future _scan(int tabIndex) async {
    await Permission.camera.request();

    Get.to(() {
      switch (tabIndex) {
        case 0:
          // 处于待收货界面
          return ENScanStandardPage(title: '扫码签收');
          break;
        case 1:
          // 处于待理货界面
          return ENScanStandardPage(title: '扫码理货');
          break;
        case 2:
          // 处于待上架界面
          return ENScanStandardPage(title: '扫码上架');
          break;
        default:
          return ENScanStandardPage();
      }
    }).then((value) {
      if (value != null) {
        switch (tabIndex) {
          case 0:
            // 处于待收货界面
            //此时返回的value 是 mailNo
            HttpServices.enQueryByMailNo(
              mailNo: value,
              success: (data, total) {
                if (data != null && (data?.length ?? 0) > 0) {
                  Get.to(
                    () => ENYbrkDetailPage(
                      orderId: data.first.orderId,
                      ybrkModel: data.first,
                    ),
                  );
                } else {
                  Get.to(() => ENScanResultPage(
                        mailNo: value,
                      ));
                }
              },
              error: (error) {
                Get.to(() => ENSearchPage(
                      filledValue: value,
                    ));
              },
            );
            break;
          // case 1:
          //   // 此时处于待理货界面
          //   //此时返回的value 是 orderId

          //   break;
          // case 2:
          //   // 此时处于待上架界面
          //   //此时返回的value 是 orderId
          //   break;
          default:
            print("tab 出错");
          // return ENScanTestPage();
        }

        // HttpServices.enQueryByMailNo(
        //   mailNo: value,
        //   success: (data, total) {
        //     if (data != null && (data?.length ?? 0) > 0) {
        //       Get.to(()=>
        //         ENYbrkDetailPage(orderId: data.first.orderId),
        //       );
        //     } else {
        //       Get.to(()=>ENScanResultPage(
        //         mailNo: value,
        //       ));
        //     }
        //   },
        //   error: (error) {
        //     Get.to(()=>ENScanResultPage(
        //       mailNo: value,
        //     ));
        //   },
        // );
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
