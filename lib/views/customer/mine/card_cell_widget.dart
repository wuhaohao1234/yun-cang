import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/models/mine/card_model.dart';

class CardCellWidget extends StatelessWidget {
  final CardModel model;
  final VoidCallback callback;
  final VoidCallback select;

  const CardCellWidget({Key key, this.model, this.callback, this.select})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: select,
      child: Stack(
        children: [
          Container(
            width: 375.w,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            margin: EdgeInsets.only(top: 8.h),
            color: Colors.grey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.credit_card_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Container(
                      width: 240.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                model?.accountType == '0' ? '境内银行卡' : '境外银行卡',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            '${model?.identificationCode ?? '--'}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: callback,
                    child: Text(
                      '编辑',
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            ),
          ),
          Positioned(
            top: 10.h,
            child: Visibility(
              visible: true,
              child: Container(
                margin: EdgeInsets.only(left: 8.w),
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                color: model?.adoptType == '0'
                    ? Colors.lightBlueAccent[100]
                    : Colors.grey[300],
                child: WMSText(
                  content: model?.adoptType == '0' ? '已开通' : '未开通',
                  color: Colors.blue,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
