import 'package:wms/customer/common.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/common/baseWidgets/wms_info_row.dart';
import 'package:wms/models/entrepot/chuku/en_fenjian_model.dart';

class ENFenJianCell extends StatelessWidget {
  final VoidCallback callback;
  final ENFenJianModel model;
  final int index; //for debugging purpose

  const ENFenJianCell({Key key, this.callback, this.model, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // debugging
            // Text(
            //   '(DEBUG) ID:$index, outOrderId: ${model.outOrderId}',
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
                          title: '出库单号: ',
                          content: model?.outStoreName ?? '',
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
                  title: '出库类型：',
                  content: model?.logisticsName ?? '',
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
                  title: '收件人：',
                  content: model?.consigneeName ?? '',
                  leftInset: 8,
                )),
              ],
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
                  title: '出库数量：',
                  content:
                      '${model?.spuNumber ?? 0}个商品，共${model?.totalSku ?? 0}个',
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
