import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'wms_text.dart';

typedef void OnChangedCallback(string);
typedef void OnSubmittedCallback(string);

class WMSTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final Widget endWidget;
  final bool showArrow;
  final bool redOnly;
  final TextInputType keyboardType;
  final double marginTop;
  final OnChangedCallback onChangedCallback;
  final OnSubmittedCallback onSubmittedCallback;

  const WMSTextField(
      {Key key,
      this.title,
      this.controller,
      this.endWidget,
      this.redOnly = false,
      this.hintText,
      this.keyboardType = TextInputType.number,
      this.showArrow = false,
      this.marginTop,
      this.onChangedCallback,
      this.onSubmittedCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop == null ? 16.h : marginTop),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
        ),
      ),
      child: Row(
        children: [
          WMSText(
            content: title ?? '',
            bold: true,
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: TextField(
              readOnly: redOnly,
              cursorColor: Colors.black,
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(fontSize: 15.sp),
              onChanged: (value) {
                if(onChangedCallback!=null){
                  onChangedCallback(value);
                }
                final val =
                    TextSelection.collapsed(offset: controller.text.length);
                controller.selection = val;
              },
              onSubmitted: (value) {
                controller.value = TextEditingValue(
                    text: controller.text,
                    selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: controller.text.length,
                    )));
                if (onSubmittedCallback != null) {
                  onSubmittedCallback(value);
                }
              },
              decoration: InputDecoration(
                hintText: hintText ?? '',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 13.sp),
              ),
            ),
          ),
          Container(child: endWidget),
          Visibility(
            visible: showArrow,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
