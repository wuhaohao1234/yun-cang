import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WvConfig {
  static ButtonStyle elevatedButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    backgroundColor: Colors.black,
    minimumSize: Size(60.w, 26.w),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(13.0)),
    ),
  );
}
