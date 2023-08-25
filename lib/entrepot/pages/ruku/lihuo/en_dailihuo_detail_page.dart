// 理货详情界面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:flutter/cupertino.dart';
import 'package:wms/entrepot/controllers/ruku/en_rkd_detail_page_controller.dart';
import 'package:wms/views/entrenpot/en_rkd_top_widget.dart';

// import '../en_RuKuTabs.dart'; // 商品界面
// import 'en_rkd_add_wares_page.dart'; //新增商品页面
import 'en_dailihuo_complete_page.dart';
import 'package:wms/views/entrenpot/en_table_cell.dart';
import 'package:wms/views/entrenpot/en_sku_cell.dart';

class ENDaiLihuoDetailPage extends StatefulWidget {
  final num instoreOrderId;
  final num prepareOrderId;
  final num orderOperationalRequirements;
  final num spuId;
  // final num orderIndex;

  const ENDaiLihuoDetailPage(
      {Key key,
      @required this.instoreOrderId,
      this.prepareOrderId,
      this.orderOperationalRequirements,
      this.spuId})
      : super(key: key);

  @override
  _ENDaiLihuoDetailPageState createState() => _ENDaiLihuoDetailPageState();
}

class _ENDaiLihuoDetailPageState extends State<ENDaiLihuoDetailPage> {
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
    HttpServices.tallysubmisssion(
        params: detailController.data,
        success: (data) {
          completer.complete(true);
        },
        error: (e) {
          print(e.message);
        });
    print(detailController.data);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    // 构建商品列表
    List<Widget> constructShangpingList() {
      List<Widget> list = [];
      for (var index = 0;
          index <
              detailController.commodityList
                  .where((commodity) => commodity['spuId'] == widget.spuId)
                  .length;
          index++) {
        list.add(
          Column(
            children: [
              ENRkdDetailTopWidget(
                picturePath:
                    detailController.commodityList[index]['picturePath'] ?? '',
                name: detailController.commodityList[index]['commodityName'],
                brandName: detailController.commodityList[index]['brandName'],
                stockCode: detailController.commodityList[index]['stockCode'],
              ),
              buildTableHeadWdidget(['尺码/规格', '条形码(sku)', '实收数量']),
              buildSKuInfoWdidget(
                list: detailController.commodityList
                    .where((commodity) => commodity['spuId'] == widget.spuId)
                    .first['sysPrepareOrderSpuList'],
                // showTitle: ['size', 'skuId', 'actualNumber']
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
          content: '理货详情',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: RefreshView(
        header: MaterialHeader(
          valueColor: AlwaysStoppedAnimation(Colors.black),
        ),
        onRefresh: detailController.onRefresh,
        firstRefresh: true,
        child: Container(
            // color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 20.h),
                    // 商品列表
                    ...constructShangpingList(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildButtonWidget(
                        width: 120.w,
                        height: 34.h,
                        radius: 2.0,
                        buttonContent: '扫码',
                        handelClick: () {
                          onTapScanBtnHandle(context);
                        },
                      ),
                      buildButtonWidget(
                        width: 120.w,
                        height: 34.h,
                        radius: 2.0,
                        contentColor: Colors.white,
                        bgColor: AppConfig.themeColor,
                        buttonContent: '提交理货信息',
                        handelClick: () {
                          final signed = tallysubmisssion();
                          if (true) {
                            EasyLoadingUtil.showMessage(message: "理货完成");
                            print("签收完成");

                            Get.to(
                              () => ENDaiLihuoCompletePage(
                                instoreOrderId: widget.instoreOrderId,
                                prepareOrderId: widget.prepareOrderId,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 60),
      //   child: FloatingActionButton(
      //     // 点击以后扫描并识别商品
      //     onPressed: () {
      //       onTapScanBtnHandle(context);
      //     },
      //     backgroundColor: Colors.grey,
      //     child: Icon(CupertinoIcons.barcode),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // 点击扫码按钮事件处理
  void onTapScanBtnHandle(BuildContext context) {
    print('直接进入扫码');
    // scanSku(widget.prepareOrderId, widget.instoreOrderId,
    //     widget.orderOperationalRequirements);
  }
}

// SKU信息
Widget buildSKuInfoWdidget({
  List list,
  bool editable: true,
}) {
  List<Widget> listWidget = [];
  for (var index = 0; index < list.length; index++) {
    listWidget.add(
      SkuInfoBlock(
        spu: list[index],
        editable: editable,
        delKey: index,
      ),
    );
  }

  return Column(
    children: listWidget,
  );
}
