import 'package:flutter/cupertino.dart';
import 'package:wms/customer/common.dart';
import 'package:wms/entrepot/controllers/chuku/en_qc_controller.dart';
import 'package:wms/entrepot/pages/chuku/en_scan_fenjian.dart';
import 'package:wms/views/entrenpot/en_rkd_top_widget.dart';

class ENQc extends StatefulWidget {
  final model;
  final callback;

  const ENQc({Key key, this.model, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ENQcState();
  }
}

class ENQcState extends State<ENQc> {
  TextEditingController snCodeController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  ENQcController enQcController = Get.find();
  FocusNode _snCodeFocusNode = FocusNode();

  @override
  void initState() {
    print("model${widget.model}");
    snCodeController.text = enQcController.snCode.value;
    remarkController.text = enQcController.remark.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("质检拍照"),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          ENRkdDetailTopWidget(
            picturePath: widget.model['picturePath'] ?? null,
            name: widget.model['commodityName'],
            brandName: widget.model['brandName'],
            stockCode: widget.model['stockCode'],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            width: 375.w,
            child: Row(
              children: [
                Container(
                  child: WMSText(
                    content: "SN码",
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                    child: TextField(
                  focusNode: _snCodeFocusNode,
                  keyboardType: TextInputType.text,
                  controller: snCodeController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: '必填',
                    // suffixIcon: Icon(Icons.person),
                    suffixIcon: Container(
                      padding: EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ENScanStandardPage(
                                title: "扫码",
                                // leading: backLeadingIcon,
                              )).then((value) {
                            snCodeController.text = value;
                            enQcController.changeSnCode(value);
                          });
                        },
                        child: SvgPicture.asset('assets/svgs/scan.svg', width: 18.w, color: Colors.black),
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                  ),
                  onChanged: (value) {
                    enQcController.changeSnCode(value);
                  },
                )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            width: 375.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: WMSText(
                    content: "质检照片",
                  ),
                ),
                buildItemsImage(enQcController)
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
              width: 375.w,
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: WMSText(
                    content: "状态",
                  ),
                ),
                Obx(() => Radio(
                    value: true,
                    activeColor: AppConfig.themeColor,
                    groupValue: enQcController.spuFlaw.value,
                    onChanged: (e) {
                      print(e);
                      enQcController.setStatus(true);
                    })),
                WMSText(
                  content: "正常",
                ),
                Obx(() => Radio(
                    value: false,
                    activeColor: AppConfig.themeColor,
                    groupValue: enQcController.spuFlaw.value,
                    onChanged: (e) {
                      print(e);
                      enQcController.setStatus(false);
                    })),
                WMSText(
                  content: "瑕疵",
                )
              ])),
          Obx(() => Visibility(
              visible: !enQcController.spuFlaw.value,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  width: 375.w,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Container(
                        height: 40.h,width: 90.w,
                        child: Row(children: [
                          Checkbox(
                            value: enQcController.flawLevelSelected.indexWhere((element) => element == 0) != -1,
                            // 改变后的事件
                            onChanged: (value) {
                              enQcController.changeFlawLevel(0);
                            },
                            shape: CircleBorder(),
                            side: BorderSide(width: 2, color: Colors.black54),
                            activeColor: AppConfig.themeColor,
                            checkColor: Colors.white,
                          ),
                         Expanded(child:  WMSText(
                           content: "缺配件",
                         ))
                        ])),
                    Container(
                        height: 40.h,width: 90.w,
                        child: Row(children: [
                          Checkbox(
                            value: enQcController.flawLevelSelected.indexWhere((element) => element == 1) != -1,
                            // 改变后的事件
                            onChanged: (value) {
                              enQcController.changeFlawLevel(1);
                            },
                            shape: CircleBorder(),
                            side: BorderSide(width: 2, color: Colors.black54),
                            activeColor: AppConfig.themeColor,
                            checkColor: Colors.white,
                          ),
                          Expanded(child: WMSText(
                            content: "划痕磨损",
                          ))
                        ])),
                    Container(
                        height: 40.h,width: 80.w,
                        child: Row(children: [
                          Checkbox(
                            value: enQcController.flawLevelSelected.indexWhere((element) => element == 2) != -1,
                            // 改变后的事件
                            onChanged: (value) {
                              enQcController.changeFlawLevel(2);
                            },
                            shape: CircleBorder(),
                            side: BorderSide(width: 2, color: Colors.black54),
                            activeColor: AppConfig.themeColor,
                            checkColor: Colors.white,
                          ),
                          Expanded(child: WMSText(
                            content: "污渍",
                          ))
                        ])),
                    Container(
                        height: 40.h,width: 80.w,
                        child: Row(children: [
                          Checkbox(
                            value: enQcController.flawLevelSelected.indexWhere((element) => element == 3) != -1,
                            // 改变后的事件
                            onChanged: (value) {
                              enQcController.changeFlawLevel(3);
                            },
                            shape: CircleBorder(),
                            side: BorderSide(width: 2, color: Colors.black54),
                            activeColor: AppConfig.themeColor,
                            checkColor: Colors.white,
                          ),
                          Expanded(child: WMSText(
                            content: "做工",
                          ))
                        ]))
                  ])))),
          Obx(() => Visibility(
              visible: !enQcController.spuFlaw.value,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: WMSText(
                          content: "描述",
                        )),
                    TextField(
                      controller: remarkController,
                      decoration: InputDecoration(
                          hintText: "请输入商品描述，如包装破损，缺配件，五金磨损，皮质划痕，缺吊牌等",
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black54))),
                      minLines: 1,
                      maxLines: 10,
                      onChanged: (value) {
                        enQcController.changeRemark(value);
                      },
                    )
                  ])))),
          Container(
            padding: EdgeInsets.only(top: 40.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButtonWidget(
                  width: 120.w,
                  height: 34.h,
                  radius: 2.0,
                  bgColor: AppConfig.themeColor,
                  contentColor: Colors.white,
                  buttonContent: '完成质检',
                  borderColor: AppConfig.themeColor,
                  handelClick: () async {
                    if (snCodeController.text.trim().length == 0) {
                      ToastUtil.showMessage(message: "请填写SN码");
                      return;
                    }
                    var res = await enQcController.submitPostInfo();
                    if (res) {
                      widget.callback();
                    }
                    Get.back();
                  },
                )
              ],
            ),
          )
        ]))));
  }

  // 商品照片
  Widget buildItemsImage(ENQcController pageController) {
    return Obx(() {
      return WMSUploadImageWidget(
        maxLength: 6,
        images: pageController.itemsImages.value,
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

  @override
  void dispose() {
    enQcController.cleanForm();
    super.dispose();
  }
}
