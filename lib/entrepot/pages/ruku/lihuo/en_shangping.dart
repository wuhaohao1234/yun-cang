// 商品质检页面
import 'package:wms/models/entrepot/sku/en_shangpin_model.dart';
import 'package:wms/entrepot/pages/common.dart';
import 'en_dailihuo_complete_page.dart';
import 'dart:io';
import 'package:wms/models/oss_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:wms/entrepot/controllers/ruku/en_rkd_detail_page_controller.dart';

// import 'en_shangping_search.dart';
import 'en_shangping_scan_utils.dart';
import 'package:wms/views/commodity_ybrk_choose_size_cell.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

class ENShangPingPage extends StatefulWidget {
  final num instoreOrderId;
  final num prepareOrderId;
  final num spuId;
  final num skuId;
  final num orderOperationalRequirements;
  final ENShangPingModel dataModel;
  final callback;

  ENShangPingPage(
      {Key key,
      this.instoreOrderId,
      this.spuId,
      this.skuId,
      this.prepareOrderId,
      this.dataModel,
      this.orderOperationalRequirements,
      this.callback})
      : super(key: key);

  @override
  State<ENShangPingPage> createState() => _ENShangPingPageState();
}

class _ENShangPingPageState extends State<ENShangPingPage> {
  List<File> images = [];
  String size = "";
  TextEditingController skuId;
  TextEditingController skuCode;
  TextEditingController snCode;
  bool spuFlaw = false; //false 正常  true 瑕疵
  List spuList = [];
  num actualNumber = 0;
  num postSkuId;

  // 瑕疵等级
  List flawLevels = [
    {"text": "缺配件", "selected": false, "value": 0},
    {"text": "划痕磨损", "selected": false, "value": 1},
    {"text": "污渍", "selected": false, "value": 2},
    {"text": "做工", "selected": false, "value": 3}
  ]; //对应的index为传入值
  String flawLevelSelected = ""; // 默认瑕疵等级为N
  //瑕疵描述
  final flawRemark = TextEditingController();

  // 图标尺寸
  final iconSize = 20.w;

  //图片处理

  Future submitImagesToOrder(String imagePaths) async {
    // 把照片提交到服务器
    Completer completer = new Completer();
    print("orderId:$widget.prepareOrderId, imagePaths:$imagePaths");
    HttpServices.editPrepareOrder(
        orderId: widget.prepareOrderId.toString(),
        instoreOrderImg: imagePaths,
        success: (_) {
          // 删除所有文件
          setState(() {
            for (var index = 0; index < images.length; index++) {
              images[index].deleteSync();
            }
            images = [];
            completer.complete(true);
          });
        },
        error: (_) {});
  }

  Future getOssObj() async {
    Completer completer = new Completer();
    HttpServices.requestOss(
        dir: AppGlobalConfig.imageType3,
        success: (data) {
          completer.complete(data);
        });
    return completer.future;
  }

  Future uploadImageAsync(OssModel model, File image) async {
    Completer completer = new Completer();
    HttpServices.upLoadImage(
        file: image,
        model: model,
        success: (imgUrl) {
          completer.complete(imgUrl);
        },
        error: (data) {
          completer.completeError(data);
        });
    return completer.future;
  }

  // 上传入库单图片
  uploadQianShouImages() async {
    String imagePaths = '';
    if (images.length == 0) {
      return imagePaths;
    }
    EasyLoadingUtil.showLoading(statusText: "上传照片中...");

    final ossObj = await getOssObj();
    for (int i = 0; i < images.length; i++) {
      String imgUrl = await uploadImageAsync(ossObj, images[i]);
      print("第 $i 张照片上传成功");
      imagePaths += imgUrl;
      if (i < images.length - 1) {
        imagePaths += ";";
      }
    }
    EasyLoadingUtil.hidden();
    return imagePaths;
  }

