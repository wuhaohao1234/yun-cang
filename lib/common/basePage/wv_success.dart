import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/customer/main/cs_main_page.dart';

/// Create by bendi on 2021/7/19
/// Description:

class SuccessPage extends StatefulWidget {
  final String title;
  final Text content;
  final OutlinedButton button;

  const SuccessPage({Key key, @required this.title, this.content, this.button})
      : super(key: key);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_turned_in,
                      color: Colors.black,
                      size: 60.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    Visibility(
                      visible: widget.content != null,
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: widget.content,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 130.0),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: buildOutlinedButtonList,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get buildOutlinedButtonList {
    List<Widget> _widget = [
      OutlinedButton(
        style: TextButton.styleFrom(
          primary: Colors.black,
          backgroundColor: Color(0xfff2f2f2),
          // minimumSize: Size(80.w, 34.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
        ),
        onPressed: () {
          Get.offAll(() => CSMainPage());
        },
        child: Text(
          '返回首页',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
    ];
    if (widget.button != null) {
      _widget.add(widget.button);
    }
    return _widget;
  }
}
