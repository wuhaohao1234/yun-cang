// 待认领列表
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:image_picker/image_picker.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/login/pages/cs_login_page.dart';
import 'package:wms/models/mine/user_info_model.dart';
import 'package:wms/utils/event_bus_util.dart';
import 'package:wms/utils/jk_over_scroll_behavior.dart';

class ENDaiRenLingPage extends StatefulWidget {
  const ENDaiRenLingPage({Key key, this.defaultIndex}) : super(key: key);
  final int defaultIndex;
  @override
  _ENDaiRenLingPageState createState() => _ENDaiRenLingPageState();
}

class _ENDaiRenLingPageState extends State<ENDaiRenLingPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserInfoModel userInfo;
  final picker = ImagePicker();
  TextEditingController nameC = TextEditingController();

  @override
  void initState() {
    super.initState();

    EventBusUtil.getInstance().on<ReLogin>().listen((event) {
      String phone = WMSUser.getInstance().userInfoModel.phoneNum;
      WMSUser.getInstance().logOut();
      Get.offAll(CSLoginPage(
        phone: phone,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(elevation: 0, centerTitle: true, title: Text("其他")),
      body: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Container(
              child: Column(children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17.h),
                  // color: Colors.grey[100],
                ),
                child: Center(
                  child: Column(children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Icon(
                    //       Icons.search_rounded,
                    //       size: 18.sp,
                    //       color: Colors.grey,
                    //     ),
                    //     SizedBox(
                    //       width: 8,
                    //     ),
                    //     Text(
                    //       '请输入单号',
                    //       style:
                    //           TextStyle(fontSize: 14.sp, color: Colors.black26),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 20.h),
                    SvgPicture.asset(
                      'assets/svgs/nofound.svg',
                      width: 150.w,
                    ),
                    SizedBox(height: 20.h),
                    Text("待认领列表,暂未设计，请等待")
                  ]),
                ),
              ),
            )
          ]))),
    );
  }
}