  //签收(质检)
  Future inspectionComplete(String imgPaths) async {
    Completer completer = new Completer();
    spuList = [
      {
        'spuId': widget.spuId,
        'skuId': postSkuId,
        'spuFlaw': spuFlaw ? "1" : "0", //0 为正常，1为瑕疵。默认为false，0
        'skuCode': skuCode.text,
        'snCode': snCode.text,
        'defectiveImg': imgPaths,
        'defectDegree': flawLevelSelected,
        'remark': flawRemark.text
      }
    ];
    HttpServices.inspectionComplete(
        sysPrepareOrderId: widget.prepareOrderId,
        sysPrepareOrderSpuList: spuList,
        success: (data) {
          print(data);
          completer.complete(data);
          return data;
        },
        error: (e) {
          print(e.message);
          //显示修改信息
          EasyLoadingUtil.showMessage(message: e.message);
        });
    return completer.future;
  }

  Future noInspectionComplete() async {
    // print(postSkuId);
    Completer completer = new Completer();
    spuList = [];
    for (var i = 0; i < widget.dataModel?.skuAndSize?.length; i++) {
      if (widget.dataModel?.skuAndSize[i]['actualNumber'] != null &&
          widget.dataModel?.skuAndSize[i]['actualNumber'] != 0) {
        spuList.add({
          'skuId': widget.dataModel?.skuAndSize[i]['skuId'],
          'spuId': widget.spuId,
          'actualNumber': widget.dataModel?.skuAndSize[i]['actualNumber'].toString(),
          'skuCode': widget.dataModel?.skuAndSize[i]['skuCode'],
        });
      }
    }
    print(spuList);

    HttpServices.noInspectionComplete(
        sysPrepareOrderId: widget.prepareOrderId,
        sysPrepareOrderSpuList: spuList,
        success: (data) {
          completer.complete(true);
          return data;
        },
        error: (e) {
          print(e.message);
          EasyLoadingUtil.showMessage(message: e.message);
        });
    return completer.future;
  }

