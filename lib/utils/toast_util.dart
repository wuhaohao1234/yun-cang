import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wms/configs/app_style_config.dart';

class ToastUtil {
  static Future<bool> showMessage({@required String message}) {

    Fluttertoast.cancel();
    if (message == null) {
      return null;
    }
    Toast toastLength = Toast.LENGTH_SHORT;
    if ((message?.length ?? 0) > 15) {
      toastLength = Toast.LENGTH_LONG;
    }
    return Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: AppStyleConfig.textSize.sp);
  }
}
