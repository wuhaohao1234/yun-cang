import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/models/logistics_model.dart';
class LogisticsCell extends StatelessWidget {

  final TracesModel model;

  const LogisticsCell({Key key,this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 0.h),
      child: Row(children: [
        Container(width: 60.w,child: WMSText(content: model.AcceptTime??'',size: 12,),),
        Container(width: 40.w,child: Column(children: [
          Container(height: 20.h,width: 1.w,color: Colors.grey,),
          Container(width: 10.w,height: 10.w,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r),color: Colors.black),),
          Container(height: 20.h,width: 1.w,color: Colors.grey,),
        ],),),
        Expanded(child: WMSText(content: model.AcceptStation??'',size: 12,)),
      ],),);
  }
}
