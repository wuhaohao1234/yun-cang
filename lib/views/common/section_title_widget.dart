import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final textColor;

  const SectionTitleWidget({
    Key key,
    this.title,
    this.subTitle,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          // Container(
          //   width: 10.w,
          //   height: 10.w,
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: Colors.red),
          // ),
          // SizedBox(
          //   width: 8.w,
          // ),
          Text(
            title ?? '',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Visibility(
            visible: subTitle != null,
            child: WMSText(
              content: subTitle,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
