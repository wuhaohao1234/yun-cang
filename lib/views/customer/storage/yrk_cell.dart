import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/models/storage/rkd_model.dart';
import 'package:wms/views/common/common_style_widget.dart';

class YrkCell extends StatelessWidget {
  final RkdModel model;

  YrkCell({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.grey[100],
      child: Column(
        children: [
          buildRowWidget(
              iconData: Icon(Icons.insert_drive_file),
              title: '入库单号：',
              content: model?.instoreOrderCode ?? ''),
          buildRowWidget(
              iconData: Icon(Icons.insert_drive_file),
              title: '物流单号：',
              content: model?.mailNo ?? ''),
          buildRowWidget(
              iconData: Icon(Icons.dashboard_customize),
              title: '物品数量：',
              content: model?.skusTotal?.toString() ?? ''),
          buildRowWidget(
              iconData: Icon(Icons.calendar_today_rounded),
              title: '创建时间：',
              content: model?.createTime ?? ''),
        ],
      ),
    );
  }
}
