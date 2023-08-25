import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/configs/app_style_config.dart';

class WMSButton extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  final Color bgColor;
  final Color textColor;
  final double height;
  final double width;
  final double radius;
  final bool showBorder;
  final double fontSize;

  const WMSButton(
      {Key key,
      this.callback,
      this.title,
      this.showBorder = false,
      this.bgColor = AppStyleConfig.btnColor,
      // this.bgColor = Colors.white,
      this.radius = 5,
      // this.radius = 0,
      this.textColor = Colors.white,
      // this.textColor = Colors.black,
      this.height = 34.0,
      this.width = 343.0,
      this.fontSize = 13})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: width.w,
      child: GestureDetector(
        onTap: callback,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radius.r),
            // boxShadow: [BoxShadow()],
            border: showBorder
                ? Border.all(
                    width: 1.0,
                    color: this.bgColor == Colors.white ||
                            this.bgColor == Colors.transparent
                        ? Colors.black
                        : this.bgColor,
                  )
                : Border.all(
                    width: 1.0,
                    color: bgColor,
                  ),
          ),
          child: Center(
            child: Text(
              title ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize.sp,
                  color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
