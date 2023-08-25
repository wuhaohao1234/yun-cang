// 无主单 Cell
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';
import 'package:wms/utils/wms_util.dart';

class ENWzdCell extends StatelessWidget {
  final VoidCallback callback;
  final ENYbrkModel model;
  final bool imgshow;

  const ENWzdCell({Key key, this.callback, this.model, this.imgshow})
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
          Container(
            width: 100.w,
            height: 100.w,
            decoration: model.ownerlessImg != null
                ? BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage(model.ownerlessImg.split(";")[0] ?? ''),
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
                              title: '无主单号：',
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
                      Icons.format_list_numbered,
                      color: Colors.black,
                      size: 17,
                    ),
                    Expanded(
                        child: WMSInfoRow(
                      title: '快递单号：',
                      content: model?.mailNo ?? '',
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
                      title: '签收日期：',
                      content: model?.updateTime ?? '',
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
                      title: '入库要求：',
                      content: WMSUtil.orderOperationalRequirementsStringChange(
                          model?.orderOperationalRequirements.toString()),
                      leftInset: 8,
                    )),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
