import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/models/storage/wzd_model.dart';

class StorageWzjCellWidget extends StatelessWidget {
  final WzdModel model;

  const StorageWzjCellWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.grey[100],
      margin: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.network(
              model?.ownerlessImg ?? '',
              height: 80.h,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WMSText(
                  content: model.orderIdName ?? '',
                  bold: true,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WMSText(
                      content: '快递单号：${model.mailNo ?? ''}',
                    ),
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
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                WMSText(
                  content: '签收日期：${model.createTime ?? ''}',
                ),
                SizedBox(
                  height: 8.h,
                ),
                WMSText(
                  content: '仓库：${model.depotName ?? ''}',
                ),
                SizedBox(
                  height: 8.h,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
