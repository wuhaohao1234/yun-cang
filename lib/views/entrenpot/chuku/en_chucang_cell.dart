import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_info_row.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wms/common/baseWidgets/wms_upload_image_widget.dart';
import 'package:wms/customer/common.dart';
import 'package:wms/entrepot/pages/chuku/chuku_chenggong.dart';
import 'package:wms/entrepot/pages/en_logistics_page.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/common/pages/wms_camera_page.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/models/oss_model.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/entrepot/pages/common.dart';
import 'en_chucang_cell_controller.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

class ENChuCangCell extends StatefulWidget {
  final VoidCallback callback;
  final model;
  final outStoreType;
  final distributionId;
  final refresh;

  const ENChuCangCell({Key key, this.callback, this.model, this.outStoreType, this.distributionId, this.refresh})
      : super(key: key);

  @override
  _ENChuCangCellState createState() => _ENChuCangCellState();
}

class _ENChuCangCellState extends State<ENChuCangCell> {
  // inputInfo.text =widget.model['pickUpCode'] ?? '';
  var itemsImages = RxList<File>(); //商品照片
  List<File> images = [];
  var itemsPaths = '';
  TextEditingController expressNumber = TextEditingController();
  TextEditingController pickUpCode = TextEditingController();
  ENChuCangCellController pageController;
  var _expressNumberFocusNode = new FocusNode();

  void initState() {
    super.initState();
    expressNumber.text = widget.model['expressNumber'] ?? '';
    pickUpCode.text = widget.model['pickUpCode'] ?? '';

    // _expressNumberFocusNode.requestFocus();
    _expressNumberFocusNode.addListener(() {
      bool expressNumberFocus = _expressNumberFocusNode.hasFocus;
      print(expressNumberFocus.toString());
      if (expressNumberFocus == false) {
        // expressNumber.text = expressNumber.text;
        _expressNumberFocusNode.unfocus();
        onTapCommitHandle();
      }
    });
  }

  // 添加按钮点击事件
  void onTapCommitHandle() async {
    if (checkInput() == false) {
      return;
    }
    print("coool");
    // EasyLoadingUtil.showLoading();
    if (widget.distributionId == 7) {
      HttpServices.requestOss(
          dir: AppGlobalConfig.imageType3,
          success: (data) async {
            itemsPaths = await uploadImagesList(imageList: itemsImages, ossModel: data);
            print('开始提交数据');
            print('itemsPaths = $itemsPaths');

            requestCommit(itemsPaths);
          },
          error: (error) {
            EasyLoadingUtil.hidden();
            print(error.toString());
          });
    }
    requestCommit(itemsPaths);

    // 上传商品照片
  }

  // 上传照片
  Future<String> uploadImagesList({List<File> imageList, OssModel ossModel}) async {
    String imagesPath = '';
    for (int i = 0; i < imageList.length; i++) {
      String path = await HttpServices.asyncUpLoadImage(
        model: ossModel,
        file: imageList[i],
      );
      imagesPath += path;
      imagesPath += ';';
    }
    return imagesPath.substring(0, imagesPath.length - 1);
  }

  bool checkInput() {
    if (itemsImages.length != 0 || pickUpCode.text.length != 0 || expressNumber.text.length != 0) {
      return true;
    } else {
      return false;
    }
  }

  // 发送添加请求
  Future<void> requestCommit(itemsPaths) async {
    if (pickUpCode.text.length != 0 || expressNumber.text.length != 0 || itemsPaths != 0) {
      var res = await HttpServices().enOutStore(
        wmsOutStoreId: widget.model['wmsOutStoreId'],
        skuTotal: widget.model['skuTotal'] ?? 1,
        expressNumber: expressNumber.text,
        outOrderImg: itemsPaths,
        outSkuOrderImg: itemsPaths,
        pickUpCode: pickUpCode.text ?? "",
      );
      if (res['result']) {
        ToastUtil.showMessage(message: '已提交信息');
        widget.refresh();
        Get.to(()=>ChuKuChengGong(expressNumber:expressNumber.text));
      } else {
        EasyLoadingUtil.showMessage(message: res['data'].toString());
      }
    } else {
      EasyLoadingUtil.showMessage(message: 'error');
    }
  }

