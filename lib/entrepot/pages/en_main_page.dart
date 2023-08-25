// 仓库端APP主页
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

import 'dart:io';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/configs/app_config.dart';
// import 'package:wms/customer/login/pages/cs_login_page.dart';

import 'package:wms/test_user_settings.dart';
import 'package:wms/models/mine/user_info_model.dart';

// import 'package:qrscan/qrscan.dart' as scanner;
import 'en_profile_page.dart';
import 'ruku/en_RuKuTabs.dart';
import 'chuku/en_FenJianTabs.dart';
import 'ruku/en_lincun_page.dart';
import 'chuku/en_ChuCangTabs.dart';

// import 'chuku/en_dairenling_page.dart';
import 'ruku/en_wzd_page.dart';
import 'package:wms/views/common/section_title_widget.dart';
import 'package:package_info/package_info.dart';

class ENMainPage extends StatefulWidget {
  const ENMainPage({Key key}) : super(key: key);

  @override
  _ENMainPageState createState() => _ENMainPageState();
}

class _ENMainPageState extends State<ENMainPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserInfoModel userInfo;
  String depotName;

  List orderCounts = ["0", "0", "0", "0"];
  List sortingCounts = [
    "0",
    "0",
  ];
  Timer _timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() => {});
    }

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      print('检查版本更新=====1');
      if (mounted) checkVersion(context);
      _timer?.cancel();
    });

    // 获取订单数目
    enOrderCount();
    enSortingCount();
    enQueryNumber();

    userInfo = WMSUser.getInstance().userInfoModel;
    depotName = WMSUser.getInstance().depotName;

    Timer.periodic(Duration(seconds: 5), (timer) {
      print('检查版本更新=====2');
      checkVersion(context);
      timer.cancel();
    });
  }

  Future<void> onRefresh() async {
    enOrderCount();
    enSortingCount();
    enQueryNumber();
  }

// 获取入库数目
  enOrderCount() async {
    var data = await HttpServices().enOrderCount();
    if (data != null) {
      print(data);
      setState(() {
        orderCounts[0] = (data['stayReceived'] ?? 0).toString();
        orderCounts[1] = (data['stayTally'] ?? 0).toString();
        orderCounts[2] = (data['stayShelf'] ?? 0).toString();
        orderCounts[3] = (data['temporaryExistence'] ?? 0).toString();
      });
    }
  }

//获取出仓订单数目：分拣总数
  enSortingCount() async {
    var data = await HttpServices().enSortingCount();
    if (data != null) {
      print(data);
      setState(() {
        sortingCounts[0] = ((data['expressDelivery'] ?? 0)

            // +data['selfMention'] +
            // data['carDelivery']
            )
            .toString();
      });
    }
  }

