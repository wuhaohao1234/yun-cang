import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wms/views/common/tag_widget.dart';
import 'package:wms/common/baseWidgets/wms_size_tag_widget.dart';

class OrderCommoditycell extends StatelessWidget {
  final model;
  const OrderCommoditycell({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            child: model?.picturePath != null
                ? Image.network(
                    model?.picturePath?.split(";")[0] ?? '',
                    height: 48.h,
                    width: 48.w,
                    fit: BoxFit.contain,
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: Center(child: Text('无图片')),
                    height: 48.h,
                    width: 48.w,
                  ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${model?.productName ?? ''}',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: model?.size != null,
                            child: WMSSizeTagWidget(
                              title: '${model?.size ?? '无尺码'}${model?.specification != null?"/"+model?.specification:""}',
                            ),
                          ),

                          Visibility(
                            visible: model?.color != null,
                            child: WMSSizeTagWidget(
                              title: '${model?.color ?? ''}',
                            ),
                          ),
                          Visibility(
                            visible: model?.status != null,
                            child: WMSSizeTagWidget(
                              bgColor: model?.status == 0
                                  ? Colors.black
                                  : Colors.red,
                              title: '${model?.status == 0 ? '正常' : '瑕疵'}',
                            ),
                          ),
                          // margin: EdgeInsets.only(right: 4.w),
                          // ),
                        ],
                      ),
                      Text(
                        'x${'${model?.buyNum ?? 0}'}',
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold),
                      )
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
