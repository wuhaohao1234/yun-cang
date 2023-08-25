import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSText extends StatelessWidget {
  final bool bold;
  final String content;
  final num size;
  final Color color;
  final TextAlign textAlign;
  final StrutStyle strutStyle;
  final double textHeight;

  const WMSText({
    Key key,
    this.bold = false,
    this.content,
    this.size = 14,
    this.textAlign,
    this.strutStyle,
    this.textHeight,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      overflow: TextOverflow.ellipsis,
      maxLines: 100,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size.sp, height: textHeight, fontWeight: bold ? FontWeight.bold : null),
      strutStyle: strutStyle,
    );
  }
}
