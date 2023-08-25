//异常单
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_info_row.dart';
import 'package:wms/models/entrepot/ruku/en_ycd_model.dart';
import 'package:wms/utils/wms_util.dart';

class ENYcdCell extends StatelessWidget {
  final ENYcdModel model;

  const ENYcdCell({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: .5,
            color: Colors.grey[200],
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.insert_drive_file,
                size: 17,
                color: Colors.black,
              ),
              Expanded(
                  child: WMSInfoRow(
                title: '异常单号：',
                content: '${model.exceptionOrderCode ?? ''}',
                leftInset: 8,
              )),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Icon(
                Icons.person_outline_outlined,
                color: Colors.black,
                size: 17,
              ),
              Expanded(
                  child: WMSInfoRow(
                title: '客户代码：',
                content: '${model.customerCode ?? ''}',
                leftInset: 8,
              )),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Colors.black,
                size: 17,
              ),
              Expanded(
                  child: WMSInfoRow(
                title: '异常类型：',
                content: WMSUtil.getExceptionTypeString(model.exceptionType),
                leftInset: 8,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
