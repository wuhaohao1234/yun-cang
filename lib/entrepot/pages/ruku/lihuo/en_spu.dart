import 'package:wms/customer/common.dart';
import 'package:wms/entrepot/controllers/chuku/en_qc_controller.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';
import 'package:wms/entrepot/pages/ruku/lihuo/en_qc.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

Widget buildSpuList(
    {var model,
    List spuList,
    editable: true,
    Function afterEdit,
    bool actualNumberEditable,
    var inspectionRequirement}) {
  final rowHeight = 40.h;

  return Column(
    children: [
      // 首行: 表格的table head.
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            SizedBox(
              width: 60.w,
              child: Container(
                alignment: Alignment.center,
                child: WMSText(
                  content: '尺码/规格',
                  size: 12,
                  bold: true,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: WMSText(
                  content: '条形码(sku)',
                  size: 12,
                  bold: true,
                ),
              ),
            ),
            SizedBox(
              width: 60.w,
              child: Container(
                alignment: Alignment.center,
                child: WMSText(
                  content: '预约数量',
                  size: 12,
                  bold: true,
                ),
              ),
            ),
            SizedBox(
              width: 60.w,
              child: Container(
                alignment: Alignment.center,
                child: WMSText(
                  content: '实收数量',
                  size: 12,
                  bold: true,
                ),
              ),
            ),
            Visibility(
                visible: editable,
                child: SizedBox(
                  width: 40.w,
                  child: Container(
                    alignment: Alignment.center,
                    child: WMSText(
                      content: inspectionRequirement == "1" ? '' : '质检',
                      size: 12,
                      bold: true,
                    ),
                  ),
                )),
          ],
        ),
      ),
      // table body
      //此处存在bug
      Container(
        // color: Colors.red,
        // height: rowHeight * (spuList.length + 1),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: spuList.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return SpuBlock(
                model: model,
                spu: spuList[index],
                rowHeight: rowHeight,
                afterEdit: afterEdit,
                index: index,
                editable: editable,
                actualNumberEditable: actualNumberEditable,
                inspectionRequirement: inspectionRequirement);
          },
        ),
      )
    ],
  );
}

class SpuBlock extends StatefulWidget {
  final dynamic spu;
  final Function afterEdit; // 修改数据以后的回调函数
  final bool actualNumberEditable; //实收数量是否可以修改
  final rowHeight;
  final int index;
  final bool editable;
  final model;
  final inspectionRequirement;

  SpuBlock(
      {Key key,
      this.spu,
      this.rowHeight,
      this.afterEdit,
      this.index,
      this.actualNumberEditable,
      this.editable = true,
      this.model,
      this.inspectionRequirement})
      : super(key: key);

  @override
  State<SpuBlock> createState() => _SpuBlockState();
}

class _SpuBlockState extends State<SpuBlock> {
  final hs = HttpServices();
  var rowHeight = 40.h;
  final radius = 5.r;
  bool showmore = true;
  String oldSkuCode;
  TextEditingController _actualNumberController;
  TextEditingController _commodityNumberController;
  TextEditingController _skuCodeController;
  var _actualNumberFocusNode = FocusNode();
  var _skuCodeFocusNode = FocusNode();

  @override
  void didUpdateWidget(covariant SpuBlock oldWidget) {
    _actualNumberController.text = widget.spu['actualNumber']?.toString();
    _commodityNumberController.text = widget.spu['commodityNumber']?.toString();
    _skuCodeController.text = widget.spu['skuCode']?.toString();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    rowHeight = widget.rowHeight ?? 40.h;
    super.initState();
    oldSkuCode = widget.spu['skuCode'] ?? "".toString();
    _actualNumberController =
        TextEditingController(text: widget.spu['actualNumber'] != null ? widget.spu['actualNumber'].toString() : '0');
    _commodityNumberController = TextEditingController(
        text: widget.spu['commodityNumber'] != null ? widget.spu['commodityNumber']?.toString() : '0');

    _skuCodeController = TextEditingController(text: widget.spu['skuCode'] ?? "".toString());
    _actualNumberFocusNode.addListener(() {
      var oldVal = widget.spu['actualNumber'];
      if (oldVal == 'null') {
        oldVal = "0";
      }
      if (!_actualNumberFocusNode.hasFocus &&
          widget.actualNumberEditable &&
          widget.editable &&
          _actualNumberController.text.toString() != "" &&
          _actualNumberController.text.toString() != oldVal.toString()) {
        updateSpu();
      }
    });

    _skuCodeFocusNode.addListener(() {
      var oldVal = widget.spu['skuCode'];
      if (oldVal == 'null') {
        oldVal = "";
      }
      if (!_skuCodeFocusNode.hasFocus &&
          _skuCodeController.text.toString() != "" &&
          _skuCodeController.text.toString() != oldVal) {
        updateSpu();
      }
    });
  }

