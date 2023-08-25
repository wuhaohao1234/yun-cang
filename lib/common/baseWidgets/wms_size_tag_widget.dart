import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSSizeTagWidget extends StatelessWidget {
  final String title;
  final double fontSize;
  final bgColor;
  final contentColor;
  final rightMargin;
  const WMSSizeTagWidget({
    Key key,
    this.title,
    this.fontSize = 10,
    this.bgColor = Colors.black,
    this.contentColor = Colors.white,
    this.rightMargin = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      margin: EdgeInsets.symmetric(
        horizontal: rightMargin,
        vertical: rightMargin,
      ),
      color: bgColor,
      child: Text(
        title ?? '',
        style: TextStyle(color: contentColor, fontSize: fontSize.sp),
      ),
    );
  }
}
