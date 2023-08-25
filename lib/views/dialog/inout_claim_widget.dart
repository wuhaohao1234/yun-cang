import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';

class InoutClaimWidget extends StatefulWidget {
  final Function(String) callback;

  const InoutClaimWidget({Key key, this.callback}) : super(key: key);

  @override
  _InoutClaimWidgetState createState() => _InoutClaimWidgetState();
}

class _InoutClaimWidgetState extends State<InoutClaimWidget> {
  final TextEditingController textC = TextEditingController();
  FocusNode _focusNode;
  String num1 = '';
  String num2 = '';
  String num3 = '';
  String num4 = '';
  String code = '****';

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Center(
            child: Stack(alignment: AlignmentDirectional.center, children: [
              Container(
                height: 100.h,
                width: 260.w,
              ),
              Container(
                width: 10.w,
                child: TextField(
                  focusNode: _focusNode,
                  autofocus: true,
                  controller: textC,
                  keyboardType: TextInputType.url,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4), //限制长度
                  ],
                  onChanged: (value) {
                    if (value.length == 0) return;
                    setState(() {});
                    if (textC.text.length == 4) {
                      widget.callback(textC.text);
                    }
                  },
                ),
              ),
              Positioned(
                top: 0.h,
                child: Container(
                  height: 100.h,
                  width: 260.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Colors.white),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WMSText(
                          content: '输入快递单号后4位',
                          size: 17,
                          bold: true,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          width: 200.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.h, color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: WMSText(
                                      content: textC.text.length > 0
                                          ? textC.text[0]
                                          : '',
                                      size: 17,
                                      bold: true,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40.h,
                                width: 1.w,
                                color: Colors.black,
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: WMSText(
                                      content: textC.text.length > 1
                                          ? textC.text[1]
                                          : '',
                                      size: 17,
                                      bold: true,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40.h,
                                width: 1.w,
                                color: Colors.black,
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: WMSText(
                                      content: textC.text.length > 2
                                          ? textC.text[2]
                                          : '',
                                      size: 17,
                                      bold: true,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40.h,
                                width: 1.w,
                                color: Colors.black,
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: WMSText(
                                      content: textC.text.length > 3
                                          ? textC.text[3]
                                          : '',
                                      size: 17,
                                      bold: true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildPwdPointWidget(String pwd) {
    if (pwd == null) {
      return Container();
    }
    return Visibility(
      visible: pwd.length > 0,
      child: Container(
        width: 484.w,
        height: 75.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildPointWidget(textC.text.length > 0),
            buildPointWidget(textC.text.length > 1),
            buildPointWidget(textC.text.length > 2),
            buildPointWidget(textC.text.length > 3),
            buildPointWidget(textC.text.length > 4),
            buildPointWidget(textC.text.length > 5),
          ],
        ),
      ),
    );
  }

  Widget buildPointWidget(bool show) {
    return Expanded(
      flex: 1,
      child: Visibility(
        visible: show,
        child: Center(
          child: Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Color(0xFF000000),
            ),
          ),
        ),
      ),
    );
  }
}
