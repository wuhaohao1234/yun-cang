import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_size_tag_widget.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:get/get.dart';

class CommodityKuCunChuKuCellWidget extends StatelessWidget {
  final model;
  final status;
  const CommodityKuCunChuKuCellWidget({Key key, this.model, this.status = "0"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      // color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 60.h,
            child: (model.picturePath != null && model.picturePath.length != 0)
                ? GestureDetector(
                    onTap: () {
                      Get.to(() => PhotoViewPage(
                            images: model.picturePath.split(';'), //传入图片list
                            index: 0, //传入当前点击的图片的index
                          ));
                    },
                    child: Image.network(
                      model.picturePath.split(';')[0],
                      fit: BoxFit.contain,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: Center(child: Text('无图片')),
                    height: 80.h,
                    width: 80.w,
                  ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WMSText(
                  content: '${model?.commodityName ?? '-'}',
                  bold: true,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Visibility(
                  visible: model?.brandName != null,
                  child: WMSText(
                    content: '品牌：${model?.brandName}',
                    color: Colors.grey,
                    size: 13,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                WMSText(
                  content: '货号：${model?.stockCode}',
                  color: Colors.grey,
                  size: 13,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Visibility(
                          visible: model?.color != null,
                          child: WMSSizeTagWidget(
                            title: '${model?.color}',
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        WMSSizeTagWidget(
                          bgColor: status == '0' ? Colors.black : Colors.red,
                          title: '${status == '0' ? '正常' : '瑕疵'}',
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
