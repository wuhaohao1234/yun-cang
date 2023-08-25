import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef void OnChangeCallback(value);

class BuildSizeListwidget extends StatefulWidget {
  final sizeList;
  final OnChangeCallback onChangeCallback;
  const BuildSizeListwidget({Key key, this.sizeList, this.onChangeCallback})
      : super(key: key);

  @override
  State<BuildSizeListwidget> createState() => _BuildSizeListwidgetState();
}

class _BuildSizeListwidgetState extends State<BuildSizeListwidget> {
  var selectedStoreIndex;
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedStoreIndex = 0;
    });

    // 开始获取数据, 这里是改变 depotList
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        widget.sizeList.length,
        (index) => Container(
          margin: EdgeInsets.only(right: 10.w),
          alignment: Alignment.center,
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Color(0xfff2f2f2),
            border: selectedStoreIndex == index
                ? Border.all(width: 2.0, color: Colors.black)
                : null,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => {
              print("cool"),
              setState(() {
                selectedStoreIndex = index;
                print(index);
              }),
              widget.onChangeCallback(index),
            },
            child: Column(
              // 每行信息
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.sizeList[index]['size']}${widget.sizeList[index]['specification'] !=null?'/'+widget.sizeList[index]['specification']:''}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                // Text(
                //   1.toString(),
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold, color: Colors.black38),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
