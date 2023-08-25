// 待收货 cell
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_info_row.dart';
import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';

import 'package:wms/utils/wms_util.dart';
// import '../../../entrepot/pages/ruku/en_lincun_page.dart';
import 'package:get/get.dart';
import '../../../entrepot/pages/en_logistics_page.dart';
import 'package:wms/views/common/common_style_widget.dart';
// import 'package:wms/entrepot/pages/ruku/en_ybrk_detail_page.dart';

class ENYbrkdCell extends StatelessWidget {
  final VoidCallback callback;
  final ENYbrkModel model;
  final int index;

  const ENYbrkdCell({Key key, this.callback, this.model, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = 4.h;
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: .5,
              color: Colors.grey[300],
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   '(DEBUG) ID:$index ',
            //   style: TextStyle(
            //     fontSize: 10,
            //     color: Colors.redAccent,
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: Colors.black,
                  size: 17,
                ),
                Expanded(
                  child: WMSInfoRow(
                    title: '预约单号：',
                    content: model?.orderIdName ?? '',
                    leftInset: 8,
                  ),
                )
              ],
            ),
            SizedBox(
              height: padding,
            ),
            Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  color: Colors.black,
                  size: 17,
                ),
                Expanded(
                  child: WMSInfoRow(
                    title: '物流单号：',
                    content: model?.mailNo ?? '',
                    leftInset: 8,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ENLogisticsPage(dataCode: model?.mailNo));
                  },
                  child: stateWidget(
                    title: '查看物流',
                    bgColor: Colors.deepOrangeAccent,
                    contentColor: Colors.white,
                  ),
                )
              ],
            ),

            SizedBox(
              height: padding * 1.5,
            ),
            Row(
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: Colors.black,
                  size: 17,
                ),
                Expanded(
                    child: WMSInfoRow(
                  title: '预约箱数：',
                  content: '${model?.boxTotal ?? '无'}',
                  leftInset: 8,
                )),
              ],
            ),
            SizedBox(
              height: padding * 1.5,
            ),
            Row(
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: Colors.black,
                  size: 17,
                ),
                Expanded(
                    child: WMSInfoRow(
                  title: '入库要求：',
                  content: WMSUtil.orderOperationalRequirementsStringChange(
                      model?.orderOperationalRequirements != null
                          ? model?.orderOperationalRequirements.toString()
                          : model?.inspectionRequirement.toString()),
                  leftInset: 8,
                )),
              ],
            ),
            SizedBox(
              height: padding / 2,
            ),
          ],
        ),
      ),
    );
  }
}
