/*
* 客户端-仓储管理模块-异常件列表页面Cell
* */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/models/storage/ycj_model.dart';
import 'package:wms/utils/wms_util.dart';
import 'package:wms/views/common/common_style_widget.dart';

class StorageYcjCellWidget extends StatelessWidget {
  const StorageYcjCellWidget({Key key, this.model}) : super(key: key);
  final YcjModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.grey[100],
      child: Column(
        children: [
          buildRowWidget(
              iconData: Icon(Icons.car_repair),
              title: '异常单号：',
              content: model?.exceptionOrderCode ?? ''),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRowWidget(
                  iconData: Icon(Icons.insert_drive_file),
                  title: '物流单号：',
                  content: model?.mailNo ?? ''),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => ENLogisticsPage(dataCode: model?.mailNo));
              //   },
              //   child: stateWidget(
              //     title: '查看物流',
              //     bgColor: Colors.deepOrangeAccent,
              //     contentColor: Colors.white,
              //   ),
              // )
              // stateWidget(title: '物流轨迹', bgColor: Colors.deepOrangeAccent),
            ],
          ),
          buildRowWidget(
            iconData: Icon(Icons.dashboard_customize),
            title: '异常类型：',
            content: WMSUtil.getExceptionTypeString(model?.exceptionType),
          ),
          buildRowWidget(
              iconData: Icon(Icons.calendar_today_rounded),
              title: '创建时间：',
              content: model?.createTime ?? ''),
          buildRowWidget(
              iconData: Icon(Icons.calendar_today_rounded),
              title: '仓库：',
              content: model?.depotName ?? ''),
        ],
      ),
    );
  }
}
