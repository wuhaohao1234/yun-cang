/*
* 客户端入-仓储管理模块-出库页面
* */

import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'cs_daiChuKu_list.dart';
import 'cs_yiChuku_list.dart';

class CSChuKuTabPage extends StatefulWidget {
  const CSChuKuTabPage({Key key, this.defaultIndex}) : super(key: key);
  final int defaultIndex;
  @override
  _CSChuKuTabPageState createState() => _CSChuKuTabPageState();
}

class _CSChuKuTabPageState extends State<CSChuKuTabPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> tabTitles = [
    '待出库',
    '已出库',
  ];
  List<Widget> pages = [
    CSDaiChukuList(monthOutTime: ''),
    CSYiChuKuList(monthOutTime: ''),
  ];
  TabController controller;
  int activeIndex;
  var dateTime = WMSUtil.getCurrentDate();
  List depotList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      activeIndex = widget.defaultIndex ?? 0;
    });

    controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.defaultIndex,
    );
    controller.addListener(() {
      print("切换到了 ${controller.index.toString()}");
      setState(() {
        activeIndex = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void openPicker(BuildContext context) {
      setUpWidget(
        context,
        PickerTimeWidget(
          item: dateTime,
          callback: (String data) {
            dateTime = data;
          },
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(elevation: 0, centerTitle: true, title: Text("出库列表")),
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
                        data: dateTime,
                        callback: () => openPicker(context),
                      ),
                    ),
                  ],
                ),
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
                              title,
                            ),

                            // 列表数量角标
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
      ),
    );
  }
}
