// 仓库端  签收页面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/common/baseWidgets/wms_upload_image_widget.dart';

import 'package:wms/models/oss_model.dart';
import 'package:wms/views/common/section_title_widget.dart';
import 'package:wms/models/entrepot/chuku/en_chucang_model.dart';
import 'package:wms/views/entrenpot/chuku/en_chucang_lincun_cell.dart';
import 'package:wms/views/common/taking_photos.dart';

import 'en_ChuCangTabs.dart';
import 'dart:io';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/common/pages/wms_camera_page.dart';
import 'package:flutter/cupertino.dart';

// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wms/configs/app_global_config.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

class ENChuCangLinCunPage extends StatefulWidget {
  final num orderId;
  final ENChuCangModel model;

  const ENChuCangLinCunPage({
    Key key,
    this.orderId,
    this.model,
  }) : super(key: key);

  @override
  _ENChuCangLinCunPageState createState() => _ENChuCangLinCunPageState();
}

class _ENChuCangLinCunPageState extends State<ENChuCangLinCunPage> {
  List<File> itemsImages = []; //商品照片
  var itemsPaths = '';
  TextEditingController expressNumber = TextEditingController();
  TextEditingController skuTotal = TextEditingController();

  void initState() {
    super.initState();
    // expressNumber.text = widget.model.expressNumber ?? '';
    // skuTotal.text = widget.model.skuTotal.toString() ?? '0';
  }

  bool checkInput() {
    print(
        'itemsImages.length ${itemsImages.length} ,skuTotal.text ${skuTotal.text},expressNumber.text${expressNumber.text} ');
    if (itemsImages.length != 0 && skuTotal.text.length != 0 && expressNumber.text.length != 0) {
      ToastUtil.showMessage(message: '已填写信息');
      return true;
    }
    return false;
  }

  // 发送添加请求
  void onTapCommitHandle() async {
    if (checkInput() == false) {
      return;
    }
    var imagePaths = '';
    if (itemsImages.length == 0 && itemsImages.length != null) {
    } else {
      EasyLoadingUtil.showLoading(statusText: "...");
      imagePaths = await uploadQianShouImages();
      requestCommit(imagePaths);
    }

    // EasyLoadingUtil.showLoading();
    if (widget.model.distributionId == 7) {
      // HttpServices.requestOss(
      //     dir: AppGlobalConfig.imageType3,
      //     success: (data) async {
      //       itemsPaths =
      //           await uploadImagesList(imageList: itemsImages, ossModel: data);
      //       print('开始提交数据');
      //       print('itemsPaths = $itemsPaths');

      //       requestCommit(itemsPaths);
      //     },
      //     error: (error) {
      //       EasyLoadingUtil.hidden();
      //       print(error.toString());
      //     });
    }

    // 上传商品照片
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

  uploadQianShouImages() async {
    if (itemsImages.length == 0 || itemsImages.length == null) {
      return false;
    }
    EasyLoadingUtil.showLoading(statusText: "上传照片中...");
    String imagePaths = '';
    final ossObj = await getOssObj();
    for (int i = 0; i < itemsImages.length; i++) {
      String imgUrl = await uploadImageAsync(ossObj, itemsImages[i]);
      print("第 $i 张照片上传成功");
      imagePaths += imgUrl;
      if (i < itemsImages.length - 1) {
        imagePaths += ";";
      }
    }
    EasyLoadingUtil.hidden();
    return imagePaths;
  }

  // Future<String> uploadImagesList(
  //     {List<File> imageList, OssModel ossModel}) async {
  //   String imagesPath = '';
  //   for (int i = 0; i < imageList.length; i++) {
  //     String path = await HttpServices.asyncUpLoadImage(
  //       model: ossModel,
  //       file: imageList[i],
  //     );
  //     imagesPath += path;
  //     imagesPath += ';';
  //   }
  //   return imagesPath.substring(0, imagesPath.length - 1);
  // }

  void requestCommit(itemsPaths) async {
    if (checkInput() == false) {
      return;
    }

    if (skuTotal.text.length != 0 && expressNumber.text.length != 0 && itemsPaths != 0) {
      var data = await HttpServices().enOutStore(
        wmsOutStoreId: widget.model.wmsOutStoreId,
        skuTotal: int.parse(skuTotal.text),
        expressNumber: expressNumber.text,
        outSkuOrderImg: itemsPaths,
      );
      if (data != null) {
        ToastUtil.showMessage(message: '已提交信息');
      }
    } else {
      ToastUtil.showMessage(message: '请确认是否输入信息');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: WMSText(
            content: '临存出库',
            size: AppStyleConfig.navTitleSize,
          ),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(17.h),
                          color: Colors.grey[200],
                        ),
                        child: ENChuCangLinCunCell(
                          model: widget.model,
                          callback: () {},
                        ),
                      ),
                      WMSTextField(
                          title: '出货箱数',
                          hintText: '必填',
                          keyboardType: TextInputType.number,
                          controller: skuTotal,
                          onChangedCallback: (e) {
                            skuTotal.text = e;
                            setState(() {});
                          },
                          onSubmittedCallback: (value) {
                            setState(() {});
                          }),
                      SectionTitleWidget(
                        title: '上传货品照片',
                      ),
                      buildItemsImage(itemsImages),
                      WMSTextField(
                        title: '快递单号',
                        hintText: '必填',
                        keyboardType: TextInputType.number,
                        controller: expressNumber,
                        onChangedCallback: (e) {
                          expressNumber.text = e;
                          setState(() {});
                        },
                        onSubmittedCallback: (value) {
                          setState(() {});
                        },
                        endWidget: GestureDetector(
                          onTap: () {
                            Get.to(() => ENScanStandardPage(
                                  title: "扫SN码",
                                  // leading: backLeadingIcon,
                                )).then((value) {
                              expressNumber.text = value;
                              setState(() {});
                            });
                          },
                          child: SvgPicture.asset(
                            'assets/svgs/scan.svg',
                            width: 17.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: buildButtonWidget(
                    width: 343.w,
                    height: 34.h,
                    radius: 2.0,
                    contentColor: Colors.white,
                    borderColor: checkInput() ? Colors.black : Colors.grey,
                    bgColor: checkInput() ? AppConfig.themeColor : Colors.grey,
                    buttonContent: '确认出库',
                    handelClick: checkInput() == false
                        ? null
                        : () async {
                            if (itemsPaths == '') {
                              print("首先上传照片");

                              onTapCommitHandle();
                              Get.to(() => ENChuCangPage());
                            }
                          },
                  ),
                ),
              ],
            )));
  }

  Widget buildItemsImage(itemsImages) {
    return WMSUploadImageWidget(
      maxLength: 6,
      images: itemsImages,
      addCallBack: () {
        print('add =======');
        // onTapAddItemsImage();
        Get.to(() => CommonTakePhotosPage(
              images: itemsImages,
            )).then((value) {
          print("得到结果 $value");
          setState(() {});
        });
      },
      delCallBack: (index) {
        onTapDelItemsImage(index);
      },
    );
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
}
