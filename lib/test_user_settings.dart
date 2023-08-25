import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
// import 'dart:io';
import 'package:get/get.dart';
import 'main.dart';

class TestUserSuperSettingsController extends GetxController {
  var useDebugOverlay = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void toggleOverlay() {
    useDebugOverlay.value = !useDebugOverlay.value;
  }
}

class TestUserExtraSettings extends StatefulWidget {
  TestUserExtraSettings({Key key}) : super(key: key);

  @override
  State<TestUserExtraSettings> createState() => _TestUserExtraSettingsState();
}

class _TestUserExtraSettingsState extends State<TestUserExtraSettings> {
  TestUserSuperSettingsController overlayController =
      Get.put(TestUserSuperSettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(10.h),
        child: Row(
          children: [
            Text("当前为测试用户 "),
            ElevatedButton(
              onPressed: () {
                overlayController.toggleOverlay();
                RestartWidget.restartApp(context);
              },
              child: Text("overlay: ${overlayController.useDebugOverlay}"),
            )
          ],
        ),
      );
    });
  }
}
