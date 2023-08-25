import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:debug_overlay/debug_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/customer/login/controllers/cs_login_page_controller.dart';
import 'package:wms/customer/main/cs_main_page.dart';
import 'package:wms/utils/sp_utils.dart';
import 'package:wms/views/customer/controllers/on_sale_controller.dart';
import 'package:wms/views/customer/controllers/order_cell_controller.dart';
import 'package:wms/views/dialog/agreement_widget.dart';
import 'configs/wms_user.dart';
import 'customer/login/pages/cs_login_page.dart';
import 'entrepot/pages/en_main_page.dart';
import 'debugN.dart';
// import 'configs/app_config.dart';
import 'test_user_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String token = await SPUtils.getToken();
  bool isFirst = await SPUtils.getIsFirst();
  int userType;
  String depotName;
  if (token != null) {
    userType = await SPUtils.getUserType();
    depotName = await SPUtils.getDepotName();
    WMSUser.getInstance().userInfoModel = await SPUtils.getUserInfo();
    WMSUser.getInstance().agentName = await SPUtils.getAgentName();
    WMSUser.getInstance().depotName = await SPUtils.getDepotName();
    WMSUser.getInstance().depotPower = await SPUtils.getDepotPower();
    print(
        "获取用户信息成功! agentname: ${WMSUser.getInstance().agentName} 仓库: ${WMSUser.getInstance().depotName}");
  }

  WMSUser.getInstance().token = token;
  WMSUser.getInstance().userType = userType;
  WMSUser.getInstance().depotName = depotName;

  print('token = $token   userType = $userType depotName=$depotName');
  // runApp(MyApp(
  //   token: token,
  //   userType: userType,
  // ),);

  runApp(RestartWidget(
    child: MyApp(
      token: token,
      isFirst:isFirst,
      userType: userType,
      depotName: depotName,
    ),
  ));

  if (Platform.isAndroid) {
    // 设置状态栏背景及颜色
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    print("重启App");
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

// class MyApp extends StatelessWidget {
class MyApp extends StatefulWidget {
  final String token;
  final bool isFirst;
  final int userType;
  final String depotName;
  const MyApp({Key key, this.token, this.isFirst, this.userType, this.depotName})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  TestUserSuperSettingsController overlayController =
      Get.put(TestUserSuperSettingsController());

  @override
  Widget build(BuildContext context) {
    GlobalLogController pageController = Get.put(GlobalLogController());
    OnSaleController orderCellController = Get.put(OnSaleController());
    DebugOverlay.helpers.value = [];
    DebugOverlay.prependHelper(LogsDebugHelper(pageController.logs));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //只能纵向
    ]);
    return ScreenUtilInit(
      designSize: Size(375, 667),
      builder: () => GetMaterialApp(
        title: '云仓',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.white,
            // 按钮主体
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.black38;
                    }
                    return Colors.black;
                  },
                ),
                foregroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.white),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.black38;
                    }
                    return Color(0xfff2f2f2);
                  },
                ),
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                foregroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.black),
              ),
            )),
        builder: overlayController.useDebugOverlay.value
            ? DebugOverlay.builder(showOnShake: true)
            : (context, child) {
                return Material(
                  child: FlutterEasyLoading(
                    child: GestureDetector(
                        onTap: () => hideKeyboard(context), child: child),
                  ),
                );
              },
        home: Material(
            child:widget.isFirst? AgreementWidget(): (widget.token == null
                ? CSLoginPage()
                // ?CSSetPwdPage()
                : widget.userType == 1
                    ? CSMainPage()
                    : ENMainPage())),
      ),
    );
  }

  // 全局点击空白出隐藏键盘
  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}
