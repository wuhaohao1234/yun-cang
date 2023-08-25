import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WMSCodeInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback callback;

  const WMSCodeInputWidget({Key key, this.controller, this.hintText = '', this.callback}) : super(key: key);

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
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
              GestureDetector(onTap: callback, child: SvgPicture.asset('assets/svgs/scan.svg',width: 17.w,),),
            ],
          ),
        ),
      ),
    );
  }
}