  //签收
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _expressNumberFocusNode.unfocus();
        },
        child: Container(
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
                children: [
                  if (this.widget.outStoreType == 'already')
                    Container(
                      child: WMSText(
                        content: '出库时间: ${widget.model['updateTime']}',
                        color: Color(0xFF212121),
                      ),
                    ),
                ],
              ),
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
                            title: '出库单号：',
                            content: widget.model['wmsOutStoreName'] ?? '',
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
                        title: '出库类型：',
                        content: widget.model['logisticsName'] ?? '',
                        leftInset: 8,
                      )),
                  if (widget.model['temporaryExistenceType'] == 0)
                    GestureDetector(
                      onTap: widget.callback,
                      child: stateWidget(title: '临存出库', bgColor: Colors.deepOrangeAccent),
                    ),
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
                        title: '收件人：',
                        content: widget.model['consigneeName'] ?? '',
                        leftInset: 8,
                      )),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              if (widget.model['skuTotal'] != null && widget.model['skuTotal'] != 0)
                Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      color: Colors.black,
                      size: 17,
                    ),
                    Expanded(
                        child: WMSInfoRow(
                          title: '出库件数：',
                          content: widget.model['skuTotal'] == null ? "" : widget.model['skuTotal'].toString(),
                          // content: widget.model['skuTotal'] ?? ''.toString(),
                          leftInset: 8,
                        )),
                  ],
                ),
              if (widget.model['logisticsName'] == "快递" && widget.model['temporaryExistenceType'] != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          color: Colors.black,
                          size: 17,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 8),
                          child: WMSText(
                            content: widget.model['expressNumber'] != null
                                ? '快递单号：${widget.model['expressNumber']}'
                                : '快递单号：',
                            size: 13,
                            bold: true,
                          ),
                        ),
                        if (widget.model['expressNumber'] == null)
                          Container(
                              height: 20,
                              child: GestureDetector(
                                onTap: () {
                                  // onTapCommitHandle();
                                  showDialog(
                                    // context: new BuildContext( context),
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) =>
                                        wvDialog(
                                          widget: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text(
                                                    '请输入快递单号',
                                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(height: 20.0),
                                                TextField(
                                                  keyboardType: TextInputType.text,
                                                  controller: expressNumber,
                                                  autofocus: true,
                                                  // keyboardType:
                                                  //     TextInputType.numberWithOptions(
                                                  //         decimal: true),
                                                  decoration: InputDecoration(
                                                    suffix: GestureDetector(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            ENScanStandardPage(
                                                              title: "扫快递码",
                                                              // leading: backLeadingIcon,
                                                            )).then((value) {
                                                          expressNumber.text = value;
                                                        });
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/svgs/scan.svg',
                                                        width: 15.w,
                                                      ),
                                                    ),
                                                    hintText: '请输入快递单号',
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black),
                                                    ),
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 4.0, horizontal: 10.0),
                                                  ),
                                                ),
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
                                                      title: '确认单号',
                                                      width: 120.w,
                                                      bgColor: AppConfig.themeColor,
                                                      textColor: Colors.white,
                                                      showBorder: true,
                                                      callback: () async {
                                                        // widget.onDeleteFunc(widget.skuIndex);
                                                        Navigator.of(context).pop(true);
                                                        onTapCommitHandle();
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
                                child: Icon(Icons.edit, color: Colors.black, size: 22.w),
                              ))
                      ],
                    ),
                    if (widget.model['expressNumber'] != null) TextButton(onPressed: () {
                      Get.to(() =>
                          ENLogisticsPage(
                              dataCode: widget.model['expressNumber']));
                    }, child: Text("查看物流"))
                  ],
                ),

              if (widget.model['logisticsName'] == "自提" && widget.model['temporaryExistenceType'] != 0)
                Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      color: Colors.black,
                      size: 17,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 8),
                      child: WMSText(
                        content: '自提码：',
                        size: 13,
                        bold: true,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 20,
                        child: TextField(
                          maxLines: 1,
                          cursorColor: Colors.black,
                          onEditingComplete: onTapCommitHandle,
                          controller: pickUpCode,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.r),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(color: Colors.black, width: 0.1)),
                            hintText: '',
                            hintStyle: TextStyle(fontSize: 8.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.model['logisticsName'] == "车送" && widget.model['temporaryExistenceType'] != 0)
                Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      color: Colors.black,
                      size: 17,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 8),
                      child: WMSText(
                        content: '出库照片：',
                        size: 13,
                        bold: true,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        child: Row(
                          children: [
                            buildItemsImage(itemsImages),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: onTapCommitHandle,
                              child:
                              WMSButton(title: "提交",
                                  width: 30,
                                  height: 25,
                                  radius: 20,
                                  callback: widget.callback),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              // ),
              SizedBox(
                height: 12.h,
              ),
            ],
          ),
        ));
  }

  Widget buildItemsImage(itemsImages) {
    return Obx(() {
      return WMSUploadImageWidget(
        maxLength: 6,
        images: itemsImages.value,
        addCallBack: () {
          print('add =======');
          onTapAddItemsImage();
        },
        delCallBack: (index) {
          onTapDelItemsImage(index);
        },
      );
    });
  }

  // 添加商品照片
  void onTapAddItemsImage() {
    Get.to(() => WMSCameraPage()).then((value) {
      List temp = value;
      temp.forEach((element) {
        itemsImages.add(element);
      });
    });
  }

// 删除商品照片
  void onTapDelItemsImage(int index) {
    if (itemsImages.length > 0) {
      itemsImages.removeAt(index);
    }
  }

  void dispose() {
    super.dispose();
    _expressNumberFocusNode.dispose();
  }
}
