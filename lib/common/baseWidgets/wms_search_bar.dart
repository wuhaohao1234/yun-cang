import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 28.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.h),
        color: Colors.grey[100],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 18.sp,
              color: Colors.grey,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              '搜索',
              style: TextStyle(fontSize: 14.sp, color: Colors.black26),
            ),
          ],
        ),
      ),
    );
  }
}
