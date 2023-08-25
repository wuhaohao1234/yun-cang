import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_info_row.dart';
// import 'package:wms/common/baseWidgets/wms_button.dart';
// import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';
import 'package:wms/models/entrepot/ruku/en_rkd_model.dart';
// import 'package:get/get.dart';

class ENDaiShangJiaCell extends StatelessWidget {
  final VoidCallback callback;
  final ENRkdModel model;
  final int index; //for debugging purpose

  const ENDaiShangJiaCell({Key key, this.callback, this.model, this.index})
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
              color: Colors.grey[200],
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // debugging
            // Text(
            //   '(DEBUG) ID:$index, prepareOrderId：${model?.prepareOrderId ?? 0}',
            //   style: TextStyle(
            //     fontSize: 10,
            //     color: Colors.redAccent,
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        color: Colors.black,
                        size: 17,
                      ),
                      Expanded(
                        child: WMSInfoRow(
                          title: '入仓单号：',
                          content: model?.instoreOrderCode ?? '',
                          leftInset: 8,
                        ),
                      )
                    ],
                  ),
                ),
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
                // TextButton(
                //   style: TextButton.styleFrom(
                //     textStyle: const TextStyle(fontSize: 12),
                //   ),
                //   onPressed: () {
                //     Get.to(() => ENLogisticsPage(dataCode: model?.mailNo));
                //   },
                //   child: const Text(
                //     '查看物流',
                //     style: TextStyle(color: AppStyleConfig.btnColor),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: padding,
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
                  title: '客户代码：',
                  content: '${model?.userCode ?? ''}',
                  leftInset: 8,
                )),
              ],
            ),
            SizedBox(
              height: padding,
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
                  title: '建议库位：',
                  content: '${model?.depotPosition ?? '无推荐库位'}',
                  leftInset: 8,
                )),
              ],
            ),
            SizedBox(
              height: padding,
            ),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.insert_drive_file,
            //       color: Colors.black,
            //       size: 17,
            //     ),
            //     Expanded(
            //         child: WMSInfoRow(
            //       title: '预约箱数：',
            //       content: '${model?.boxTotal ?? 0}',
            //       leftInset: 8,
            //     )),
            //   ],
            // ),
            // SizedBox(
            //   height: padding,
            // ),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.insert_drive_file,
            //       color: Colors.black,
            //       size: 17,
            //     ),
            //     Expanded(
            //         child: WMSInfoRow(
            //       title: '预约总数：',
            //       content: '${model?.skusTotal ?? 0}',
            //       leftInset: 8,
            //     )),
            //   ],
            // ),
            // SizedBox(
            //   height: padding,
            // ),

            Row(
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: Colors.black,
                  size: 17,
                ),
                Expanded(
                    child: WMSInfoRow(
                  title: '上架总数：',
                  content: '${model?.skusTotalFact ?? 0}',
                  leftInset: 8,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
