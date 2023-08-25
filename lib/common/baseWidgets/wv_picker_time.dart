import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Create by bigv on 21-7-13
/// 日期选择器
/// Description:
class PickerTimeWidget extends StatefulWidget {
  final String item;
  final Function callback;

  PickerTimeWidget({Key key, this.item, this.callback}) : super(key: key);

  @override
  _PickerTimeWidgetState createState() => _PickerTimeWidgetState();
}

class _PickerTimeWidgetState extends State<PickerTimeWidget> {
  List<String> arrays = [];
  int index = 0;
  int confirmIndex;
  ScrollController controller;

  @override
  void initState() {
    int _year = DateTime.now().year;
    int _month = DateTime.now().month;
    for (var _y = _year - 1; _y <= _year; _y++) {
      int __year = _y == _year - 1 ? _month : 1;
      int __month = _y == _year ? _month : 12;
      for (var _m = __year; _m <= __month; _m++) {
        String _str = '$_y-${_m.toString().padLeft(2, "0")}';
        arrays.add(_str);
      }
    }

    if (widget.item != null) {
      index = arrays.indexOf(widget.item);
    }

    controller = new FixedExtentScrollController(initialItem: index);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(primary: Colors.black54),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
              style: TextButton.styleFrom(primary: Colors.black),
              onPressed: () {
                setState(() {
                  confirmIndex = index;
                });
                widget.callback(arrays[confirmIndex]);
                Navigator.pop(context);
              },
              child: Text('选择'),
            ),
          ],
        ),
        SizedBox(
          height: 300.w,
          width: double.infinity,
          child: CupertinoPicker(
            scrollController: controller,
            itemExtent: 45,
            onSelectedItemChanged: setPicker,
            children: arrays
                .map((e) => Container(
                      alignment: Alignment.center,
                      child: Text('$e', style: TextStyle(fontSize: 18)),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  // 设置滚动日期数据
  void setPicker(i) {
    setState(() {
      index = i;
    });
  }
}