  bool checkInput({showInfo = true}) {
    // 如果SN码没有填写且要求为拍照质检时, 返回false
    print("widget.orderOperationalRequirements=${widget.orderOperationalRequirements}, snCode.text=${snCode.text}");
    if (widget.orderOperationalRequirements != 1 && snCode.text == '') {
      if (showInfo) ToastUtil.showMessage(message: '请填写SN码');
      return false;
    }
    if (postSkuId == null) {
      if (showInfo) ToastUtil.showMessage(message: '请确认是否选择尺寸');
      return false;
    }

    //判断理货点数的skuCode和count
    if (widget.orderOperationalRequirements == 1) {
      var shangpinList = widget.dataModel?.skuAndSize;
      if (shangpinList.every((each) => (each['actualNumber'] == 0 || each['actualNumber'] == null))) {
        if (showInfo) ToastUtil.showMessage(message: '请填写商品的数量');
        return false;
      }
      for (var i = 0; i < shangpinList.length; i++) {
        // 理货有数量且skuCode为空，返回false
        if ((shangpinList[i]['actualNumber'] != 0 && shangpinList[i]['actualNumber'] != null) &&
                shangpinList[i]['skuCode'] == null ||
            shangpinList[i]['skuCode'] == '') {
          if (showInfo) ToastUtil.showMessage(message: '请输入商品的sku码');
          return false;
        }
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    skuId = TextEditingController();
    skuId.text = postSkuId.toString();
    skuCode = TextEditingController();

    snCode = TextEditingController();
    snCode.text = '';
    actualNumber = widget.orderOperationalRequirements == 0 ? 1 : 0;

    // 默认选择第一个尺码
    postSkuId = postSkuId == null ? widget.dataModel.skuAndSize[0]['skuId'] : null;
    skuId.text = postSkuId.toString();
    skuCode.text = postSkuId != null ? widget.dataModel.skuAndSize[0]['skuCode'] : null;
  }

  @override
  void dispose() {
    flawRemark.dispose();
    super.dispose();
  }

  Future submitPostInfo() async {
    bool lihuoFinished = false;
    EasyLoadingUtil.showLoading(statusText: "确认提交信息...");

    //质检
    if (widget.orderOperationalRequirements != 1) {
      // SNCode是必填
      if (snCode.text != '') {
        print("首先上传照片");
        final imagePaths = await uploadQianShouImages();
        // 上传图片URL到服务器 并且签收
        await inspectionComplete(imagePaths);

        setState(() {
          for (var index = 0; index < images.length; index++) {
            images[index].deleteSync();
          }
          images = [];
        });
        lihuoFinished = true;
      }
    }
    if (widget.orderOperationalRequirements == 1) {
      //理货点数
      // 上传图片URL到服务器 并且签收
      await noInspectionComplete();
      lihuoFinished = true;
    }
    EasyLoadingUtil.hidden();
    if (lihuoFinished) {
      EasyLoadingUtil.showMessage(message: "提交完成");
    } else {
      EasyLoadingUtil.showMessage(message: "提交理货信息错误");
    }
    return lihuoFinished;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: WMSText(
            content: widget.orderOperationalRequirements == 1 ? '理货点数' : '拍照质检',
            size: AppStyleConfig.navTitleSize,
          ),
        ),
        body: Container(
            // padding: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
            child: ScrollConfiguration(
                behavior: JKOverScrollBehavior(),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(children: <Widget>[
                        // 头部信息
                        Container(
                          padding: EdgeInsets.only(bottom: 16.w),
                          child: Row(
                            children: [
                              // 这里要处理成正方形的
                              Expanded(
                                  flex: 1,
                                  child: (widget.dataModel.picturePath == null && widget.dataModel.picturePath != '')
                                      ? Center(
                                          child: Text("无图片"),
                                        )
                                      : Image.network(
                                          widget.dataModel.picturePath,
                                          fit: BoxFit.contain,
                                        )),
                              SizedBox(
                                width: 8.w,
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("货号: ${widget.dataModel.stockCode}"),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text("品牌: ${widget.dataModel.brandName}"),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      "商品名称: ${widget.dataModel.commodityName ?? '暂缺'}",
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 尺码信息
                        if (widget.orderOperationalRequirements != 1) buildSizeListWidget(),
                        // SKU条码 理货质检页面出现
                        if (widget.orderOperationalRequirements != 1)
                          Container(
                            // color: Colors.red,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text("SKU码"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: WMSTextField(
                                    keyboardType: TextInputType.text,
                                    controller: skuCode,
                                    hintText: "请输入SKU码（必填）",
                                    marginTop: 0.h,
                                    onChangedCallback: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  constraints: BoxConstraints(maxHeight: 30.w),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Get.to(() => ENScanStandardPage(
                                          title: "扫SKU码",
                                          // leading: backLeadingIcon,
                                        )).then((value) {
                                      setState(() {
                                        skuCode.text = value;
                                      });
                                    });
                                  },
                                  // 这里唤起扫码
                                  icon: SvgPicture.asset(
                                    'assets/svgs/scan.svg',
                                    width: iconSize,
                                  ),
                                )
                              ],
                            ),
                          ),
                        //显示SN码
                        // 注意: 质检页面的SN码为必填项目, i.e., widget.orderOperationalRequirements == 1
                        // 理货点数页面SN码选填 i.e., widget.orderOperationalRequirements == 1
                        if (widget.orderOperationalRequirements != 1)
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text("SN码"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: WMSTextField(
                                    keyboardType: TextInputType.text,
                                    controller: snCode,
                                    hintText: "请输入SN码（必填）",
                                    marginTop: 0.h,
                                    onChangedCallback: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  constraints: BoxConstraints(maxHeight: 30.w),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Get.to(() => ENScanStandardPage(
                                          title: "扫SN码",
                                          // leading: backLeadingIcon,
                                        )).then((value) {
                                      setState(() {
                                        snCode.text = value;
                                      });
                                    });
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/svgs/scan.svg',
                                    width: iconSize,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        //显示状态
                        if (widget.orderOperationalRequirements != 1)
                          Container(
                            // color: Colors.red,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  child: WMSText(
                                    content: "状态",
                                  ),
                                ),
                                // Expanded(
                                //   flex: 1,
                                //   child: spuFlaw ? Text("瑕疵") : Text("正常"),
                                // ),
                                // Switch(
                                //   value: spuFlaw,
                                //   onChanged: (value) {
                                //     setState(() {
                                //       spuFlaw = value;
                                //       print(spuFlaw);
                                //     });
                                //   },
                                //   activeTrackColor: Colors.black,
                                //   activeColor: Colors.black,
                                // ),

                                Radio(
                                    value: false,
                                    activeColor: AppConfig.themeColor,
                                    groupValue: spuFlaw,
                                    onChanged: (e) {
                                      setState(() {
                                        spuFlaw = e;
                                      });
                                      print(spuFlaw);
                                    }),
                                WMSText(
                                  content: "正常",
                                ),
                                Radio(
                                    value: true,
                                    activeColor: AppConfig.themeColor,
                                    groupValue: spuFlaw,
                                    onChanged: (e) {
                                      setState(() {
                                        spuFlaw = e;
                                      });
                                      print(spuFlaw);
                                    }),
                                WMSText(
                                  content: "瑕疵",
                                )
                              ],
                            ),
                          ),
                        // 填写瑕疵等级
                        if (widget.orderOperationalRequirements != 1 && spuFlaw)
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("瑕疵等级"),
                                ),
                                SizedBox(width: 20.w),
                                // flawLevels
                                Expanded(
                                  child: Container(
                                    child: Wrap(
                                      children: [
                                        for (int i = 0; i < flawLevels.length; i++)
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  child: Checkbox(
                                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                    shape: CircleBorder(),
                                                    side: BorderSide(width: 2, color: Colors.black54),
                                                    activeColor: AppConfig.themeColor,
                                                    checkColor: Colors.white,
                                                    value: flawLevels[i]['selected'],
                                                    // 选中当前
                                                    onChanged: (v) {
                                                      setState(() {
                                                        flawLevels[i]['selected'] = v;
                                                        var tempFlawList = [];
                                                        for (var i = 0; i < flawLevels.length; i++) {
                                                          if (flawLevels[i]['selected']) {
                                                            tempFlawList.add(flawLevels[i]['value']);
                                                          }
                                                        }
                                                        flawLevelSelected = tempFlawList.join(',');
                                                        print(flawLevelSelected);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  flawLevels[i]['text'],
                                                  style: TextStyle(
                                                      color: flawLevelSelected == flawLevels[i]
                                                          ? Colors.black
                                                          : Colors.grey),
                                                )
                                              ],
                                            ),
                                            padding: EdgeInsets.only(right: 10.h),
                                          )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                        // 显示理货点数的商品数量
                        if (widget.orderOperationalRequirements == 1)
                          CommoditySizeList(
                              skuSizeList: widget.dataModel?.skuAndSize,
                              skuCodeShow: true,
                              skuCodeHintText: '请输入sku码（必填）',
                              onSkuCodeChange: (id, value) {
                                print("${widget.dataModel?.skuAndSize}的第$id 个变成了 $value ");
                                setState(() {
                                  widget.dataModel?.skuAndSize[id]['skuCode'] = value;
                                });
                              },
                              onCommodityNumChange: (id, value) {
                                print("${widget.dataModel?.skuAndSize}的第$id 个变成了 $value ");
                                setState(() {
                                  widget.dataModel?.skuAndSize[id]['actualNumber'] = value;
                                  for (int i = 0; i < widget.dataModel.skuAndSize.length; i++) {
                                    if (widget.dataModel.skuAndSize[i]['actualNumber'] != null &&
                                        widget.dataModel.skuAndSize[i]['actualNumber'] != 0) {
                                      actualNumber += widget.dataModel.skuAndSize[i]['actualNumber'];
                                    }
                                  }
                                  print(actualNumber);
                                });
                              }),

                        if (widget.orderOperationalRequirements != 1) ...[
                          SectionTitleWidget(
                            title: '上传收货照片',
                          ),
                          WMSUploadImageWidget(
                            images: images,
                            addCallBack: () {
                              Get.to(() {
                                GlobalKey<State<CommonTakePhotosPage>> commonTakePhotosPageStateKey = GlobalKey();

                                return CommonTakePhotosPage(
                                  key: commonTakePhotosPageStateKey,
                                  images: images,
                                );
                              }).then((value) {
                                print("得到结果 $value");
                                setState(() {});
                              });
                            },
                            delCallBack: (index) {
                              if (images.length > 0) {
                                images.removeAt(index);
                              }
                              setState(() {});
                            },
                          )
                        ],
                        if (widget.orderOperationalRequirements != 1 && spuFlaw)
                          WMSTextField(
                            title: '备注',
                            hintText: '瑕疵必填',
                            controller: flawRemark,
                            keyboardType: TextInputType.text,
                            marginTop: 0.h,
                          ),
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(Size(90.w, 34.w)),
                              backgroundColor: MaterialStateProperty.resolveWith(
                                  (states) => checkInput() == false ? null : AppStyleConfig.btnColor),
                            ),
                            onPressed: checkInput() == false
                                ? null
                                : () async {
                                    if (!checkInput()) return false;
                                    //设置按钮状态；
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    bool finished = await submitPostInfo();
                                    if (finished) {
                                      images.clear();
                                      setState(() {
                                        snCode.text = "";
                                        spuFlaw = false;
                                        flawLevelSelected = "";
                                      });
                                    }
                                    // scanSku(
                                    //     prepareOrderId: widget.prepareOrderId,
                                    //     instoreOrderId: widget.instoreOrderId,
                                    //     orderOperationalRequirements: widget.orderOperationalRequirements,
                                    //     clearPrev: true,
                                    //     // 如果在下一屏返回应该直接返回理货完成页面
                                    //     backLeadingIcon: IconButton(
                                    //       icon: Icon(
                                    //         Icons.arrow_back_ios_rounded,
                                    //         color: Colors.black,
                                    //       ),
                                    //       onPressed: () => Get.offAll(
                                    //         ENDaiLihuoCompletePage(
                                    //           instoreOrderId: widget.instoreOrderId,
                                    //           prepareOrderId: widget.prepareOrderId,
                                    //           orderOperationalRequirements: widget.orderOperationalRequirements,
                                    //         ),
                                    //       ),
                                    //     ));
                                  },
                            child: Text(
                              '提交信息并继续理货',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(Size(90.w, 34.w)),
                              backgroundColor: MaterialStateProperty.resolveWith(
                                  (states) => checkInput() == false ? null : AppStyleConfig.btnColor),
                            ),
                            onPressed: checkInput() == false
                                ? null
                                : () async {
                                    //设置按钮状态；
                                    if (!checkInput()) return false;
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    await submitPostInfo();
                                    Get.delete<ENRkdDetailPageController>();
                                    widget?.callback();
                                    Get.back();
                                    // Get.offAll(
                                    //   ENDaiLihuoCompletePage(
                                    //     instoreOrderId: widget.instoreOrderId,
                                    //     prepareOrderId: widget.prepareOrderId,
                                    //     orderOperationalRequirements: widget.orderOperationalRequirements,
                                    //   ),
                                    // );
                                  },
                            child: Text(
                              '完成理货',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }

  // 在售尺寸
  Widget buildSizeListWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: buildSizeList(widget.dataModel?.skuAndSize),
              ),
            ),
          )
        ],
      ),
    );
  }

