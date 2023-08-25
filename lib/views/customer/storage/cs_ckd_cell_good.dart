import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_size_tag_widget.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/models/storage/sku_list_item.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:get/get.dart';

class CSDkdGoodCell extends StatelessWidget {
  final SkuListItem model;
  final bool exceptionType;

  const CSDkdGoodCell({Key key, this.model, this.exceptionType = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      // color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 60.h,
            child: (model.itemImg != null && model.itemImg.length != 0) ||
                    (model?.imgUrl != null && model.imgUrl.length != 0)
                ? GestureDetector(
                    onTap: () {
                      Get.to(() => PhotoViewPage(
                            images: exceptionType ? model.itemImg.split(';') : model?.imgUrl?.split(';'), //传入图片list
                            index: 0, //传入当前点击的图片的index
                          ));
                    },
                    child: Image.network(
                      model.itemImg ?? model?.imgUrl,
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
                  content: '${model?.commodityName ?? model?.skuName ?? '-'}',
                  bold: true,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Visibility(
                  visible: model?.brandNameCn != null,
                  child: WMSText(
                    content: '品牌：${model?.brandNameCn}',
                    color: Colors.grey,
                    size: 13,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                WMSText(
                  content: '条形码：${model?.barCode}',
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
                        WMSSizeTagWidget(
                          title:
                              '${model?.size ?? '无尺码'} ${model?.specification != null ? "/" + model?.specification : ""}',
                          fontSize: 11,
                        ),

                        // SizedBox(
                        //   width: 4.w,
                        // ),
                        Visibility(
                          visible: model?.color != null,
                          child: WMSSizeTagWidget(
                            title: '${model?.color}',
                          ),
                        ),
                        // SizedBox(
                        //   width: 4.w,
                        // ),
                        WMSSizeTagWidget(
                          bgColor: model?.status == '0' ? Colors.black : Colors.red,
                          title: '${model?.status == '0' ? '正常' : '瑕疵'}',
                        ),
                      ],
                    ),
                    Text(
                      'x${'${model?.skuNumber ?? 0}'}',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                    )
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
