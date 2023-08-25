import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSRcButtonWidget extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback callback;

  const WMSRcButtonWidget({Key key, this.title, this.color = Colors.black, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      color: Colors.black,
      child: Text(
        title ?? '',
        style: TextStyle(color: Colors.white, fontSize: 10.sp),
      ),
    );
  }
}
