import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../entrepot/pages/ruku/en_lincun_page.dart';

Widget stateWidget({String title, Color bgColor}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r), color: bgColor),
    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
    child: Center(
      child: Text(
        title ?? '',
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    ),
  );
}

