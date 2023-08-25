//尺寸选择
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_config.dart';

typedef void OnChangeCallback(value);

class CommodityResalePriceWidget extends StatefulWidget {
  final num initNumber;
  final String title;
  final OnChangeCallback onChangeCallback;

  const CommodityResalePriceWidget({
    Key key,
    this.title,
    this.initNumber,
    this.onChangeCallback,
  }) : super(key: key);

  @override
  _CommodityResalePriceWidgetState createState() =>
      _CommodityResalePriceWidgetState();
}

class _CommodityResalePriceWidgetState
    extends State<CommodityResalePriceWidget> {
  var actualNumber;
  var checkValue;
  TextEditingController actualNumberController;
  @override
  void initState() {
    super.initState();

    actualNumber = double.parse(widget.initNumber.toString()) ?? 0.00;
    print('初始化: 初始数量是 $actualNumber');
    actualNumberController = TextEditingController();
  }

  @override
  void dispose() {
    print('移除 ${actualNumberController.text}');
    actualNumberController.text = "0.00";
    actualNumberController.dispose();
    super.dispose();
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              WMSText(
                content: '${widget.title ?? ''}',
                size: 14,
                bold: true,
                color: Colors.black,
              ),
              SizedBox(width: 8.w),
              WMSText(
                content: actualNumber >= 0.00 ? "加价" : "减价",
                size: 14,
                bold: true,
                color: actualNumber >= 0.00 ? AppConfig.themeColor : Colors.red,
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Container(
            // height: 30.h,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      actualNumber = actualNumber - 1.00;
                      actualNumberController.text =
                          ((actualNumber * 100).floor() / 100).toString();
                      print("-1.00");

                      actualNumber = double.parse(actualNumberController.text);
                      widget.onChangeCallback(actualNumber);
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
                Container(
                  width: 60.w,
                  height: 30.h,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  // color: Colors.red,
                  child: Center(
                    child: TextField(
                      maxLines: 1,
                      onTap: () {
                        if (double.parse(actualNumberController.text) == 0.00) {
                          actualNumberController.text = "0.00";
                        }
                      },
                      onChanged: (value) {
                        actualNumber =
                            double.parse(actualNumberController.text);
                        widget.onChangeCallback(actualNumber);
                      },
                      decoration: InputDecoration(
                        hintText: "0.00",
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 6.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.r),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0.1),
                        ),
                        // hintStyle: TextStyle(fontSize: 13.sp),
                      ),
                      controller: actualNumberController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      actualNumber = actualNumber + 1.00;
                      actualNumberController.text =
                          ((actualNumber * 100).floor() / 100).toString();
                    });

                    actualNumber = double.parse(actualNumberController.text);
                    widget.onChangeCallback(actualNumber);
                  },
                  child: Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    width: 30.w,
                    height: 24.w,
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
