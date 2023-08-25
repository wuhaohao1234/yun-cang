import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/models/address/address_model.dart';

class AddressCellWidget extends StatelessWidget {
  final AddressModel model;
  final VoidCallback callback;
  final VoidCallback select;

  const AddressCellWidget({Key key, this.model, this.callback, this.select}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: select,
      child: Stack(children: [
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
                    Icons.location_on,
                    color: Colors.redAccent,
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
                              model?.userName ?? '',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              model?.userPhone ?? '',
                              style: TextStyle(fontSize: 13.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          '${model?.province}${model?.city}${model?.area}${model?.userAddress}',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
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
            visible: model?.isdefault == 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 0.h),
                color: Colors.lightBlueAccent[100],
                child: WMSText(content: '常用',color: Colors.blue,size: 12,),),
          ),),
      ],),
    );
  }
}
