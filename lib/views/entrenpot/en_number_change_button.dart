import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/models/shopping_cart_model.dart';

class ENNumberChangeButtonWidget extends StatelessWidget {
  final VoidCallback addCallback;
  final VoidCallback subCallback;
  final ShoppingCartModel dataModel;

  const ENNumberChangeButtonWidget(
      {Key key, this.addCallback, this.subCallback, this.dataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      color: Colors.white,
      padding: EdgeInsets.only(top: 8.h, right: 16.w, bottom: 8.h),
      child: Row(
        children: [
          WMSText(
            content: '¥456',
            bold: true,
            color: Colors.red,
          ),
          SizedBox(
            width: 8.w,
          ),
          GestureDetector(
            onTap: subCallback,
            child: Container(
              color: Colors.grey[200],
              alignment: Alignment.center,
              width: 30.w,
              height: 24.w,
              child: WMSText(
                content: '-',
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            alignment: Alignment.center,
            width: 30.w,
            height: 24.w,
            child: WMSText(
              content: dataModel?.count.toString(),
            ),
          ),
          GestureDetector(
            onTap: addCallback,
            child: Container(
              color: Colors.grey[200],
              alignment: Alignment.center,
              width: 30.w,
              height: 24.w,
              child: WMSText(
                content: '+',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
