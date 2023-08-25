import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSStateLabel extends StatelessWidget {
  final String title;
  final Color bgColor;
  final VoidCallback callback;

  const WMSStateLabel({Key key, this.title, this.bgColor = const Color(0xFF33D3BA), this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color:bgColor,),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
        child: Center(
          child: Text(
            title ?? '',
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}
