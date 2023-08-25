/*
* 客户端入-仓储管理模块-预约单详情页面
* */

import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'cs_daiLiHuo_list.dart';
import 'cs_daiQianShou_list.dart';
import 'cs_daiShangJia_list.dart';
import 'cs_yiRuKu_list.dart';
import 'cs_add_ybrk_page.dart';
import '../../main/cs_main_page.dart';

class CSYbrkTabPage extends StatefulWidget {
  const CSYbrkTabPage({Key key, this.defaultIndex}) : super(key: key);
  final int defaultIndex;

  @override
  _CSYbrkTabPageState createState() => _CSYbrkTabPageState();
}

class _CSYbrkTabPageState extends State<CSYbrkTabPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> tabTitles = ['待签收', '待理货', '待上架', '已入库'];
  var _depotValue = 0;

  List tabKeys = [
    GlobalKey<CSDaiQianShouListState>(),
    GlobalKey<CSDaiLihuoListState>(),
    GlobalKey<CSDaiShangJiaListState>(),
    GlobalKey<CSYiRuKuListState>(),
  ];

  TabController controller;
  int activeIndex;
  // 这两个变量唯一确定当前tab获取数据需要的参数
  String selectedDateTime = WMSUtil.getCurrentDate();
  num selectedDepotId = 0;
  bool initIndex = true;
  List depotList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      //设置初始index
      activeIndex = widget.defaultIndex ?? 0;
    });

    controller = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.defaultIndex,
    );
    controller.addListener(() {
      print("切换到了 ${controller.index.toString()}");
      setState(() {
        //每次切换时重新更新当前时间；
        activeIndex = controller.index;
        selectedDateTime = WMSUtil.getCurrentDate();
        initIndex = false;
        requestData();
      });
    });

    // 开始获取数据
    requestData();
  }

  Future<bool> requestData() async {
    print("重新获取仓位信息");
    // 获取仓库信息
    // 这里要根据index 来切换
    //也就是每切换一次就要重新获取一次depotList

    final data =
        await HttpServices().depotList(status: activeIndex == 0 ? '0' : '1');
    if (data != null) {
      print(data);

      setState(() {
        depotList = data;
        _depotValue = null;
        depotList.add({"depotName": "全部", "id": 0, 'depotId': 0});
        if (_depotValue == null) {
          _depotValue = 0;
        }
        print("仓库信息 $depotList");
      });

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    void openPicker(BuildContext context) {
      setUpWidget(
        context,
        PickerTimeWidget(
          item: selectedDateTime,
          callback: (String newDateTime) {
            setState(() {
              selectedDateTime = newDateTime;
              tabKeys[activeIndex].currentState.onRefresh(
                    newDepotId: selectedDepotId,
                    newYearMonth: selectedDateTime,
                  );
            });
            // 这里也要更新
            // 后期这里要变成 activeIndex

            // tabKeys[1].currentState.onRefresh(
            //       newDepotId: selectedDepotId,
            //       newYearMonth: selectedDateTime,
            //     );
          },
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("入库"),
          leading: BackButton(
            onPressed: () {
              Get.offAll(() => CSMainPage());
            },
          ),
        ),
        body: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: WMSDateSection(
                        data: selectedDateTime,
                        callback: () => openPicker(context),
                      ),
                    ),
                    DropdownButton(
                      value: _depotValue,
                      onChanged: (newDepotId) {
                        //设置改变仓库时重新刷新子组件数据；
                        setState(() {
                          _depotValue = newDepotId;
                          selectedDepotId = newDepotId;
                          // 后期这里要变成 activeIndex
                          tabKeys[activeIndex].currentState.onRefresh(
                                newDepotId: selectedDepotId,
                                newYearMonth: selectedDateTime,
                              );
                        });
                      },
                      items: List<DropdownMenuItem>.generate(
                        depotList.length,
                        (int index) => DropdownMenuItem(
                            child: Text(depotList[index]['depotName']),
                            value: depotList[index]['depotId']),
                      ),
                      // items: depotList.map(
                      //   (depotItem) => DropdownMenuItem(
                      //       child: Text(depotItem['depotName']),
                      //       value: depotItem['id']),
                      // ),
                    ),
                    SizedBox(width: 20.w)
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        controller: controller,
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        labelPadding: EdgeInsets.symmetric(horizontal: 0),
                        tabs: tabTitles
                            .map(
                              (title) => Tab(
                                child: Text(
                                  title,
                                ),
                              ),
                              // 列表数量角标
                            )
                            .toList(),
                        // .map((title) => Tab(
                        //         child: Stack(
                        //       children: [
                        //         Center(
                        //           child: Text(
                        //             title,
                        //           ),
                        //         ),
                        //         // 列表数量角标
                        //       ],
                        //     )))
                        // .toList(),
                      ),
                      Flexible(
                        child: TabBarView(
                          children: [
                            // 如果第一次进入tab，则获取全部数据，如果tab切换，则根据时间获取
                            CSDaiQianShouList(
                              key: tabKeys[0],
                              depotId: selectedDepotId,
                              yearMonth: activeIndex == 0
                                  ? initIndex
                                      ? null
                                      : selectedDateTime
                                  : null,
                            ),
                            CSDaiLihuoList(
                              key: tabKeys[1],
                              depotId: selectedDepotId,
                              yearMonth:
                                  activeIndex == 1 ? selectedDateTime : null,
                            ),
                            CSDaiShangJiaList(
                              key: tabKeys[2],
                              depotId: selectedDepotId,
                              yearMonth:
                                  activeIndex == 2 ? selectedDateTime : null,
                            ),
                            CSYiRuKuList(
                              key: tabKeys[3],
                              depotId: selectedDepotId,
                              yearMonth:
                                  activeIndex == 3 ? selectedDateTime : null,
                            )
                          ],
                          controller: controller,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: WMSButton(
                      title: '新增预约单',
                      bgColor: AppConfig.themeColor,
                      callback: () {
                        Get.to(() => CSYbrkAddPage());
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
