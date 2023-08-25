// 理货单 Cell
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/models/entrepot/chuku/en_chucang_model.dart';

class ENChuCangLinCunCell extends StatelessWidget {
  final VoidCallback callback;
  final ENChuCangModel model;
  final bool imgshow;

  const ENChuCangLinCunCell(
      {Key key, this.callback, this.model, this.imgshow = true})
      : super(key: key);

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
        child: Row(children: [
          Visibility(
            visible: imgshow,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: model.outOrderImg != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage(model.outOrderImg.split(";")[0] ?? ''),
                        fit: BoxFit.contain,
                      ),
                      border: Border.all(
                        width: 1.w,
                        color: Colors.black,
                      ),
                    )
                  : BoxDecoration(
                      border: Border.all(
                        width: 1.w,
                        color: Colors.black,
                      ),
                    ),
              child: Container(),
            ),
          ),
          // WMSImageWrap(imagePaths: model?.instoreOrderImg?.split(";")),
          SizedBox(
            width: 8.sp,
          ),
          Expanded(
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
                              title: '出仓单号: ',
                              content: model?.wmsOutStoreName ?? '',
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
                      title: '出库类型: ',
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
                      title: '收件人: ',
                      content: model?.consigneeName ?? '',
                      leftInset: 8,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.format_list_numbered,
                      color: Colors.black,
                      size: 17,
                    ),
                    Expanded(
                        child: WMSInfoRow(
                      title: '快递箱数: ',
                      content: '${model?.boxTotalFact ?? 0}',
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
                      Icons.format_list_numbered,
                      color: Colors.black,
                      size: 17,
                    ),
                    Expanded(
                        child: WMSInfoRow(
                      title: '入库物流单号: ',
                      content: model?.mailNo ?? '',
                      leftInset: 8,
                    )),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
