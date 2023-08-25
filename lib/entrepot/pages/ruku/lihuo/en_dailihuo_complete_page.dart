// 理货详情界面
import 'package:wms/common/baseWidgets/wv_set_up_widget.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:flutter/cupertino.dart';
import 'package:wms/entrepot/controllers/ruku/en_rkd_detail_page_controller.dart';
import 'package:wms/views/entrenpot/en_rkd_top_widget.dart';
import 'package:wms/views/entrenpot/ruku/en_rkd_cell.dart';
import 'en_shangping_search.dart';
import 'package:wms/entrepot/controllers/old/en_rkd_page_controller.dart.old';
import '../en_RuKuTabs.dart'; // 商品界面
import 'en_rkd_add_wares_page.dart'; //新增商品页面
import 'en_shangping_scan_utils.dart';
import 'en_spu.dart';

class ENDaiLihuoCompletePage extends StatefulWidget {
  final num instoreOrderId;
  final num prepareOrderId;
  final num orderOperationalRequirements;
  final model;

  const ENDaiLihuoCompletePage({
    Key key,
    @required this.instoreOrderId,
    this.prepareOrderId,
    this.orderOperationalRequirements,
    this.model,
  }) : super(key: key);

  @override
  _ENDaiLihuoCompletePageState createState() => _ENDaiLihuoCompletePageState();
}

class _ENDaiLihuoCompletePageState extends State<ENDaiLihuoCompletePage> {
  ENRkdDetailPageController detailController;

  void initState() {
    super.initState();
    detailController = Get.put(
      ENRkdDetailPageController(
        widget.instoreOrderId,
        widget.prepareOrderId,
        afterSuccess: () {
          setState(() {});
        },
      ),
    );
  }

