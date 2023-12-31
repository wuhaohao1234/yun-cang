import 'package:flutter/material.dart';

///  自定义 键盘 按钮
class CustomKbBtn extends StatefulWidget {
  ///  按钮显示的文本内容
  String text;

  CustomKbBtn({Key key, this.text, this.callback}) : super(key: key);

  ///  按钮 点击事件的回调函数
  final callback;

  @override
  State<StatefulWidget> createState() {
    return ButtonState();
  }
}

class ButtonState extends State<CustomKbBtn> {
  ///回调函数执行体
  var backMethod;

  void back() {
    widget.callback('$backMethod');
  }

  @override
  Widget build(BuildContext context) {
    /// 获取当前屏幕的总宽度，从而得出单个按钮的宽度
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var _screenWidth = mediaQuery.size.width;

    return new Container(
        height: 50.0,
        width: _screenWidth / 3,
        child: new OutlinedButton(
          // 直角
          // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0)),
          // 边框颜色
          // borderSide: new BorderSide(color: Color(0x10333333)),
          child: new Text(
            widget.text,
            style: new TextStyle(color: Color(0xff333333), fontSize: 20.0),
          ),
          // 按钮点击事件
          onPressed: back,
        ));
  }
}
