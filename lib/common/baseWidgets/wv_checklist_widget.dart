import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/models/market/market_wares_model.dart';

/// Create by bigv on 21-7-17
/// Description:
class ChecklistWidget extends StatelessWidget {
  const ChecklistWidget({
    Key key,
    this.type, // 根据类型显示内容
    @required MarketWaresModel data,
  })  : _data = data,
        super(key: key);

  final MarketWaresModel _data;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.w),
      margin: EdgeInsets.only(bottom: 20.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.w, color: Color(0xfff2f2f2)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              margin: EdgeInsets.only(right: 15.w),
              child: _data?.imgUrl != null
                  ? Image.network(
                      _data?.imgUrl,
                      width: 80.w,
                      height: 80.w,
                    )
                  : SizedBox(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200.w,
                  child: Text(
                    _data?.commodityName ?? '-',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      WMSText(
                        content: '品牌:  ${_data?.brandNameCn ?? '-'}',
                        size: 10.sp,
                        color: Colors.black38,
                      ),
                      SizedBox(width: 10.w),
                      WMSText(
                        content: '条形码: ${_data?.barCode ?? '-'}',
                        size: 10.sp,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      color: Colors.black,
                      child: WMSText(
                        content: _data?.color ?? '-',
                        size: 10.sp,
                        bold: true,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      color: Colors.black,
                      child: WMSText(
                        content: _data?.size ?? '无尺码',
                        size: 10.sp,
                        bold: true,
                        color: Colors.white,
                      ),
                    ),
                    // Visibility(
                    //   visible: type == 'ycj',
                    //   child: Container(
                    //     margin: EdgeInsets.only(right: 8.w),
                    //     child: WMSText(
                    //       content: 'x1???',
                    //       size: 10.sp,
                    //       bold: true,
                    //     ),
                    //   ),
                    // ),
                    Visibility(
                      visible: type == 'ck',
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        color: Colors.black,
                        child: WMSText(
                          content: _data?.status == '0' ? '正常' : '瑕疵',
                          size: 10.sp,
                          bold: true,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
