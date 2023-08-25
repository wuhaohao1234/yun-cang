import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';

//订单每一行信息
Widget buildRowOrderInfo(
    {String title,
    String content,
    Widget endWidget,
    horizontalPadding = 16.0}) {
  return Container(
    constraints: BoxConstraints(
      maxHeight: 100,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          width: .5,
          color: Colors.grey[100],
        ),
      ),
    ),
    padding:
        EdgeInsets.symmetric(vertical: 16.h, horizontal: horizontalPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        WMSText(
          content: title,
          size: 13,
          bold: true,
        ),
        if (endWidget == null)
          WMSText(
            content: content,
            size: 13,
            bold: true,
          )
        else
          endWidget,
      ],
    ),
  );
}

//单行小字
Widget buildRowOrderSmallInfo(String title, String content) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        WMSText(
          content: title,
          size: 13,
        ),
        WMSText(
          content: content,
          size: 13,
        ),
      ],
    ),
  );
}

Widget buildRowOrderNote(
    {TextEditingController controller,
    String title,
    String hinterText = '请输入'}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          width: .5,
          color: Colors.grey[100],
        ),
      ),
    ),
    child: Row(
      children: [
        WMSText(
          content: title,
          size: 13,
          bold: true,
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            cursorColor: Colors.black,
            style: TextStyle(fontSize: 13.sp),
            decoration: InputDecoration(
              hintText: hinterText,
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 13.sp),
            ),
          ),
        )
      ],
    ),
  );
}
