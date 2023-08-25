import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'entrenpot/en_sku_table_cell.dart';
import 'package:wms/models/entrepot/en_sku_detail_model.dart';
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';

Widget buildSkuWdidget(model) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: .5,
          color: Colors.grey[200],
        ),
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    color: Colors.black,
                    size: 17,
                  ),
                  Expanded(
                    child: WMSInfoRow(
                      title: 'spu：',
                      content: '${model?.spuId ?? 0}',
                      leftInset: 8,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              color: Colors.black,
              size: 17,
            ),
            Expanded(
                child: WMSInfoRow(
              title: 'sku：',
              content: '${model?.skuId ?? 0}',
              leftInset: 8,
            )),
          ],
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              color: Colors.black,
              size: 17,
            ),
            Expanded(
                child: WMSInfoRow(
              title: 'size：',
              content: '${model?.size ?? '无尺码'}',
              leftInset: 8,
            )),
          ],
        ),
        SizedBox(
          height: 4.h,
        ),
      ],
    ),
  );
}

// 商品状态
Widget buildSpztWidget(pageController) {
  return Obx(() {
    return Row(
      children: [
        WMSText(
          content: '商品状态',
        ),
        Radio(
          value: 0,
          groupValue: pageController.itemsState.value,
          activeColor: Colors.blue,
          onChanged: (value) {
            pageController.changeItemsState(value);
          },
        ),
        WMSText(
          content: '正常',
        ),
        SizedBox(
          width: 8.w,
        ),
        Radio(
          value: 1,
          groupValue: pageController.itemsState.value,
          activeColor: Colors.blue,
          onChanged: (value) {
            pageController.changeItemsState(value);
          },
        ),
        WMSText(
          content: '瑕疵',
        ),
      ],
    );
  });
}

// SN码
Widget buildSNcodeWdidget(pageController) {
  // return WMSCodeInputWidget(
  //   controller: pageController.sncodeC,
  //   callback: () => pageController.onTapScanBarcode(),
  // );
  return WMSTextField(
      title: 'SN码',
      hintText: '必填',
      keyboardType: TextInputType.number,
      controller: pageController.sncodeC,
      endWidget: GestureDetector(
        onTap: () {
          print(pageController.sncodeC.text);
        },
        child: SvgPicture.asset(
          'assets/svgs/scan.svg',
          width: 17.w,
        ),
      ));
}

// SKU码
Widget buildSKUCodeWdidget(pageController) {
  // return WMSCodeInputWidget(
  //   controller: pageController.skucodeC,
  //   callback: () => pageController.onTapScanSKUcode(),
  // );
  return WMSTextField(
      title: 'SKU码',
      hintText: '必填',
      controller: pageController.skucodeC,
      keyboardType: TextInputType.number,
      endWidget: GestureDetector(
        onTap: () {},
        child: SvgPicture.asset(
          'assets/svgs/scan.svg',
          width: 17.w,
        ),
      ));
}

// 商品照片
Widget buildItemsImage(pageController) {
  return Obx(() {
    return WMSUploadImageWidget(
      canDelete: true,
      maxLength: 6,
      images: pageController.itemsImages,
      addCallBack: () {
        print('add =======');
        pageController.onTapAddItemsImage();
      },
      delCallBack: (index) {
        pageController.onTapDelItemsImage(index);
      },
    );
  });
}

// 货号照片
Widget buildArticleNumberImage(pageController) {
  return Obx(() => WMSUploadImageWidget(
        maxLength: 6,
        images: pageController.articleNumberImage.value,
        addCallBack: () {
          print('add =======');
          pageController.onTapAddArticleNumberImage();
        },
        delCallBack: (index) {
          pageController.onTapDelArticleNumberImage(index);
        },
      ));
}

// 条形码
Widget buildBarcodeWdidget(pageController) {
  return WMSCodeInputWidget(
    controller: pageController.barcodeC,
    callback: () => pageController.onTapScanBarcode(),
  );
}

// 商品尺寸
Widget buildSizeWdidget(pageController) {
  return Container(
      padding: EdgeInsets.only(bottom: 16.w),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text("尺码"),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pageController.setItemSize("s");
                    },
                    child: Text("S"),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: pageController.itemSize == "s"
                          ? MaterialStateProperty.all(Colors.black)
                          : MaterialStateProperty.all(Colors.grey),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      pageController.setItemSize("m");
                    },
                    child: Text("M"),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: pageController.itemSize == "m"
                          ? MaterialStateProperty.all(Colors.black)
                          : MaterialStateProperty.all(Colors.grey),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      pageController.setItemSize("l");
                    },
                    child: Text("L"),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: pageController.itemSize == "l"
                          ? MaterialStateProperty.all(Colors.black)
                          : MaterialStateProperty.all(Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 40.w,
          ),
        ],
      ));
}

typedef void OnChangeCallback(skuIndex, value);

class SkuInfoBlock extends StatefulWidget {
  final bool editable; //编辑
  final dynamic spu;
  final List titles;
  final num delKey;
  final Function onDeleteFunc;
  final Function onEditNumFunc;
  final int skuIndex;
  final bool skuCodeShow;
  final bool removeButton;
  final OnChangeCallback onChangeCallback;

