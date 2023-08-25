//临存单
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_info_row.dart';
import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';
import '../../../entrepot/pages/en_logistics_page.dart';
import 'package:get/get.dart';
class ENLinCunCell extends StatelessWidget {
  final VoidCallback callback;
  final ENYbrkModel model;

  const ENLinCunCell({Key key, this.callback, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          content: model?.orderIdName ?? '',
                          leftInset: 8,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
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
                  content: '${model?.boxTotal ?? 0}',
                  leftInset: 8,
                )),
              ],
            ),
            SizedBox(
              height: 4.h,
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
                  title: '预约总数：',
                  content: '${model?.skusTotal ?? 0}',
                  leftInset: 8,
                )),
              ],
            ),
            SizedBox(
              height: 4.h,
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
                  title: '物流状态：',
                  content: model?.mailNo ?? '',
                  leftInset: 8,
                )),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    Get.to(() => ENLogisticsPage(dataCode: model?.mailNo));
                  },
                  child: const Text(
                    '查看物流',
                    style: TextStyle(color: AppStyleConfig.btnColor),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 24.w,
                ),
                Expanded(
                    child: Text("操作要求：临存",
                        style: TextStyle(color: Colors.red, fontSize: 14))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
