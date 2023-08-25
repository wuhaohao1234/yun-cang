import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSPasswordInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const WMSPasswordInputWidget({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 300.w,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60.w,
                child: Text(
                  '密码',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: TextField(
                  cursorColor: Colors.black,
                  obscureText: true,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: '请输入密码',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
