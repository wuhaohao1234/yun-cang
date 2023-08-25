import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMSAccountInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback callback;
  final String areaCode;

  WMSAccountInputWidget(
      {Key key, this.controller, this.callback, this.areaCode = '86'})
      : super(key: key);

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
          child: Container(
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      callback();
                    },
                    child: Container(
                      width: 70.w,
                      child: Row(
                        children: [
                          Text(
                            '+$areaCode',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    )),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '请输入手机号',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