  Future tallysubmisssion() async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      "prepareOrderId": widget.prepareOrderId,
    };
    HttpServices.tallysubmisssion(
        params: params,
        success: (data) {
          completer.complete(true);
        },
        error: (e) {
          EasyLoadingUtil.showMessage(message: e.message);
          completer.complete(false);
        });
    print(detailController.data);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    // bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;
    const searchPlaceHolder = "请输入商品货号";
    // 构建商品列表
    List<Widget> constructNewShangpingList() {
      List<Widget> list = [];
      for (var index = 0; index < detailController.newCommodityList.length; index++) {
        list.add(
          Column(
            children: [
              // 这里的单位是单个商品
              ENRkdDetailTopWidget(
                picturePath: detailController.newCommodityList[index]['picturePath'] ?? null,
                name: detailController.newCommodityList[index]['commodityName'],
                brandName: detailController.newCommodityList[index]['brandName'],
                stockCode: detailController.newCommodityList[index]['stockCode'],
              ),
              // 这里是SPU的列表
              // buildSpuList(
              //   model:detailController.newCommodityList[index],
              //   spuList: detailController.newCommodityList[index]['sysPrepareOrderSpuList'],
              //   editable: true,
              //   afterEdit: () {
              //     // 在更新以后重新获取数据
              //     detailController.requestData();
              //   },
              //   actualNumberEditable:
              //       detailController.dataInfo.orderOperationalRequirements == 1, // 1为仅理货点数,仅理货点数是可以修改的.
              // ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }
      return list;
    }

    List<Widget> constructShangpingList() {
      List<Widget> list = [];
      for (var index = 0; index < detailController.commodityList.length; index++) {
        list.add(
          Column(
            children: [
              // 这里的单位是单个商品
              ENRkdDetailTopWidget(
                picturePath: detailController.commodityList[index]['picturePath'] ?? null,
                name: detailController.commodityList[index]['commodityName'],
                brandName: detailController.commodityList[index]['brandName'],
                stockCode: detailController.commodityList[index]['stockCode'],
              ),
              // 这里是SPU的列表
              buildSpuList(
                model: detailController.commodityList[index],
                inspectionRequirement: detailController.inspectionRequirement,
                spuList: detailController.commodityList[index]['sysPrepareOrderSpuList'],
                editable: true,
                afterEdit: () {
                  // 在更新以后重新获取数据
                  detailController.requestData();
                },
                actualNumberEditable:
                    detailController.dataInfo.orderOperationalRequirements == 1, // 1为仅理货点数,仅理货点数是可以修改的.
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }
      return list;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '理货',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            Get.delete<ENRkdPageController>();
            Get.off(() => ENRkdShPage(defaultIndex: 1));
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            children: [
              //     RefreshView(
              // header: MaterialHeader(
              //   valueColor: AlwaysStoppedAnimation(Colors.black),
              // ),
              // onRefresh: detailController.onRefresh,
              // firstRefresh: true,
              // child:
              Expanded(
                child: ListView(
                  children: [
                    // 搜索栏
                    //此处存在bug
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: CommonSearchBar(
                                placeHolder: searchPlaceHolder,
                                width: 300.w,
                                showScanIcon: false,
                                searchCallBack: () {
                                  Get.to(() => SkuSearchPage(
                                        placeHolder: searchPlaceHolder,
                                        prepareOrderId: widget.prepareOrderId,
                                        orderOperationalRequirements: widget.orderOperationalRequirements,
                                        callback: () {
                                          detailController.requestData();
                                        },
                                      )).then((value) => detailController.requestData());
                                }),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        WMSButton(
                            title: '申请新品',
                            height: 20.h,
                            width: 70.w,
                            fontSize: 12.sp,
                            bgColor: Colors.transparent,
                            textColor: Colors.black,
                            showBorder: true,
                            callback: () {
                              Get.to(() => ENRkdAddwaresPage(
                                    orderId: widget.prepareOrderId,
                                  )).then((e) {
                                detailController.requestData();
                              });
                            }),
                      ],
                    ),

                    // 订单的信息,引用了 待理货Cell
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: DaiLiHuoCell(
                        model: detailController.dataInfo,
                        // model: widget.model,
                        imgshow: false,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // 商品列表
                    WMSText(content: "预约商品", bold: true),
                    ...constructShangpingList(),
                    WMSText(content: "本次新品(理货请重新扫码)", bold: true),
                    ...constructNewShangpingList(),
                    if (detailController.commodityList.length == 0)
                      Container(
                        child: Center(
                          child: Text("暂无商品信息, 请开始理货"),
                        ),
                      ),
                    if (detailController.commodityList.length > 0)
                      SectionTitleWidget(
                        title:
                            '共${detailController.dataInfo.spuNumber.toString()}个商品，入库总数量${detailController.dataInfo.skusTotalFact.toString()}个',
                      ),
                  ],
                ),
              ),
              // ),
              // 完成理货的操作按钮
              // 只有存在商品才可以完成理货

              Container(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Visibility(
                        visible: true,
                        child: buildButtonWidget(
                          width: 120.w,
                          height: 34.h,
                          radius: 2.0,
                          buttonContent: '扫码',
                          endWidget: Container(
                            margin: EdgeInsets.only(left: 10.w),
                            child: SvgPicture.asset(
                              'assets/svgs/scan.svg',
                              width: 15.w,
                            ),
                          ),
                          handelClick: () {
                            onTapScanBtnHandle(context);
                          },
                        )),
                    if (detailController.commodityList.length > 0)
                      buildButtonWidget(
                          width: 120.w,
                          height: 34.h,
                          radius: 2.0,
                          contentColor: Colors.white,
                          bgColor: AppConfig.themeColor,
                          buttonContent: '完成理货',
                          handelClick: () {
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
                                          '确认完成理货吗？提交后将无法进行修改。',
                                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          WMSButton(
                                            title: '再想想',
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
                                              var notComplete = false;
                                              detailController.commodityList.forEach((e) {
                                                e["sysPrepareOrderSpuList"].forEach((spu) {
                                                  print("spu+++${spu['skuCode']==null}");
                                                  if ((spu['skuCode'].toString().trim() == "" ||
                                                          spu['skuCode'].toString().trim() == "null"||spu['skuCode'] == null) &&
                                                      (spu['actualNumber'].toString() != '0' &&
                                                          spu['actualNumber'] != null)) {
                                                    print("spu-------${spu}");
                                                    notComplete = true;
                                                  }
                                                });
                                              });

                                              if (notComplete) {
                                                print("--------");
                                                EasyLoadingUtil.showMessage(message: "SKU 请填写完整！");
                                                return;
                                              }
                                              final signed = await tallysubmisssion();
                                              if (signed == true) {
                                                EasyLoadingUtil.showMessage(message: "理货完成");
                                                Navigator.of(context).pop(false);
                                                Get.delete<ENRkdPageController>();
                                                detailController.requestData();
                                                // Get.off(() => ENRkdShPage(defaultIndex: 1));
                                                Get.back();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 点击扫码按钮事件处理
  void onTapScanBtnHandle(BuildContext context) {
    print('直接进入扫码');
    print(widget.orderOperationalRequirements);
    scanSku(
        prepareOrderId: widget.prepareOrderId,
        instoreOrderId: widget.instoreOrderId,
        orderOperationalRequirements: widget.orderOperationalRequirements,
        callback: () {
          detailController.requestData();
        });
  }
}
