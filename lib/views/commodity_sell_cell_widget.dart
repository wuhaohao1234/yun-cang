//选择集市价格或小程序价格
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/baseWidgets/wms_button.dart';
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';
import 'package:wms/customer/common.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/configs/app_style_config.dart';

//设置数据提交check 选中状态，price价格，count 数量
typedef void OnChangeCallback(check, price, count);

class CommodityChoosePlatformWidget extends StatefulWidget {
  final Map storeInfo; //库存id
  final String choosePlatform; //小程序或者集市
  final bool normalMode; //正常商品
  final OnChangeCallback onChangeCallback;

  const CommodityChoosePlatformWidget({
    Key key,
    this.storeInfo,
    this.choosePlatform,
    this.onChangeCallback,
    this.normalMode = true,
  }) : super(key: key);

  @override
  _CommodityChoosePlatformWidgetState createState() => _CommodityChoosePlatformWidgetState();
}

class _CommodityChoosePlatformWidgetState extends State<CommodityChoosePlatformWidget> {
  int actualNumber = 0;
  var checkValue;
  var setPrice = TextEditingController();
  var actualNumberController = TextEditingController();
  int count = 0;
  double price;
  int maxCount = 1;

  @override
  void initState() {
    super.initState();

    actualNumberController = TextEditingController();

    print("storeInfo");
  }

  submitPostInfo() {
    //检查库存
    if (actualNumber > maxCount) {
      checkValue = false;
      EasyLoadingUtil.showMessage(message: '库存不足，无法提交');
      return false;
    }
    //检查价格
    var defaultPrice =
        widget.choosePlatform == 'bazaar' ? widget.storeInfo['bazaarPrice'] : widget.storeInfo['appPrice'];

    if (price != null) {
      widget.onChangeCallback(checkValue, price, actualNumber);
    } else {
      if (defaultPrice != null) {
        price = defaultPrice;
        widget.onChangeCallback(checkValue, price, actualNumber);
      } else {
        EasyLoadingUtil.showMessage(message: '请更新价格');
        checkValue = false;
      }
    }
  }

  updateInfo() {
    print(widget.storeInfo);
    //检查商品在不同平台的价格
    if (widget.choosePlatform == 'app') {
      if (widget.storeInfo['appPrice'] != null) {
        price = widget.storeInfo['appPrice'].toDouble();
      } else {
        price = null;
        // EasyLoadingUtil.showMessage(message: '小程序价格为null，请修改');
      }
    }
    if (widget.choosePlatform == 'bazaar') {
      if (widget.storeInfo['bazaarPrice'] != null) {
        price = widget.storeInfo['bazaarPrice'].toDouble();
      } else {
        price = null;
        // EasyLoadingUtil.showMessage(message: '集市价格为null，请修改');
      }
    }
    //设置正常商品与瑕疵商品的最大库存量;
    if (widget.normalMode) {
      maxCount = widget.choosePlatform == 'bazaar'
          ? (widget.storeInfo['bazaarMaxSaleCount'] ?? 0)
          : (widget.storeInfo['appMaxSaleCount'] ?? 0);
    } else {
      maxCount = 1;
    }
    print("maxcount$maxCount");
  }

  updateStateInfo(info) {
    //检查商品在不同平台的价格
    var defaultPrice =
        widget.choosePlatform == 'bazaar' ? widget.storeInfo['bazaarPrice'] : widget.storeInfo['appPrice'];
    // if (widget.choosePlatform == 'app') {
    //   if (info['appPrice'] != null) {
    //     price = info['appPrice'].toDouble();
    //   } else {
    //     price = null;
    //     // EasyLoadingUtil.showMessage(message: '小程序价格为null，请修改');
    //   }
    // }
    // if (widget.normalMode && widget.choosePlatform == 'bazaar') {
    //   if (info['bazaarPrice'] != null) {
    //     price = info['bazaarPrice'].toDouble();
    //   } else {
    //     price = null;
    //     // EasyLoadingUtil.showMessage(message: '集市价格为null，请修改');
    //   }
    // }
    //设置正常商品与瑕疵商品的最大库存量;
    if (widget.normalMode) {
      maxCount = widget.choosePlatform == 'bazaar'
          ? (widget.storeInfo['bazaarMaxSaleCount'] ?? 0)
          : (widget.storeInfo['appMaxSaleCount'] ?? 0);
    } else {
      maxCount = 1;
    }
    print("maxcount$maxCount");

    price = price;
  }

