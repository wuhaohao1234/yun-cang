import 'package:flutter/material.dart';

/// Create by bigv on 21-7-13
/// Description:

// 底部弹出
void setUpWidget(BuildContext context, Widget widget) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // 为真是全屏
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    builder: (BuildContext context) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: widget,
      );
    },

    // builder: (BuildContext context) {
    //   return StatefulBuilder(
    //     builder: (BuildContext context, StateSetter setState) {
    //       return new GestureDetector(
    //         behavior: HitTestBehavior.translucent,
    //         onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
    //         child: widget,
    //       );
    //     },
    //   );
    // },
  );
}

// 支付弹出框 Widget widget,[Function callback]
Widget wvDialog({Widget widget, Function callback}) {
  return Dialog(
    insetPadding: EdgeInsets.all(12.0),
    child: Container(
      width: double.infinity,
      child: widget,
    ),
  );
}
