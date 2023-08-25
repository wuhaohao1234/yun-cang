import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/views/common/common_style_widget.dart';

class StorageChuKuCellWidget extends StatelessWidget {
  final model;
  final String chukuType;

  const StorageChuKuCellWidget({Key key, this.model, this.chukuType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.grey[100],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRowWidget(
                  iconData: Icon(Icons.insert_drive_file),
                  title: '出库单号：',
                  content: ''),

              Expanded(child: WMSText(content: '${model?.wmsOutStoreName}'))
              // stateWidget(title: '待签收', bgColor: Colors.deepOrangeAccent),
            ],
          ),
          Visibility(
            visible: chukuType == 'already',
            child: buildRowWidget(
                iconData: Icon(Icons.car_repair),
                title: '物流单号：',
                content: '${model?.expressNumber}'),
          ),
          buildRowWidget(
              iconData: Icon(Icons.dashboard_customize),
              title: '物品数量：',
              content: '${model?.skuTotal}'),
          Visibility(
            visible: chukuType == 'will',
            child: buildRowWidget(
                iconData: Icon(Icons.calendar_today_rounded),
                title: '创建时间：',
                content: model?.createTime ?? ''),
          ),
          Visibility(
            visible: chukuType == 'already',
            child: buildRowWidget(
                iconData: Icon(Icons.calendar_today_rounded),
                title: '出库时间：',
                content: '${model?.outTime}'),
          ),
          buildRowWidget(
              iconData: Icon(Icons.house_siding_outlined),
              title: '仓库：',
              content: '${model?.depotName}'),
          Visibility(
            visible: chukuType == 'will',
            child: buildRowWidget(
                iconData: Icon(Icons.local_shipping),
                title: '出库模式：',
                content: '${model?.logisticsName ?? '快递'}'),
          ),
        ],
      ),
    );
  }
}