  SkuInfoBlock(
      {Key key,
      this.skuIndex,
      this.editable,
      this.spu,
      this.skuCodeShow,
      this.titles,
      this.delKey,
      this.onDeleteFunc,
      this.onEditNumFunc,
      this.removeButton,
      this.onChangeCallback})
      : super(key: key);

  @override
  State<SkuInfoBlock> createState() => _SkuInfoBlockState();
}

class _SkuInfoBlockState extends State<SkuInfoBlock> {
  bool showmore = false;
  TextEditingController skuNumber;
  TextEditingController setNumber;
  var commodityShowNumber;

  @override
  void initState() {
    super.initState();
    skuNumber = TextEditingController();
    setNumber = TextEditingController();
    // requestOrderData();
    commodityShowNumber = widget.spu['commodityNumber'] != null
        ? widget.spu['commodityNumber'].toString()
        : widget.spu['actualNumber'].toString();
    skuNumber.text = commodityShowNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.h),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey[100],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.r),
              ),
            ),
            height: 60.h,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.h,
                      width: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: Colors.grey[100],
                      ),
                      child: WMSText(
                        content:
                            "${widget.spu['size'] ?? '无尺码'}${widget.spu['specification'] != null ? "/" + widget.spu['specification'] : ''}",
                        size: 11,
                        bold: true,
                      ),
                    ),
                  ),
                ),
                // 这里可以禁止编辑 如果 editable 为false.

                Visibility(
                  visible: widget.skuCodeShow,
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.h,
                      child: WMSText(
                        content: widget.spu['skuCode'] ?? '-',
                        size: 12,
                        bold: true,
                      ),
                    ),
                  ),
                ),

                // 这里可以禁止编辑 如果 editable 为false.
                Expanded(
                  child: GestureDetector(
                    child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40.h,
                                  width: 80.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: Colors.grey[100],
                                  ),
                                  child: WMSText(
                                    content: commodityShowNumber,
                                    size: 11,
                                    bold: true,
                                  ),
                                ),
                              ),
                            ),
                            //保持无
                            Visibility(
                              visible: widget.spu['sysPrepareSkuList'] != null || widget.spu['skuDataList'] != null,
                              //  ??
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showmore = !showmore;
                                  });
                                },
                                child: Icon(
                                  showmore == true ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                Visibility(
                  visible: widget.removeButton,
                  child: Expanded(
                    child:
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        Container(
                      padding: EdgeInsets.only(
                        left: 20.w,
                        right: 20.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) => wvDialog(
                                  widget: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            '更改数量',
                                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          controller: setNumber,
                                          autofocus: true,
                                          // keyboardType:
                                          //     TextInputType.numberWithOptions(
                                          //         decimal: true),
                                          decoration: InputDecoration(
                                            hintText: '请输入修改后的数量',
                                            helperText: '数量应当为整数数值',
                                            helperStyle: TextStyle(color: Colors.blue, fontSize: 14),
                                            helperMaxLines: 1,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            buildButtonWidget(
                                              width: 120.w,
                                              height: 34.h,
                                              buttonContent: '取消',
                                              handelClick: () {
                                                Navigator.of(context).pop(false);
                                              },
                                              radius: 2.0,
                                            ),
                                            buildButtonWidget(
                                              width: 120.w,
                                              height: 34.h,
                                              buttonContent: '确认数量',
                                              bgColor: AppConfig.themeColor,
                                              contentColor: Colors.white,
                                              handelClick: () async {
                                                // widget.onDeleteFunc(widget.skuIndex);
                                                Navigator.of(context).pop(true);
                                                setState(() {
                                                  setNumber.text = setNumber.text;
                                                  commodityShowNumber = setNumber.text;
                                                });
                                                widget.onEditNumFunc(widget.skuIndex, setNumber.text);
                                                widget.onChangeCallback(widget.skuIndex, setNumber.text);
                                              },
                                              radius: 2.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onDeleteFunc(widget.skuIndex);
                            },
                            child: Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 如果点击了小三角,则展示sku的列表详情
          Visibility(
            visible: showmore,
            child: ENSkuTableCell(
              eNSkuDetailModel:
                  ENSkuDetailModel.fromJson({'skus': widget.spu['sysPrepareSkuList'] ?? widget.spu['skuDataList']}),
            ),
          ),
        ],
      ),
      // )
    );
  }
}

// SKU信息
Widget buildSKuInfoWdidget(
    {List list,
    bool editable: false,
    bool skuCodeShow: true,
    bool removeButton: false,
    Function onDeleteFunc,
    Function onEditNumFunc,
    OnChangeCallback onChangeCallback}) {
  List<Widget> listWidget = [];
  for (var index = 0; index < list.length; index++) {
    listWidget.add(
      SkuInfoBlock(
        skuIndex: index,
        spu: list[index],
        editable: editable,
        delKey: index,
        onDeleteFunc: onDeleteFunc,
        onEditNumFunc: onEditNumFunc,
        onChangeCallback: onChangeCallback,
        removeButton: removeButton,
        skuCodeShow: skuCodeShow,
      ),
    );
  }

  return Column(
    children: listWidget,
  );
}