//获取出仓订单数目：出仓总数
  enQueryNumber() async {
    var data = await HttpServices().enQueryNumber();
    if (data != null) {
      print(data);
      setState(() {
        print(data);
        sortingCounts[1] = ((data['stayExWarehouse'] ?? 0) + (data['alreadyExWarehouse'] ?? 0)).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("首页"),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
            color: Colors.white,
            child: ScrollConfiguration(
                behavior: JKOverScrollBehavior(),
                child: RefreshView(
                  header: MaterialHeader(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                  onRefresh: onRefresh,
                  child: ListView(children: [
                    if (AppConfig.testUsers.contains(WMSUser.getInstance().userInfoModel.phoneNum))
                      TestUserExtraSettings(),
                    userInfoSection(),
                    SectionTitleWidget(title: '入仓'),
                    ruCangManage(),
                    SectionTitleWidget(title: '出仓'),
                    chuCangManage(),
                    SectionTitleWidget(title: '其他'),
                    qiTaManage(),
                  ]),
                ))));
  }

  // 用户信息
  Widget userInfoSection() {
    String imagePath = WMSUser.getInstance().userInfoModel.avatar ?? '';
    print(imagePath);
    // print(WMSUser.getInstance().depotName);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // 头像
          GestureDetector(
            onTap: () {
              // onTapHeadImageHandle();
              Get.to(
                () => ENHomePage(),
              );
            },
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  image: DecorationImage(
                      image: imagePath != "" ? NetworkImage(imagePath) : AssetImage('assets/images/avatar_default.png'),
                      fit: BoxFit.contain)),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "用户名：${WMSUser.getInstance().userInfoModel.nickName}",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "${WMSUser.getInstance().depotName}",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "手机号：${WMSUser.getInstance().userInfoModel.phoneNum}",
                style: TextStyle(fontSize: 15.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget storageMenu(storageList) {
    return Container(
      height: 0.25.sw,
      // padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey[200],
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: storageList.length,
          itemBuilder: (context, index) {
            return itemWidget(
              title: storageList[index]['title'],
              iconData: storageList[index]['iconData'],
              bgColor: storageList[index]['bgColor'],
              callback: storageList[index]['callback'],
              iconCount: storageList[index]['iconCount'].toString(),
            );
          }),
    );
  }

  Widget contentContainerWidget({@required List<Widget> child}) {
    return Container(
        child: Wrap(
      children: child,
    ));
  }

  Widget itemWidget({String title, Widget iconData, Color bgColor, VoidCallback callback, String iconCount}) {
    final widgetSize = 0.25.sw;
    // final iconSize = 30.w;
    // final iconContainerSize = iconSize + 10.w;

    final iconContainerSize = 0.1.sw;
    final iconSize = iconContainerSize - 10.w;
    // 这里的icon应该为SVG
    return GestureDetector(
      onTap: callback,
      child: Container(
        // margin: EdgeInsets.only(right: 6.h),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0.w),
        width: ((375 - 40) / 4).w,
        child: Container(
          child: Column(
            children: [
              Container(
                height: 50.w,
                width: 50.w,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.r), color: Colors.black),
                child: Center(
                  child: iconData,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${title}(",
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${iconCount ?? 0}",
                    style: TextStyle(fontSize: 13.sp, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ")",
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
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

  Widget ruCangManage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey[200],
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: contentContainerWidget(
        child: [
          itemWidget(
              title: '收货',
              iconCount: orderCounts[0],
              iconData: SvgPicture.asset(
                'assets/svgs/收货.svg',
                width: 36.w,
                color: Colors.white,
              ),
              bgColor: Colors.black,
              callback: () {
                Get.to(() => ENRkdShPage(defaultIndex: 0)).then((res) => {enOrderCount()});
              }),
          itemWidget(
              title: '理货',
              iconCount: orderCounts[1],
              iconData: SvgPicture.asset(
                'assets/svgs/理货.svg',
                width: 36.w,
                color: Colors.white,
              ),
              bgColor: Colors.black,
              callback: () {
                Get.to(() => ENRkdShPage(defaultIndex: 1)).then((res) => {enOrderCount()});
              }),
          itemWidget(
              title: '上架',
              iconCount: orderCounts[2],
              iconData: SvgPicture.asset(
                'assets/svgs/上架.svg',
                width: 36.w,
                color: Colors.white,
              ),
              bgColor: Colors.black,
              callback: () {
                Get.to(() => ENRkdShPage(defaultIndex: 2)).then((res) => {enOrderCount()});
              }),
          itemWidget(
              title: '临存',
              iconCount: orderCounts[3],
              iconData: SvgPicture.asset(
                'assets/svgs/临存.svg',
                width: 36.w,
                color: Colors.white,
              ),
              bgColor: Colors.black,
              callback: () {
                Get.to(() => ENLinCunPage()).then((res) => {enOrderCount()});
              }),
        ],
      ),
    );
  }

  Widget chuCangManage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey[200],
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: contentContainerWidget(
        child: [
          itemWidget(
              title: '分拣',
              iconCount: sortingCounts[0],
              iconData: SvgPicture.asset(
                'assets/svgs/分拣.svg',
                width: 36.w,
                color: Colors.white,
              ),
              bgColor: Colors.black,
              callback: () {
                Get.to(ENFenJianPage());
              }),
          itemWidget(
              title: '出仓',
              iconCount: sortingCounts[1],
              iconData: SvgPicture.asset(
                'assets/svgs/出库.svg',
                width: 36.w,
                color: Colors.white,
              ),
              bgColor: Colors.black,
              callback: () {
                Get.to(ENChuCangPage());
              }),
        ],
      ),
    );
  }

  Widget qiTaManage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey[200],
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: contentContainerWidget(
        child: [
          itemWidget(
              title: '待认领',
              iconData: SvgPicture.asset(
                'assets/svgs/待认领.svg',
                width: 36.w,
                color: Colors.white,
              ),
              bgColor: Colors.black,
              callback: () {
                Get.to(ENWuZhuDanPage());
              }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
