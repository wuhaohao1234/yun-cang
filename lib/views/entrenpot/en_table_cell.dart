import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';

// 表格标题组件
Widget buildTableHeadWdidget(headList) {
  return Container(
    color: Colors.grey[200],
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: WMSText(
              content: headList[0],
              size: 12,
              bold: true,
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: WMSText(
              content: headList[1],
              size: 12,
              bold: true,
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: WMSText(
              content: headList[2],
              size: 12,
              bold: true,
            ),
          ),
        ),
      ],
    ),
  );
}
