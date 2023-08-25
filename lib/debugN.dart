import 'package:get/get.dart';
import 'package:debug_overlay/debug_overlay.dart';

class GlobalLogController extends GetxController {
  final LogCollection logs = LogCollection();
  GlobalLogController();
  @override
  void onInit() {
    super.onInit();
  }
}
