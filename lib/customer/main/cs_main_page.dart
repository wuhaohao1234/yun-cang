import 'dart:io';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/login/pages/cs_login_page.dart';
import 'package:wms/customer/market/market_home_page.dart';
import 'package:wms/customer/mine/mine_home_page.dart';
import 'package:wms/customer/orders/order_home_page.dart';
import 'package:wms/customer/storage/storage_home_page.dart';
import 'package:package_info/package_info.dart';

class CSMainPage extends StatefulWidget {
  final int defaultIndex;

  const CSMainPage({Key key, this.defaultIndex}) : super(key: key);

  @override
  _CSMainPageState createState() => _CSMainPageState();
}

class _CSMainPageState extends State<CSMainPage> {
  //海关审核需取消
  List<Widget> _pages = [
    // StorageHomePage(),
    // OrderHomePage(defaultIndex: 0),
    // MarketHomePage(),
    // MineHomePage(),
  ];

  // List<Widget> _pages = [
  //   //海关审核需取消
  //   // OrderHomePage(defaultIndex: 0),
  //   OrderHomePage(defaultIndex: 1),
  //   MarketHomePage(),
  //   MineHomePage(),
  // ];

  PageController _controller;

  int _currentIndex = 0;
  Timer _timer;

  //海关审核需取消
  List<String> _bottomNavigationBarItemTitles = [];

  //海关审核需取消
  List<IconData> _bottomNavigationBarItemIcons = [
    Icons.account_balance,
    Icons.insert_drive_file,
    Icons.storefront_rounded,
    Icons.person
  ];

  // List<String> _bottomNavigationBarItemTitles = ['订单', '集市', '我的'];
  // List<IconData> _bottomNavigationBarItemIcons = [
  //   Icons.insert_drive_file,
  //   Icons.storefront_rounded,
  //   Icons.person
  // ];

  @override
  void initState() {
    super.initState();

    if (WMSUser.getInstance().depotPower) {
      _pages = [
        StorageHomePage(),
        OrderHomePage(defaultIndex: 0),
        MarketHomePage(),
        MineHomePage(),
      ];
      _bottomNavigationBarItemTitles = ['仓储', '订单', '集市', '我的'];
    } else {
      _pages = [
        OrderHomePage(defaultIndex: 0),
        MarketHomePage(),
        MineHomePage(),
      ];
      _bottomNavigationBarItemTitles = ['订单', '集市', '我的'];
    }
    setState(() {
      _bottomNavigationBarItemTitles;
    });

    EventBusUtil.getInstance().on<ReLogin>().listen((event) {
      String phone = WMSUser.getInstance().userInfoModel.phoneNum;
      WMSUser.getInstance().logOut();
      Get.offAll(CSLoginPage(
        phone: phone,
      ));
    });
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      print('检查版本更新=====');
      if (mounted) checkVersion(context);
      _timer?.cancel();
    });
    setState(() {
      _currentIndex = widget.defaultIndex ?? 0;
    });
    _controller = PageController(initialPage: widget.defaultIndex ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child:
        WMSUser.getInstance().depotPower
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
          SizedBox(height: 49.h, width: itemWidth, child: tabbar(0)),
          SizedBox(height: 49.h, width: itemWidth, child: tabbar(1)),
          // SizedBox(
          //   height: 49.h,
          //   width: itemWidth,
          // ),
          SizedBox(height: 49.h, width: itemWidth, child: tabbar(2)),
          //海关审核需取消
          SizedBox(height: 49.h, width: itemWidth, child: tabbar(3)),
        ]):Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[

        SizedBox(height: 49.h, width: itemWidth, child: tabbar(0)),
        // SizedBox(
        //   height: 49.h,
        //   width: itemWidth,
        // ),
        SizedBox(height: 49.h, width: itemWidth, child: tabbar(1)),
        //海关审核需取消
        SizedBox(height: 49.h, width: itemWidth, child: tabbar(2)),
      ]),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Container(
      //   width: 60,
      //   height: 60,
      //   padding: EdgeInsets.all(5),
      //   margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(30),
      //     color: Colors.white,
      //   ),
      //   child: FloatingActionButton(
      //     child: Icon(
      //       Icons.add,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       WMSBottomSheet.showReleaseBtns(
      //           context: context,
      //           callBack: (index) {
      //             Navigator.pop(context);

      //             if (index == 0) {
      //               // Get.to(() => ReleaseYbrkPage());
      //             } else {
      //               Get.to(() => CSKcPage());
      //             }
      //             print("${index}");
      //           });
      //     },
      //     elevation: 5,
      //     backgroundColor: AppStyleConfig.themColor,
      //   ),
      // ),

      body: PageView(
        children: _pages,
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget buildBottomNavogationBar() {
    return BottomNavigationBar(
      items: buildBottomNavigationBarItems(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppStyleConfig.themColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        _currentIndex = index;
        _controller.jumpToPage(_currentIndex);
        setState(() {});
      },
    );
  }

  List<BottomNavigationBarItem> buildBottomNavigationBarItems() {
    List<BottomNavigationBarItem> items = [];
    for (int i = 0; i < _pages.length; i++) {
      items.add(BottomNavigationBarItem(
        icon: Icon(_bottomNavigationBarItemIcons[i]),
        label: _bottomNavigationBarItemTitles[i],
      ));
    }
    return items;
  }

  // 自定义BottomAppBar
  Widget tabbar(int index) {
    //设置默认未选中的状态
    TextStyle style = TextStyle(fontSize: 12, color: Colors.black54);
    // String imgUrl = normalImgUrls[index];
    if (_currentIndex == index) {
      //选中的话
      style = TextStyle(
        fontSize: 13,
        color: AppStyleConfig.themColor,
      );
      // imgUrl = selectedImgUrls[index];
    }
    //构造返回的Widget
    Widget item = Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.network(imgUrl, width: 25, height: 25),
            Icon(
              _bottomNavigationBarItemIcons[index],
              size: 25.0,
              color: _currentIndex == index ? AppStyleConfig.themColor : Colors.grey,
            ),
            Text(
              _bottomNavigationBarItemTitles[index],
              style: style,
            )
          ],
        ),
        onTap: () {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
              _controller.jumpToPage(_currentIndex);
            });
            if (index == 1) {
              print('发送通知1111');
              EventBusUtil.getInstance().fire(RefreshListData(1));
            } else if (index == 2) {
              EventBusUtil.getInstance().fire(RefreshListData(2));
            }
          }
        },
      ),
    );
    return item;
  }

  // check Version
  void checkVersion(BuildContext context) {
    String platform;
    if (Platform.isIOS) {
      platform = 'ios';
    } else {
      platform = 'android';
    }
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String buildNumber = packageInfo.buildNumber;

      print(buildNumber);
      HttpServices.upDateVersion(
          platform: platform,
          success: (result) {
            if (result.edition > int.parse(buildNumber)) {
              WMSDialog.showVersionDialog(context, result);
            }
          },
          error: (e) {
            print(e.message);
          });
    });
  }
}
