import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSSetPwdWidget extends StatelessWidget {
  final String hinText;
  final bool show;
  final TextEditingController controller;
  final VoidCallback callback;

  const WMSSetPwdWidget({Key key, this.hinText, this.show = false, this.controller, this.callback}) : super(key: key);

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
              Expanded(
                child: TextField(
                  cursorColor: Colors.black,
                  obscureText: !show,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hinText,
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
              IconButton(icon: Icon(show ? Icons.remove_red_eye : Icons.remove_red_eye_outlined), onPressed: callback)
            ],
          ),
        ),
      ),
    );
  }
}
