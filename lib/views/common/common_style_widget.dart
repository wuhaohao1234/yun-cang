import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_config.dart';
import 'package:flutter_html/flutter_html.dart';

//单行
Widget infoItemWidget(
    {String title,
    String content,
    Widget innerWidget,
    EdgeInsetsGeometry padding = const EdgeInsets.only(top: 8)}) {
  return Padding(
    padding: padding,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title ?? '',
          style: TextStyle(fontSize: 14.sp),
        ),
        Expanded(
          child: innerWidget == null
              ? Text(
                  content ?? '',
                  style: TextStyle(fontSize: 14.sp),
                )
              : innerWidget,
        )
      ],
    ),
  );
}

Widget buildRowWidget({iconData, String title, String content}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      children: [
        iconData,
        SizedBox(
          width: 8.w,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          content,
          style: TextStyle(fontSize: 13.sp),
        ),
      ],
    ),
  );
}

Widget buildAddressInfoWidget(dataModel) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r), color: Colors.grey[200]),
    child: Row(
      children: [
        Icon(
          Icons.location_on,
          color: Colors.red,
          size: 30.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  WMSText(
                    content: '${dataModel.consigneeName}',
                    bold: true,
                  ),
                  WMSText(
                    content: '${dataModel.consigneePhone}',
                  ),
                ],
              ),
              WMSText(
                  content: '${dataModel.consigneeProvince}' +
                      '${dataModel.consigneeCity}' +
                      '${dataModel.consigneeDistrict}' +
                      '${dataModel.consigneeAddress}'),
            ],
          ),
        )
      ],
    ),
  );
}

//按钮
Widget buildButtonWidget({
  bgColor = Colors.white,
  contentColor = Colors.black,
  buttonContent = '',
  borderColor = Colors.black,
  num height = 24.0,
  num width = 80.0,
  handelClick,
  num radius = 30.0,
  num fontSize = 12,
  Widget endWidget,
}) {
  if (bgColor != Colors.white) {
    borderColor = bgColor;
  }
  return GestureDetector(
    onTap: handelClick,
    child: Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: borderColor,
        ),
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WMSText(
              content: buttonContent,
              size: fontSize,
              color: contentColor,
            ),
            if (endWidget != null) endWidget,
          ],
        ),
      ),
    ),
  );
}

//段落标题
Widget buildDetailWidget({String title, String tips}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.grey[200],
        ),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 80.w,
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              // fontWeight: FontWeight.bold,
              // color: Colors.grey,
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          // child: Text(
          //   tips ?? '',
          //   style: TextStyle(
          //     fontSize: 14.sp,
          //     color: Colors.grey,
          //   ),
          // ),
          child: Html(
            data: tips ?? '',
          ),
        ),
      ],
    ),
  );
}

//段落标题
Widget buildTitleWidget({String title, String tips}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16.h),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.grey[200],
        ),
      ),
    ),
    child: Row(
      children: [
        WMSText(
          content: title,
          bold: true,
          size: 14,
        ),
        WMSText(
          content: '（$tips）',
          size: 12,
          color: Colors.grey,
        ),
      ],
    ),
  );
}

//段落前缀
Widget itemSectionWidget(
    {String title,
    Widget prefixChild,
    VoidCallback callback,
    Widget child,
    bool showIcon}) {
  showIcon ??= true;
  child ??= Container();
  return GestureDetector(
    onTap: callback,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.grey[100],
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (prefixChild == null)
            Text(
              title ?? '',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            )
          else
            prefixChild,
          Container(
              child: Row(
            children: [
              child,
              showIcon
                  ? Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    )
                  : Container()
            ],
          )),
        ],
      ),
    ),
  );
}

Widget stateWidget(
    {String title, Color bgColor, Color contentColor = Colors.white}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r), color: bgColor),
    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
    child: Center(
      child: Text(
        title ?? '',
        style: TextStyle(color: contentColor, fontSize: 12.sp),
      ),
    ),
  );
}
