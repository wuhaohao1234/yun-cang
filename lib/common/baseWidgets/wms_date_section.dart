import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSDateSection extends StatelessWidget {
  final VoidCallback callback;
  final String data;

  const WMSDateSection({Key key, this.callback, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _year;
    int _month;
    print('data $data');

    if (data == null) {
      // 没有传递数据 使用今天数据
      DateTime _now = new DateTime.now();
      _year = _now.year;
      _month = _now.month;
    } else {
      // 如果传递过来数据那么拆分解析
      List _str = data.split('-');
      _year = int.parse(_str[0]);
      _month = int.parse(_str[1]);
    }

    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              textAlign: TextAlign.start, // 设置富文本对齐方式
              text: TextSpan(style: DefaultTextStyle.of(context).style, // 使用应用程序默认字体样式, 不然无法显示字体
                  children: [
                    TextSpan(
                      text: "$_year",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "年",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "${_month.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "月",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