  updateStateprice(price) {
    price = price;
    print("state new price");
  }

  @override
  Widget build(BuildContext context) {
    final CSKuCunSaleInheritedWidget state = CSKuCunSaleInheritedWidget.of(context, true);
    updateStateInfo(state.spuInfo);
    var defaultPrice =
        widget.choosePlatform == 'bazaar' ? widget.storeInfo['bazaarPrice'] : widget.storeInfo['appPrice'];
    return Container(
      height: 80.h,
      margin: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey[300])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
            value: checkValue ?? false,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: Colors.black,
            checkColor: Colors.white,
            tristate: true,
            onChanged: (_) {
              setState(
                () {
                  //获取尺码数据
                  checkValue = !(checkValue ?? false);
                  print(actualNumber);
                  submitPostInfo();
                },
              );
            },
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        WMSText(
                          content: widget.choosePlatform == 'app' ? '小程序价格' : '集市价格',
                          // bold: true,
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) => StatefulBuilder(builder: (context,state){
                                  return wvDialog(
                                    widget: GestureDetector(
                                      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                '更新价格',
                                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(height: 20.0),
                                            TextField(
                                              controller: setPrice,
                                              autofocus: true,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              decoration: InputDecoration(
                                                hintText: '请输入价格',
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black),
                                                ),
                                                contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                                              ),
                                              onChanged: (e){
                                                state((){});
                                              },
                                            ),

                                            Visibility(
                                                visible: setPrice.text.trim().toString().length == 0
                                                    ? false
                                                    : double.parse(setPrice.text.trim().toString()) >= 5000
                                                    ? true
                                                    : false,
                                                child: WMSText(content: "商品价格操过5000时需要承担税和邮费",color: Colors.red[400],size:12 ,)),
                                            SizedBox(height: 20.0),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                WMSButton(
                                                  title: '取消',
                                                  width: 120.w,
                                                  bgColor: Colors.transparent,
                                                  textColor: Colors.black,
                                                  showBorder: true,
                                                  callback: () {
                                                    Navigator.of(context).pop(false);
                                                  },
                                                ),
                                                WMSButton(
                                                  title: '确认价格',
                                                  width: 120.w,
                                                  bgColor: AppConfig.themeColor,
                                                  textColor: Colors.white,
                                                  showBorder: true,
                                                  callback: () async {
                                                    setState(() {
                                                      price = double.parse(setPrice.text);
                                                      print(price);

                                                      submitPostInfo();
                                                    });
                                                    FocusScope.of(context).requestFocus(FocusNode());

                                                    Navigator.of(context).pop(true);
                                                    updateStateprice(price);
                                                    // EasyLoadingUtil.showMessage(
                                                    //     message: '已更新价格');
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                            child: Row(
                              children: [
                                defaultPrice == null
                                    ? WMSText(
                                        content: ' (请更新价格)',
                                        color: Colors.red,
                                        size: 12,
                                      )
                                    : WMSText(
                                        content: '$defaultPrice（点击修改）',
                                        color: AppStyleConfig.btnColor,
                                        size: 12,
                                      ),
                                SizedBox(width: 20.w),
                                WMSText(
                                  content: defaultPrice != price && price != null ? '最新设定价格 $price' : '',
                                  bold: true,
                                  size: 12,
                                ),
                              ],
                            )),
                      ],
                    )),
                Visibility(
                    visible: price == null
                        ? false
                        : price >= 5000
                            ? true
                            : false,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: WMSText(content: "商品价格操过5000时需要承担税和邮费",color: Colors.red[400],size:12 ,),
                    )),
                Divider(),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        WMSText(content: '上架数量'),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () {
                            // if (!checkValue) {
                            //   EasyLoadingUtil.showMessage(message: '请check');
                            // }
                            setState(() {
                              if (price == null) {
                                EasyLoadingUtil.showMessage(message: '请更新价格');
                                checkValue = false;
                                return false;
                              }
                              if (widget.normalMode) {
                                if (actualNumber == 0) {
                                  actualNumber = 0;
                                  actualNumberController.text = actualNumber.toString();
                                  checkValue = false;
                                } else {
                                  actualNumber = actualNumber - 1;
                                  actualNumberController.text = actualNumber.toString();
                                  print("-1");
                                }
                              } else {
                                actualNumber = 0;
                                actualNumberController.text = actualNumber.toString();
                                checkValue = false;
                                // EasyLoadingUtil.showMessage(
                                //     message: '瑕疵品只可单件出售');
                              }
                              submitPostInfo();
                            });
                          },
                          child: Container(
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            width: 30.w,
                            height: 24.w,
                            child: WMSText(
                              content: '-',
                            ),
                          ),
                        ),
                        Container(
                          width: 60.w,
                          height: 30.h,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Center(
                            child: TextField(
                              maxLines: 1,
                              onChanged: (value) {
                                try {
                                  var actualNumberC = int.parse(actualNumberController.text);
                                  if (actualNumberC < 0) {
                                    EasyLoadingUtil.showMessage(message: "数量不可小于0.");
                                  } else if (actualNumberC > maxCount) {
                                    actualNumberC = maxCount;

                                    EasyLoadingUtil.showMessage(message: '出售数量不可超出库存量');
                                    setState(() {
                                      actualNumberController.text = maxCount.toString();
                                      actualNumber = maxCount;
                                    });
                                    actualNumberController.text = maxCount.toString();
                                    // return false;
                                  } else {
                                    setState(() {
                                      actualNumber = actualNumberC;
                                    });
                                  }
                                  if (actualNumber > 0) {
                                    checkValue = true;
                                  } else {
                                    checkValue = false;
                                  }
                                  submitPostInfo();
                                } catch (_) {
                                  // widget.onChangeCallback(0);
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6.w),
                                hintText: '0',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: Colors.black, width: 0.1),
                                ),
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              controller: actualNumberController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          // WMSText(
                          //   content: actualNumber.toString(),
                          //   bold: true,
                          //   color: Colors.red,
                          // ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              //判断数量

                              if (actualNumber > maxCount) {
                                actualNumber = maxCount;
                                actualNumberController.text = actualNumber.toString();
                                EasyLoadingUtil.showMessage(message: '出售数量不可超出库存量');
                              } else {
                                actualNumber = actualNumber + 1;
                                actualNumberController.text = actualNumber.toString();
                                checkValue = true;
                                if (!widget.normalMode) {
                                  actualNumber = 1;
                                  actualNumberController.text = actualNumber.toString();
                                }
                              }

                              // if (checkValue == false) {
                              //   EasyLoadingUtil.showMessage(message: '请check');
                              // }

                              submitPostInfo();
                            });
                          },
                          child: Container(
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            width: 30.w,
                            height: 24.w,
                            child: WMSText(
                              content: '+',
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        WMSText(
                          content: '库存：${maxCount.toString()}  ',
                          color: Colors.grey,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    count = 0;
    checkValue = false;
    super.dispose();
  }
}

class CSKuCunSaleInheritedWidget extends InheritedWidget {
  const CSKuCunSaleInheritedWidget({
    Key key,
    @required Widget child,
    @required this.spuInfo,
    this.price,
  }) : super(key: key, child: child);

  final spuInfo;
  final price;

  @override
  bool updateShouldNotify(CSKuCunSaleInheritedWidget oldWidget) {
    return true;
  }

  static CSKuCunSaleInheritedWidget of([BuildContext context, bool rebuild = true]) {
    return (rebuild
        ? context.dependOnInheritedWidgetOfExactType<CSKuCunSaleInheritedWidget>()
        : context.findAncestorWidgetOfExactType<CSKuCunSaleInheritedWidget>());
    // return (context.dependOnInheritedWidgetOfExactType<_MyInherited>()).data;
  }
}
