import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/models/mine/moneys_log_model.dart';

class MoneysLogCell extends StatelessWidget {
  final MoneysLogModel model;

  const MoneysLogCell({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.grey[100]),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model?.remark ?? 'remark'}',
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  '${model.createTime ?? 'createTime'}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                model?.moneyType == 0 ? '-' : '',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '${model?.money ?? 0.0}',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
