import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:debug_overlay/debug_overlay.dart';
import 'package:wms/debugN.dart';
import 'package:get/get.dart';
import 'package:wms/test_user_settings.dart';

class EasyLoadingUtil {
  static configLoading() {
    // EasyLoading.instance
    //   ..displayDuration = const Duration(milliseconds: 2000)
    //   ..indicatorType = EasyLoadingIndicatorType.threeBounce
    //   ..loadingStyle = EasyLoadingStyle.custom
    //   ..indicatorSize = 45.0
    //   ..radius = 10.0
    //   ..progressColor = Colors.yellow
    //   ..backgroundColor = Colors.transparent
    //   ..indicatorColor = Color(0xFFC0984E)
    //   ..maskColor = Colors.blue.withOpacity(0.5)
    //   ..textColor = Color(0xFFC0984E)
    //   ..userInteractions = true;
  }

  static showLoadingInitState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   EasyLoading.show(status: '');
    // });
  }

  static showLoading({String statusText = ''}) {
    TestUserSuperSettingsController overlayController =
        Get.put(TestUserSuperSettingsController());
    if (overlayController.useDebugOverlay.value) {
    } else {
      EasyLoading.show(status: statusText);
    }
  }

  static showMessage({@required String message}) {
    TestUserSuperSettingsController overlayController =
        Get.put(TestUserSuperSettingsController());
    if (overlayController.useDebugOverlay.value) {
    } else {
      EasyLoading.showToast(message, duration: Duration(seconds: 2));
    }
  }

  static showInfo({@required String message}) {
    TestUserSuperSettingsController overlayController =
        Get.put(TestUserSuperSettingsController());
    if (overlayController.useDebugOverlay.value) {
      GlobalLogController pageController = Get.put(GlobalLogController());
      pageController.logs.add(
        Log(
          level: DiagnosticLevel.info,
          timestamp: DateTime.now(),
          message: message,
          // error: myException,
          // stackTrace: myStackTrace,
        ),
      );
    } else {
      // EasyLoading.show(
      //     indicator: Text(
      //       message,
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     dismissOnTap: true);
    }
  }

  static popHidden() {
    TestUserSuperSettingsController overlayController =
        Get.put(TestUserSuperSettingsController());
    if (overlayController.useDebugOverlay.value) {
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        EasyLoading.dismiss();
      });
    }
  }

  static hidden() {
    TestUserSuperSettingsController overlayController =
        Get.put(TestUserSuperSettingsController());
    if (overlayController.useDebugOverlay.value) {
    } else {
      EasyLoading.dismiss();
    }
  }
}