  @override
  void dispose() {
    _actualNumberController.dispose();
    _commodityNumberController.dispose();
    _skuCodeController.dispose();
    super.dispose();
  }

  void updateSpu() async {
    // 更新SPU数据
    print("Update spu data");
    final params = {
      'spuId': widget.spu['spuId'],
      'skuId': widget.spu['skuId'],
      'sysPrepareOrderId': widget.spu['sysPrepareOrderId'],
      'actualNumber': _actualNumberController.text,
      'skuCode': oldSkuCode,
      'newSkuCode': _skuCodeController.text,
    };

    print("$params");
    EasyLoadingUtil.showLoading(statusText: "更新数据");
    final result = await hs.updateSpuInfo(params: params);
    EasyLoadingUtil.hidden();
    if (result == true) {
      print("更新信息成功");
      EasyLoadingUtil.showMessage(message: "信息更新成功");
      widget.afterEdit?.call();
    } else {
      print("更新信息失败");
      EasyLoadingUtil.showMessage(message: "更新失败: ${result.message}");
      if(result.code==412){
        _skuCodeController.text = '';
      }
    }
  }

  Future deleteSku(int skuIndex) async {
    //滑动删除sku
    EasyLoadingUtil.showLoading(statusText: "删除SKU中...");
    final params = {
      'spuId': widget.spu['spuId'],
      'skuId': widget.spu['skuId'],
      'sysPrepareOrderId': widget.spu['sysPrepareOrderId'],
      'actualNumber': _actualNumberController.text,
      'size': widget.spu['size'],
      'skuCode': oldSkuCode,
      'newSkuCode': _skuCodeController.text,
    };
    final result = await hs.deleteSkuInfo(params: params);
    EasyLoadingUtil.hidden();
    if (result != true) {
      EasyLoadingUtil.showMessage(message: "删除SKU失败: ${result.message}");
    }
    return result;
  }

