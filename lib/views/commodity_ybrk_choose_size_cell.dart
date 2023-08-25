//尺寸选择
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/baseWidgets/wms_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

import 'package:wms/utils/easy_loading_util.dart';

typedef void OnChangeCallback(value);
typedef void OnSkuCodeCallback(value);

class CommodityChooseSizeWidget extends StatefulWidget {
  final stockCode;
  final int index;
  final initNumber;
  final String size;
  final String specification;
  final String skuCode;
  final bool checkValue;
  final OnChangeCallback onChangeCallback;
  final bool checkButtonshow;
  final String hintText;
  final String skuCodeHintText;
  final int compareNumber;
  final bool compareStatus;
  final bool editButtonShow;
  final bool skuCodeShow;
  final OnSkuCodeCallback onSkuCodeCallback;

  const CommodityChooseSizeWidget({
    Key key,
    this.stockCode,
    this.index,
    this.size,
    this.specification,
    this.skuCode,
    this.initNumber,
    this.checkValue,
    this.onChangeCallback,
    this.onSkuCodeCallback,
    this.checkButtonshow = true,
    this.hintText = '',
    this.skuCodeHintText,
    this.compareNumber,
    this.compareStatus = false, //默认为不比较最大数量
    this.editButtonShow = true,
    this.skuCodeShow = false,
  }) : super(key: key);

  @override
  _CommodityChooseSizeWidgetState createState() => _CommodityChooseSizeWidgetState();
}

class _CommodityChooseSizeWidgetState extends State<CommodityChooseSizeWidget> {
  var actualNumber;
  var checkValue;
  TextEditingController actualNumberController;
  TextEditingController skuCode;

  @override
  void initState() {
    super.initState();
    actualNumber = widget.initNumber ?? 0;

    print('初始化: stockCode=${widget.stockCode} 的第${widget.index} 个的初始数量是 $actualNumber');
    checkValue = widget.checkValue ?? true;
    actualNumberController = TextEditingController(text: actualNumber.toString());

    skuCode = TextEditingController(text: widget.skuCode);
  }

  @override
  void dispose() {
    print('移除 stockCode=${widget.stockCode} 的第${widget.index} ${actualNumberController.text}');
    actualNumberController.text = "0";
    actualNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 2.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
              Container(
                width:80.w,
                child: Wrap(children: [
                  WMSText(
                    content: '${widget.size ?? '无尺码'}${widget.specification != null ? "/" + widget.specification : ""}',
                    size: 12,
                    bold: true,
                    color: actualNumber > 0 ? Colors.black : Colors.grey,
                  ),
                ],),
              ),
              SizedBox(width: 8.w),
              WMSText(
                content: widget.hintText,
                size: 12,
                color: Colors.grey,
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                if (widget.skuCodeShow)
                  Expanded(
                    child: Container(
                      // child: TextField(),
                      child: WMSTextField(
                          keyboardType: TextInputType.text,
                          controller: skuCode,
                          hintText: widget.skuCodeHintText,
                          marginTop: 0.h,
                          onChangedCallback: (value) {
                            setState(() {});
                            widget.onSkuCodeCallback(skuCode.text);
                          },
                          onSubmittedCallback: (value) {
                            setState(() {});
                            widget.onSkuCodeCallback(skuCode.text);
                          },
                          endWidget: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Get.to(() => ENScanStandardPage(
                                    title: "扫sku码",
                                    // leading: backLeadingIcon,
                                  )).then((value) {
                                setState(() {
                                  skuCode.text = value;
                                });
                                widget.onSkuCodeCallback(skuCode.text);
                              });
                            },
                            child: SvgPicture.asset(
                              'assets/svgs/scan.svg',
                              width: 15.w,
                            ),
                          )),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          Container(
            child: Row(
              children: [
                Visibility(
                  visible: widget.editButtonShow,
                  child: GestureDetector(
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
                ),
                Container(
                  width: 60.w,
                  height: 30.h,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  // color: Colors.red,
                  child: Center(
                    child: widget.editButtonShow
                        ? TextField(
                            maxLines: 1,
                            onTap: () {
                              if (int.parse(actualNumberController.text) == 0) {
                                actualNumberController.text = "";
                              }
                            },
                            onChanged: (value) {
                              try {
                                actualNumber = int.parse(actualNumberController.text);
                                if (actualNumber < 0) {
                                  EasyLoadingUtil.showMessage(message: "数量不可小于0.");
                                } else if (widget.compareStatus && actualNumber > widget.compareNumber) {
                                  EasyLoadingUtil.showMessage(message: '上架数量有误,请检查');
                                  return false;
                                } else {
                                  widget.onChangeCallback(actualNumber);
                                }
                              } catch (_) {
                                widget.onChangeCallback(0);
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6.w),
                              hintText: "0",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.r),
                                borderSide: BorderSide(color: Colors.grey[200], width: 0.1),
                              ),
                            ),
                            controller: actualNumberController,
                            keyboardType: TextInputType.number,
                          )
                        : Container(
                            alignment: Alignment.center,
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[100],
                            ),
                            // hintStyle: TextStyle(fontSize: 13.sp),

                            child: WMSText(
                              content: actualNumber.toString(),
                              size: 12,
                            ),
                          ),
                  ),
                ),
                Visibility(
                  visible: widget.editButtonShow,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.compareStatus) {
                          if (actualNumber < widget.compareNumber) {
                            actualNumber = actualNumber + 1;
                            actualNumberController.text = actualNumber.toString();
                          } else {
                            actualNumber = widget.compareNumber;
                            EasyLoadingUtil.showMessage(message: '不得超出最大数量');

                            actualNumberController.text = actualNumber.toString();
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
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CommoditySizeList extends StatelessWidget {
  final skuSizeList;
  final stockCode;
  final skuCodeShow;
  final compareStatus;
  final compareNumber;
  final Function onCommodityNumChange;
  final Function onSkuCodeChange;
  final String skuCodeHintText;

  const CommoditySizeList(
      {Key key,
      this.skuSizeList,
      this.stockCode,
      this.skuCodeShow = false,
      this.compareStatus = false,
      this.compareNumber,
      this.skuCodeHintText = '请输入sku码',
      this.onCommodityNumChange,
      this.onSkuCodeChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('$stockCode 的商品列表重建');
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),
        children: [
          for (var index = 0; index < skuSizeList.length; index++) ...[
            CommodityChooseSizeWidget(
              key: Key('$stockCode-$index'),
              stockCode: stockCode,
              index: index,
              initNumber: skuSizeList[index]['commodityNumber'] ?? 0,
              size: skuSizeList[index]['size'],
              specification: skuSizeList[index]['specification'],
              skuCode: skuSizeList[index]['skuCode'],
              checkValue: true,
              checkButtonshow: false,
              skuCodeShow: skuCodeShow,
              compareStatus: compareStatus,
              compareNumber: compareNumber,
              skuCodeHintText: skuCodeHintText,
              onChangeCallback: (value) {
                onCommodityNumChange(index, value);
              },
              onSkuCodeCallback: (value) {
                onSkuCodeChange(index, value);
              },
            )
          ]
        ],
      ),
    );
  }
}
