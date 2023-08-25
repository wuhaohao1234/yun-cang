import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSInfoRow extends StatelessWidget {
  final String title;
  final String content;
  final double leftInset;
  final Color contentColor;
  final Color titleColor;
  final FontWeight fontWeight;

  const WMSInfoRow(
      {Key key,
      this.title,
      this.content,
      this.contentColor,
      this.titleColor,
      this.fontWeight = FontWeight.w700,
      this.leftInset = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: leftInset),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title ?? '',
            style: TextStyle(
              height: 1.2.h,
              fontSize: 13.sp,
              fontWeight: fontWeight,
              color: titleColor != null ? titleColor : Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              content ?? '',
              style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.2.h,
                  fontWeight: fontWeight,
                  color: contentColor != null ? contentColor : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
