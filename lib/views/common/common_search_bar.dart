import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonSearchBar extends StatelessWidget {
  final VoidCallback scanCallBack;
  final Function searchCallBack;
  final double width;
  final String placeHolder;
  final bool showScanIcon;

  const CommonSearchBar({
    Key key,
    this.scanCallBack,
    this.searchCallBack,
    this.width = 375,
    this.placeHolder = '输入单号/快递号搜索',
    this.showScanIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: 28.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.h),
        color: Colors.grey[50],
      ),
      child: Container(
        height: 28.h,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: searchCallBack,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 18.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: searchCallBack,
                    child: Text(
                      this.placeHolder,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black26),
                    ),
                  ),
                ],
              ),
              if (showScanIcon)
                GestureDetector(
                  onTap: scanCallBack,
                  child: SvgPicture.asset(
                    'assets/svgs/scan.svg',
                    width: 17.w,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
