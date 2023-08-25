//尺寸选择
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/utils/easy_loading_util.dart';

typedef void OnChangeCallback(value);

class CommonChooseSizeWidget extends StatefulWidget {
  final initNumber;
  final String size;
  final bool checkValue;
  final OnChangeCallback onChangeCallback;
  final bool checkButtonshow;
  final String hintText;
  final int compareNumber;
  final bool compareStatus;
  const CommonChooseSizeWidget({
    Key key,
    this.size,
    this.initNumber,
    this.checkValue,
    this.onChangeCallback,
    this.checkButtonshow = true,
    this.hintText = '',
    this.compareNumber,
    this.compareStatus = false, //默认为不比较最大数量
  }) : super(key: key);

  @override
  _CommonChooseSizeWidgetState createState() =>
      _CommonChooseSizeWidgetState();
}

class _CommonChooseSizeWidgetState extends State<CommonChooseSizeWidget> {
  var actualNumber;
  var checkValue;
  TextEditingController actualNumberController;

  @override
  void initState() {
    super.initState();

    actualNumber = widget.initNumber ?? 0;
    checkValue = widget.checkValue ?? true;
    actualNumberController =
        TextEditingController(text: actualNumber.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 2.h,
      ),
      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
      //   ),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (widget.checkButtonshow)
                Checkbox(
                  value: checkValue,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  tristate: true,
                  onChanged: (_) {
                    setState(() {
                      checkValue = !checkValue;
                      if (checkValue == false) {
                        EasyLoadingUtil.showMessage(message: '请确认是否选择该sku');
                        return false;
                      }
                      if (checkValue) {
                        //获取尺码数据
                        print(actualNumber);
                        actualNumberController.text = actualNumber.toString();
                        EasyLoadingUtil.showMessage(message: '已选择该sku');
                        widget.onChangeCallback(actualNumber);
                      }
                    });
                  },
                ),
              WMSText(
                content: '${widget.size}',
                size: 12,
                bold: true,
                color: actualNumber > 0 ? Colors.black : Colors.grey,
              ),
              SizedBox(width: 8.w),
              WMSText(
                content: widget.hintText,
                size: 12,
                color: Colors.grey,
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (actualNumber == 0) {
                      actualNumber = 0;
                      actualNumberController.text = actualNumber.toString();
                      checkValue = false;
                    } else {
                      actualNumber = actualNumber - 1;
                      actualNumberController.text = actualNumber.toString();
                      print("-1");
                    }
                    if (checkValue) {
                      actualNumberController.text = actualNumber.toString();
                      actualNumber = int.parse(actualNumberController.text);
                      widget.onChangeCallback(actualNumber);
                    }
                  });
                },
                child: Container(
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  width: 30.w,
                  height: 24.w,
                  child: Icon(Icons.remove),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 8.w),
              //   child: WMSText(
              //     content: actualNumber.toString(),
              //     bold: true,
              //     textAlign: TextAlign.center,
              //     color: Colors.red,
              //   ),
              // ),
              Container(
                width: 60.w,
                height: 30.h,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                child: TextField(
                  onChanged: (value) {
                    actualNumber = int.parse(actualNumberController.text);
                    widget.onChangeCallback(actualNumber);
                  },
                  decoration: InputDecoration(
                    hintText: '数量',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide:
                            BorderSide(color: Colors.black, width: 0.1)),
                    hintStyle: TextStyle(fontSize: 13.sp),
                  ),
                  controller: actualNumberController,
                  keyboardType: TextInputType.number,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.compareStatus) {
                      if (actualNumber < widget.compareNumber) {
                        actualNumber = actualNumber + 1;
                        actualNumberController.text = actualNumber.toString();
                      } else {
                        actualNumber = widget.compareNumber;
                        actualNumberController.text = actualNumber.toString();
                        EasyLoadingUtil.showMessage(message: '不得超过最大数量');
                      }
                    } else {
                      actualNumber = actualNumber + 1;
                      actualNumberController.text = actualNumber.toString();
                    }

                    print("+1");
                  });
                  if (checkValue) {
                    actualNumber = int.parse(actualNumberController.text);
                    widget.onChangeCallback(actualNumber);
                  }
                },
                child: Container(
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  width: 30.w,
                  height: 24.w,
                  child: Icon(Icons.add),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
