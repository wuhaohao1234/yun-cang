import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';

class TagWidget extends StatelessWidget {
  final chooseValue;
  final String text;
  final int value;
  final Function callback;
  final num width;
  final num height;
  final double horizontalMargin;
  final bool hasRadius;
  final Color activeBgColor;
  final Color activeFgColor;
  final Color baseBgColor;
  final Color baseFgColor;
  final double radius;
  final num padding;
  const TagWidget({
    Key key,
    this.chooseValue,
    this.width: 80,
    this.height: 20,
    this.padding: 4,
    this.text,
    this.value,
    this.callback,
    this.horizontalMargin,
    this.hasRadius: true,
    this.activeBgColor = Colors.white,
    this.activeFgColor = Colors.black,
    this.baseBgColor = const Color(0xfff2f2f2),
    this.baseFgColor = const Color(0xff666666),
    this.radius = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin == null ? 4.w : horizontalMargin),
        padding: EdgeInsets.all(padding.w),
        width: width.w,
        // height: height.h,
        decoration: BoxDecoration(
          borderRadius:
              hasRadius ? BorderRadius.all(Radius.circular(radius)) : null,
          color: chooseValue == value ? activeBgColor : baseBgColor,
        ),
        child: Center(
          child: WMSText(
            content: text,
            // bold: chooseValue == value,
            color: chooseValue == value ? activeFgColor : baseFgColor,
          ),
        ),
      ),
    );
  }
}

Widget sizeTagWidget({String content}) {
  return Container(
    margin: EdgeInsets.only(right: 8.w),
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
    color: Colors.black,
    child: Text(
      content ?? '',
      style: TextStyle(color: Colors.white, fontSize: 10.sp),
    ),
  );
}
