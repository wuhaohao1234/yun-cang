// 仓库端  签收页面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/common/baseWidgets/wms_upload_image_widget.dart';
import 'package:wms/models/oss_model.dart';
import 'package:wms/views/common/section_title_widget.dart';
import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';

import 'package:wms/views/entrenpot/ruku/en_ybrkd_cell.dart';
import '../en_RuKuTabs.dart';
import 'dart:io';

class ENYbrkDetailPage extends StatefulWidget {
  final num orderId;

  final ENYbrkModel ybrkModel;

  const ENYbrkDetailPage({
    Key key,
    @required this.orderId,
    this.ybrkModel,
  }) : super(key: key);

  @override
  _ENYbrkDetailPageState createState() => _ENYbrkDetailPageState();
}

class _ENYbrkDetailPageState extends State<ENYbrkDetailPage> {
  List<File> images = [];
  final boxTotalFactC = TextEditingController();
  ENYbrkModel dataModel;

  @override
  void initState() {
    super.initState();

    onRefresh();
  }

  // 请求数据
  requestData() {
    HttpServices.enPrepareOrderDetail(
        orderId: widget.orderId,
        success: (data) {
          EasyLoadingUtil.hidden();
          dataModel = data;
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  Future<void> onRefresh() async {
    requestData();
  }

  Future submitImagesToOrder(String imagePaths) async {
    // 把照片提交到服务器
    Completer completer = new Completer();
    final int orderId = widget.orderId;
    print("orderId:$orderId, imagePaths:$imagePaths");

    HttpServices.editPrepareOrder(
        orderId: orderId.toString(),
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
    EasyLoadingUtil.showLoading(statusText: "上传照片中...");
    String imagePaths = '';
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

  //签收

  Future signOrder(String boxTotalFact, String imgPaths) async {
    Completer completer = new Completer();
    EasyLoadingUtil.showLoading(statusText: "确认签收中...");
    HttpServices.enSignOrder(
        orderId: widget.orderId,
        boxTotalFact: boxTotalFact,
        instoreOrderImg: imgPaths,
        success: (data) {
          EasyLoadingUtil.hidden();
          completer.complete(true);
        },
        error: (e) {
          completer.complete(e);
          print(e.message);
        });

    return completer.future;
  }

  // void onTapCreateYbrkdBtnHandle() {
  //   Get.to(
  //     () => () => ENCreateRkdPage(
  //           model: dataModel.value,
  //         ),
  //   ).then((value) {
  //     if (value == true) {
  //       Get.back(result: true);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // ENYbrkPageController pageController1 = Get.put(ENYbrkPageController());
    // ENYbrkDetailPageController pageController =
    //     Get.put(ENYbrkDetailPageController(widget.orderId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '签收',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            // Get.delete<ENYbrkPageController>();
            Get.offAll(() => ENRkdShPage(defaultIndex: 0));
          },
        ),
      ),
      body: Container(
          // header: MaterialHeader(
          //   valueColor: AlwaysStoppedAnimation(Colors.black),
          // ),
          // onRefresh: pageController1.onRefresh,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SectionTitleWidget(
                          title: '基础信息',
                        ),
                        Container(
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(17.h),
                            color: Colors.grey[200],
                          ),
                          child: ENYbrkdCell(
                            model: widget.ybrkModel,
                            // model: widget.ybrkModel,
                            callback: () {},
                          ),
                        ),
                        WMSTextField(
                          title: '收货箱数',
                          hintText: '必填',
                          keyboardType: TextInputType.number,
                          controller: boxTotalFactC,
                        ),
                        SectionTitleWidget(
                          title: '上传收货照片',
                        ),
                        WMSUploadImageWidget(
                          images: images,
                          addCallBack: () {
                            Get.to(() => CommonTakePhotosPage(
                                  images: images,
                                )).then((value) {
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: buildButtonWidget(
                      width: 343.w,
                      height: 34.h,
                      radius: 2.0,
                      contentColor: Colors.white,
                      bgColor: AppConfig.themeColor,
                      buttonContent: '确认签收',
                      handelClick: () async {
                        if (dataModel != null && dataModel.status == '0' && boxTotalFactC.text != '') {
                          print("首先上传照片");
                          final imagePaths = await uploadQianShouImages();

                          // EasyLoadingUtil.showMessage(message: "请重新填写预约箱数");
                          // 上传图片URL到服务器 并且签收
                          final signed = await signOrder(boxTotalFactC.text, imagePaths);
                          if (signed.runtimeType == ErrorEntity) {
                            ToastUtil.showMessage(message: signed.message);
                          } else {
                            print("签收完成");
                            for (var index = 0; index < images.length; index++) {
                              images[index].deleteSync();
                            }
                            setState(() {
                              images = [];
                            });
                            Get.back();
                          }
                        } else {
                          EasyLoadingUtil.showMessage(message: "请填写预约箱数");
                          // EasyLoadingUtil.hidden();
                        }
                      },
                    ),
                  ),
                ],
              ))),
    );
  }
}
