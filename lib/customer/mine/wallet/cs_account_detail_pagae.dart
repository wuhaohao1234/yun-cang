import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/customer/mine/wallet/cs_storage_account_page.dart';
import 'package:wms/customer/mine/wallet/cs_store_account_page.dart';
import 'package:wms/utils/jk_over_scroll_behavior.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合

class CSAccountDetailPagae extends StatefulWidget {
  @override
  _CSAccountDetailPagaeState createState() => _CSAccountDetailPagaeState();
}

class _CSAccountDetailPagaeState extends State<CSAccountDetailPagae>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _tabTitles = ['仓储账户', '店铺账户'];
  List<Widget> _pages = [
    CSStorageAccountPage(),
    CSStoreAccountPage(),
  ];
  List tabKeys = [
    GlobalKey<CSStorageAccountPageState>(),
  ];

  String selectedDateTime = WMSUtil.getCurrentDate();

  // @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: _tabTitles.length,
  //     child: Scaffold(
  //       backgroundColor: Colors.white,
  //       appBar: AppBar(
  //         elevation: 0,
  //         centerTitle: true,
  //         title: Container(
  //           width: 160.w,
  //           child: TabBar(
  //             indicatorColor: AppStyleConfig.themColor,
  //             indicatorSize: TabBarIndicatorSize.label,
  //             labelColor: AppStyleConfig.themColor,
  //             unselectedLabelColor: Colors.black,
  //             labelPadding: EdgeInsets.symmetric(horizontal: 0),
  //             tabs: _tabTitles
  //                 .map((title) => Tab(
  //                       text: title,
  //                     ))
  //                 .toList(),
  //           ),
  //         ),
  //       ),
  //       body: ScrollConfiguration(
  //         behavior: JKOverScrollBehavior(),
  //         child: TabBarView(
  //           children: _pages,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    void openPicker(BuildContext context) {
      setUpWidget(
        context,
        PickerTimeWidget(
          item: selectedDateTime,
          callback: (String newDateTime) async {
            setState(() {
              selectedDateTime = newDateTime;
              tabKeys[0].currentState.onRefresh(
                    newYearMonth: selectedDateTime,
                  );
            });
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true, elevation: 0.0, title: Text('账户明细')),
      body: ScrollConfiguration(
        behavior: JKOverScrollBehavior(),
        child: Column(
          children: [
            WMSDateSection(
              data: selectedDateTime,
              callback: () => openPicker(context),
            ),
            SizedBox(height: 8.h),
            Container(
                child: Expanded(
              // child: ListView.builder(
              //   itemBuilder: (context, index) {
              //     return buildCellWidget();
              //   },
              //   itemCount: 3,
              // ),
              child: CSStorageAccountPage(
                key: tabKeys[0],
                yearMonth: selectedDateTime,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