//设置尺寸列表
  List<Widget> buildSizeList(list) {
    List<Widget> widgets = [];
    // 自动选中第一个
    list?.forEach((element) {
      widgets.add(buildSizeItemWidget(
        element,
      ));
    });

    return widgets;
  }

  Widget buildSizeItemWidget(
    element,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          //如果没有选中的话,默认就选择第一个
          // if (postSkuId == null) {
          setState(() {
            // postSkuId = postSkuId == null ? element['skuId'] : null;
            postSkuId = element['skuId'];
            skuCode.text = element['skuCode'];
            skuId.text = postSkuId.toString();
            //设置瑕疵初始状态；
            spuFlaw = false;
            flawLevelSelected = '';
            for (var i = 0; i < flawLevels.length; i++) {
              flawLevels[i]['selected'] = false;
            }
            print(flawLevels);
          });
          // }
        },
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.r)),
            border: postSkuId == element['skuId'] ? Border.all(width: 2.0, color: AppStyleConfig.btnColor) : null,
            color: Colors.grey[200],
          ),
          child: Center(
            child: WMSText(
              content: '${element['size']}${element['specification'] != null ? "/" + element['specification'] : ''}',
              size: 13,
              bold: true,
            ),
          ),

          // child: FittedBox(
          //   child: Center(
          //     child: WMSText(
          //       content: '${element['size']}',
          //       size: 14,
          //       bold: true,
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