  Future deleteSn(int snIndex) async {
    //滑动删除SN
    final idx = widget.spu["sysPrepareSkuList"][snIndex]["id"];
    EasyLoadingUtil.showLoading(statusText: "删除SKU(id=$idx)...");
    final result = await hs.deleteSN(id: idx);
    EasyLoadingUtil.hidden();
    if (result == true) {
      EasyLoadingUtil.showMessage(message: "删除成功");
      return true;
    } else {
      EasyLoadingUtil.showMessage(message: "删除失败: ${result.message}");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget spuBlockRow = Container(
      margin: EdgeInsets.symmetric(vertical: radius),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: rowHeight,
            child: Row(
              children: [
                SizedBox(
                    width: 60.w,
                    child: Container(
                      child: Text(
                        "${widget.spu['size']} ${widget.spu['specification'] != null ? "/" + widget.spu['specification'] : ''}",
                        textAlign: TextAlign.center,
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(radius),
                    child: TextField(
                      readOnly: !widget.editable,
                      controller: _skuCodeController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: radius),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radius),
                            borderSide: BorderSide(color: Colors.black, width: 0.1)),
                        hintText: 'SKU码（必填）',
                        hintStyle: TextStyle(fontSize: 8.sp),
                        suffixIcon: widget.editable
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        // context: new BuildContext( context),
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
                                                    '请输入sku码',
                                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(height: 20.0),
                                                TextField(
                                                  keyboardType: TextInputType.text,
                                                  controller: _skuCodeController,
                                                  autofocus: true,
                                                  decoration: InputDecoration(
                                                    hintText: '请输入修改后的sku码',
                                                    // suffixIcon: Icon(Icons.person),
                                                    suffixIcon: Container(
                                                      padding: EdgeInsets.all(12),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                                  () => ENScanStandardPage(
                                                                        title: "扫sku码",
                                                                        // leading: backLeadingIcon,
                                                                      ),
                                                                  preventDuplicates: false)
                                                              .then((value) {
                                                            if (value != 'null') {
                                                              _skuCodeController.text = value;
                                                            }
                                                          });
                                                        },
                                                        child: SvgPicture.asset('assets/svgs/scan.svg',
                                                            width: 18.w, color: Colors.black),
                                                      ),
                                                    ),

                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                                                  ),
                                                ),
                                                SizedBox(height: 20.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    WMSButton(
                                                      title: '取消',
                                                      width: 120.w,
                                                      bgColor: Colors.white,
                                                      textColor: Colors.black,
                                                      showBorder: true,
                                                      callback: () {
                                                        Navigator.of(context).pop(false);
                                                      },
                                                    ),
                                                    WMSButton(
                                                      title: '确认',
                                                      width: 120.w,
                                                      bgColor: AppConfig.themeColor,
                                                      textColor: Colors.white,
                                                      showBorder: true,
                                                      callback: () async {
                                                        Navigator.of(context).pop(true);
                                                        updateSpu();
                                                        print("修改spu sku码");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: SvgPicture.asset('assets/svgs/scan.svg',
                                        width: 8.w, color: widget.editable ? Colors.black : Colors.black54)),
                              )
                            : null,
                      ),
                      focusNode: _skuCodeFocusNode,
                      onSubmitted: (String newSkuCode) {
                        updateSpu();
                        print("修改spu sku码");
                      },
                    ),
                  ),
                ),
                SizedBox(
                    width: 60.w,
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.all(radius),
                        child: TextField(
                          readOnly: true,
                          controller: _commodityNumberController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: radius),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(radius), borderSide: BorderSide.none),
                            hintStyle: TextStyle(fontSize: 8.sp,color: Colors.grey[400]),

                          ),
                          style: TextStyle(color: Colors.grey[400]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
                SizedBox(
                    width: 60.w,
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.all(radius),
                        child: TextField(
                          readOnly: !widget.actualNumberEditable || !widget.editable,
                          // controller: _actualNumberController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: radius),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(radius),
                                  borderSide: BorderSide(color: Colors.black, width: 0.1)),
                              hintStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
                              hintText: _actualNumberController.text),
                          textAlign: TextAlign.center,
                          onSubmitted: (String newActualNumber) {
                            updateSpu();
                          },
                          autofocus: false,
                          focusNode: _actualNumberFocusNode,
                          onEditingComplete: () {
                            updateSpu();
                          },
                          onChanged: (e) {
                            _actualNumberController.text = e;
                          },
                        ),
                      ),
                    )),
                Visibility(
                    visible: widget.editable,
                    child: SizedBox(
                        width: 40.w,
                        child: Container(
                          child: widget.inspectionRequirement == "1"
                              ? Icon(
                                  Icons.check,
                                  color: _commodityNumberController.text == _actualNumberController.text
                                      ? AppConfig.themeColor
                                      : Colors.grey,
                                )
                              : IconButton(
                                  onPressed: () {
                                    Get.put(ENQcController());
                                    Get.find<ENQcController>().initController(widget.model, widget.index);
                                    Get.to(new ENQc(
                                      model: widget.model,
                                      callback: widget.afterEdit,
                                    ));
                                  },
                                  icon: Icon(Icons.photo_camera),
                                ),
                        ))),
              ],
            ),
          ),
          if (widget.spu['sysPrepareSkuList'] != null && showmore && widget.spu['sysPrepareSkuList'].length > 0)
            Column(
              children: [
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: Container(
                          alignment: Alignment.center,
                          child: WMSText(
                            content: 'SN码',
                            size: 12,
                            bold: true,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: WMSText(
                            content: '照片',
                            size: 12,
                            bold: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80.w,
                        child: Container(
                          alignment: Alignment.center,
                          child: WMSText(
                            content: '状态',
                            size: 12,
                            bold: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: rowHeight * widget.spu['sysPrepareSkuList'].length,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.spu["sysPrepareSkuList"].length,
                      itemBuilder: (BuildContext context, int index) {
                        Widget spuInfoBlock = Container(
                          // color: Colors.greenAccent,
                          height: rowHeight,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80.w,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: WMSText(
                                    content: widget.spu["sysPrepareSkuList"][index]["barCode"] ?? '',
                                    size: 12,
                                    // bold: true,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(radius),
                                  alignment: Alignment.center,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: widget.spu["sysPrepareSkuList"][index]["imgUrl"] != null &&
                                            widget.spu["sysPrepareSkuList"][index]["imgUrl"].length != 0
                                        ? Row(
                                            children: [
                                              for (var imagePath
                                                  in widget.spu["sysPrepareSkuList"][index]["imgUrl"]?.split(';'))
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() => PhotoViewPage(
                                                          images: widget.spu["sysPrepareSkuList"][index]["imgUrl"]
                                                              ?.split(';'), //传入图片list
                                                          index: 0, //传入当前点击的图片的index
                                                        ));
                                                    // Get.to(() =>
                                                    //     SimplePhotoPreview(
                                                    //       imageUrl:
                                                    //           imagePath, //传入图片list
                                                    //     ));
                                                    //TODO 添加图片预览
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl: imagePath,
                                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                        CircularProgressIndicator(
                                                      value: downloadProgress.progress,
                                                      backgroundColor: Colors.black,
                                                    ),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                  ),
                                                )
                                            ],
                                          )
                                        : Text("暂无照片"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: WMSText(
                                    content: widget.spu["sysPrepareSkuList"][index]["status"] == "0" ? '正常' : '瑕疵',
                                    size: 12,
                                    bold: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (widget.editable) {
                          print("可以编辑");
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.all(radius),
                              height: rowHeight,
                              color: Colors.red,
                              child: Text(
                                "删除",
                                textAlign: TextAlign.right,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            key: UniqueKey(),
                            onDismissed: (DismissDirection direction) {
                              print("删除了 $index");
                              setState(() {
                                widget.spu["sysPrepareSkuList"].removeAt(index);
                                widget.afterEdit?.call();
                              });
                            },
                            confirmDismiss: (DismissDirection direction) async {
                              // 在这里进行删除SN操作,如果成功了返回true
                              return await deleteSn(index);
                            },
                            child: spuInfoBlock,
                          );
                        } else {
                          print("不可编辑");
                          return spuInfoBlock;
                        }
                      }),
                ),
              ],
            )
        ],
      ),
    );

    if (widget.editable &&
        (widget.inspectionRequirement == '1' ||
            (widget.inspectionRequirement == '0' && widget.model['spuId'] == null))) {
      return Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(5.r),
          height: rowHeight,
          color: Colors.red,
          child: Text(
            "删除",
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.white),
          ),
        ),
        key: UniqueKey(),
        onDismissed: (DismissDirection direction) {
          widget.afterEdit?.call();
        },
        confirmDismiss: (DismissDirection direction) async {
          // 删除SKU

          if (widget.inspectionRequirement == '1') {
            _actualNumberController.text = '0';
            updateSpu();
            widget.afterEdit();
            return true;
          } else {
            return await deleteSku(widget.index);
          }
        },
        child: spuBlockRow,
      );
    } else {
      return spuBlockRow;
    }
  }
}

// 照片预览, 如果后续别的地方有需要再抽象出来

class SimplePhotoPreview extends StatelessWidget {
  // 注意,这个预览非常简单, 不能加入滑动/编辑等功能
  final String imageUrl;

  const SimplePhotoPreview({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "照片预览",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(
              value: downloadProgress.progress,
              backgroundColor: Colors.black,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
