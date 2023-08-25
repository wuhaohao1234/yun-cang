import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/customer/common.dart';

import 'package:wms/models/market/market_wares_model.dart';

class MarketGridCellWidget extends StatefulWidget {
  final MarketWaresModel model;
  final int type; // 1:库存
  final bool selected; // 多选框状态
  final Function(MarketWaresModel) selectCallBack; // 手动选择回调
  final Function(dynamic) onChangedAllCheckbox;

  const MarketGridCellWidget(
      {Key key, this.model, this.type, this.selected = false, this.selectCallBack, this.onChangedAllCheckbox})
      : super(key: key);

  @override
  _MarketGridCellWidgetState createState() => _MarketGridCellWidgetState();
}

class _MarketGridCellWidgetState extends State<MarketGridCellWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      color: Colors.white,
      margin: EdgeInsets.only(top: 0.h),
      child: Column(
        children: [
          // Expanded(
          //   flex: 2,
          //   child: GestureDetector(
          //     onTap: () {
          // Get.to(() => PhotoViewPage(
          //       images: widget.model.picturePath.split(';'), //传入图片list
          //       index: 0, //传入当前点击的图片的index
          //     ));
          //     },
          //     child: Image.network(
          //       '${widget.model.picturePath}',
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          // ),

          // SizedBox(
          //     height: MediaQuery.of(context).size.height * 0.13,
          //     child: Container(
          //       alignment: Alignment.center,
          //       child: widget.model.picturePath.split(";").length != 1
          //           ? Image.network(
          //               '${widget.model.picturePath.split(";")[0]}',
          //               fit: BoxFit.contain,
          //             )
          //           : Image.network(
          //               '${widget.model.picturePath}',
          //               fit: BoxFit.contain,
          //             ),
          //     )),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: widget.model.picturePath.split(";").length != 1
                ? Image.network(
                    '${widget.model.picturePath.split(";")[0]}',
                    fit: BoxFit.contain,
                  )
                : Image.network(
                    '${widget.model.picturePath}',
                    fit: BoxFit.contain,
                  ),
          )),
          SizedBox(
            height: 4.h,
          ),
          // Expanded(
          //   child: Text(
          //     '${widget.model.commodityName ?? ''}',
          //     maxLines: 2,
          //     overflow: TextOverflow.ellipsis,
          //     // overflow: TextOverflow.visible,
          //     style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.sp),
          //   ),
          // ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.05,
              child: Text(
            '${widget.model.commodityName ?? ''}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            // overflow: TextOverflow.visible,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.sp,color: Colors.black54),
          )),
          SizedBox(
            height: 4.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '¥${widget.model.previewPrice.toString() ?? 0}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              Text(
                '${widget.model.payerNumber ?? 0}人付款',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
