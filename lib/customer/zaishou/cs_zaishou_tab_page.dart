/*
* 客户端入-我的在售-tab
* */

import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/common/common_search_bar.dart';
import 'package:wms/views/customer/controllers/on_sale_controller.dart';
import 'package:wms/views/customer/controllers/order_cell_controller.dart';
import 'cs_zaishou_jishi_list.dart';

// import 'cs_zaishou_app_list.dart';
import '../main/cs_main_page.dart';

class CSZaiShouTabPage extends StatefulWidget {
  const CSZaiShouTabPage({Key key, this.defaultIndex}) : super(key: key);
  final int defaultIndex;

  @override
  _CSZaiShouTabPageState createState() => _CSZaiShouTabPageState();
}

class _CSZaiShouTabPageState extends State<CSZaiShouTabPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> tabTitles = [];
  String searchStr = '';
  List<Widget> pages = [];
  TabController controller;
  int activeIndex;
  OnSaleController cellController = Get.find();

  @override
  void initState() {
    super.initState();
    if (WMSUser.getInstance().depotPower) {
      // tabTitles = ['集市', '小程序', '转售'];
      tabTitles = ['集市', '小程序'];
      pages = [
        CSZaiShouList(type: 2, index: 0),
        CSZaiShouList(type: 1, index: 1),
        // CSZaiShouList(type: 3, index: 2),
      ];
    } else {
      tabTitles = ['集市'];
      pages = [
        CSZaiShouList(type: 2, index: 0),
      ];
    }

    setState(() {
      activeIndex = widget.defaultIndex ?? 0;
    });

    controller = TabController(
      // length: WMSUser.getInstance().depotPower ? 3 : 1,
      length: WMSUser.getInstance().depotPower ? 2 : 1,
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
    return DefaultTabController(
      // length: 3,
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text("我的在售"),
              leading: BackButton(
                onPressed: () {
                  Get.offAll(() => CSMainPage(defaultIndex: WMSUser.getInstance().depotPower?3:2));
                },
              )),
          body: Column(
            children: [
              Container(
                width: 375.w,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                child: Container(
                  height: 28.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17.h),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 28.h,
                            padding: EdgeInsets.only(bottom: 0.h),
                            child: TextField(
                              decoration: InputDecoration(border: InputBorder.none, hintText: "搜索货号或商品名称"),
                              maxLines: 1,
                              onChanged: (e) {
                                cellController.setSearchStr(str: e);
                              },
                              onSubmitted: (e) {
                                cellController.setPageNum(num: 1);
                                cellController.requestData(
                                    type: activeIndex == 0 ? 2 : (activeIndex == 1 ? 1 : 3), index: activeIndex);
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cellController.setPageNum(num: 1);
                            cellController.requestData(
                                type: activeIndex == 0 ? 2 : (activeIndex == 1 ? 1 : 3), index: activeIndex);
                          },
                          child: Icon(
                            Icons.search_rounded,
                            size: 18.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ]),
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: JKOverScrollBehavior(),
                  child: Container(
                    child: Column(
                      children: [
                        TabBar(
                          controller: controller,
                          indicatorColor: Colors.red,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Colors.red,
                          unselectedLabelColor: Colors.black,
                          labelPadding: EdgeInsets.symmetric(horizontal: 0),
                          tabs: tabTitles
                              .map((title) => Tab(
                                      child: Stack(
                                    children: [
                                      Center(
                                        child: Text(
                                          title,
                                        ),
                                      ),
                                      // 列表数量角标
                                    ],
                                  )))
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
              )
            ],
          )),
    );
  }
}
