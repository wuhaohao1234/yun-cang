// 分拣清单界面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/entrepot/controllers/chuku/en_fenjian_detail_page_controller.dart';
// import '../scan/en_search_page.dart';
// import '../scan/en_scan_test_page.dart';
import 'package:wms/views/entrenpot/en_rkd_top_widget.dart';
// import 'package:wms/models/entrepot/chuku/en_fenjian_model.dart';
import 'package:flutter/cupertino.dart';
// import 'package:wms/views/entrenpot/en_table_cell.dart';
// import 'package:wms/views/entrenpot/en_sku_cell.dart';
import 'package:wms/views/entrenpot/chuku/en_fenjian_cell.dart';
import 'package:wms/entrepot/controllers/chuku/en_fenjian_kuaidi_page_controller.dart';
import 'package:wms/entrepot/controllers/chuku/en_fenjian_ziti_page_controller.dart';
import 'package:wms/entrepot/controllers/chuku/en_fenjian_chesong_page_controller.dart';
import 'en_spu.dart';
import 'en_scan_fenjian.dart';
// import 'en_FenJianTabs.dart';

class ENFenJianDetailPage extends StatefulWidget {
  final num outOrderId;
  final num prepareOrderId;
  final num orderIndex;
  final String outStoreName;
  final String tenantUserCode;
  final dynamic dataModel;

  const ENFenJianDetailPage(
      {Key key,
      @required this.outOrderId,
      this.orderIndex,
      this.prepareOrderId,
      this.outStoreName,
      this.tenantUserCode,
      this.dataModel})
      : super(key: key);

  @override
  _ENFenJianDetailPageState createState() => _ENFenJianDetailPageState();
}

class _ENFenJianDetailPageState extends State<ENFenJianDetailPage> {
  ENFenJianDetailPageController detailController;
  final hs = HttpServices();
  void initState() {
    super.initState();
    detailController = Get.put(
      ENFenJianDetailPageController(
        widget.outOrderId,
        afterSuccess: () {
          setState(() {});
        },
      ),
    );
  }

  enSortingCompleted() async {
    final succeed = await HttpServices().enSortingCompleted(
        outStoreName: widget.dataModel.outStoreName,
        outOrderId: widget.dataModel.outOrderId,
        tenantUserCode: widget.dataModel.tenantUserCode,
        consigneeName: widget.dataModel.consigneeName,
        spuNumber: widget.dataModel.spuNumber,
        totalSku: widget.dataModel.totalSku,
        sortingSpuNumber: widget.dataModel.sortingSpuNumber ?? 1,
        sortingTotalSku: widget.dataModel.sortingTotalSku ?? 1,
        logisticsName: widget.dataModel.logisticsName);
    print("分拣结果为$succeed");
    if (succeed == true) {
      EasyLoadingUtil.showMessage(message: "拣货完成");
      // 删除controller
      Get.delete<ENFenJianKuadiPageController>();
      Get.delete<ENFenJianZitiPageController>();
      Get.delete<ENFenJianCheSongPageController>();
      Get.back();
    } else {
      EasyLoadingUtil.showMessage(message: "请求失败，请先分拣商品");
    }
  }

  scanSkuCodeOrSnCode() async {
    // 拣货
    await Permission.camera.request();
    final skuCodeOrSnCode =
        await Get.to(() => ENScanStandardPage(title: "1扫码分拣"));
    print('skuCodeOrSnCode${skuCodeOrSnCode}');
    await sendSkuCodeOrSnCodeForSorting(skuCodeOrSnCode);
  }

  sendSkuCodeOrSnCodeForSorting(String skuCodeOrSnCode) async {
    EasyLoadingUtil.showLoading(statusText: "拣货中");
    final scanSkuSnCodeResult = await hs.enSortingWithSkuOrSnCode(
        code: skuCodeOrSnCode, outOrderId: widget.dataModel.outOrderId);
    EasyLoadingUtil.hidden();
    if (scanSkuSnCodeResult == true) {
      EasyLoadingUtil.showMessage(message: "拣货成功");
      detailController.onRefresh();
      setState(() {});
    } else {
      EasyLoadingUtil.showMessage(message: scanSkuSnCodeResult.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    const searchPlaceHolder = "请扫SN码或者条形码";

    // 构建商品列表
    List<Widget> constructShangpingList() {
      List<Widget> list = [];
      if (detailController.commodityList == null) {
        return list;
      }
      for (var index = 0;
          index < detailController.commodityList.length;
          index++) {
        list.add(Column(
          children: [
            ENRkdDetailTopWidget(
              picturePath:
                  detailController.commodityList[index]['picturePath'] ?? '',
              name: detailController.commodityList[index]['commodityName'],
              brandName: detailController.commodityList[index]['brandName'],
              stockCode: detailController.commodityList[index]['stockCode'],
            ),
            buildSpuList(
                skuList: detailController.commodityList[index]['skuDataList'],
                editable: false,
                afterEdit: () {
                  // 在更新以后重新获取数据
                  detailController.requestData();
                },
                actualNumberEditable: false // 1为仅理货点数,仅理货点数是可以修改的.
                ),
          ],
        ));
      }
      return list;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '拣货清单',
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                // 搜索栏
                Row(
                  children: [
                    Expanded(
                        child: InputSearchBarWidget(
                      searchHinterText: searchPlaceHolder,
                      scanHinterText: '扫码',
                      submitCallback: (value) async {
                        await sendSkuCodeOrSnCodeForSorting(value);
                      },
                      cancelCallback: () {},
                      showActionButtonDynamically: true,
                      allowScan: false,
                      actionButtonContent: "分拣",
                      submitOnChange: false,
                    )

                        //  GestureDetector(
                        //   onTap: () {
                        //     Get.to(
                        //       () => ENSearchPage(
                        //           placeHolder: searchPlaceHolder,
                        //           listType: ['skuid', 'outStoreName']),
                        //     );
                        //   },
                        //   child: Container(
                        //     height: 28.h,
                        //     margin: EdgeInsets.symmetric(vertical: 8.h),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(17.h),
                        //       color: Colors.grey[100],
                        //     ),
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 10),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           Icon(
                        //             Icons.search_rounded,
                        //             size: 18.sp,
                        //             color: Colors.grey,
                        //           ),
                        //           SizedBox(
                        //             width: 8,
                        //           ),
                        //           Text(
                        //             searchPlaceHolder,
                        //             style: TextStyle(
                        //                 fontSize: 14.sp, color: Colors.black26),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        ),
                    // SizedBox(
                    //   width: 8,
                    // ),
                    GestureDetector(
                      onTap: () {
                        scanSkuCodeOrSnCode();
                      },
                      child: SvgPicture.asset(
                        'assets/svgs/scan.svg',
                        width: 17.w,
                      ),
                    ),
                  ],
                ),
                // 订单的信息,引用了外部结构
                Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(17.h),
                    color: Colors.grey[200],
                  ),
                  child: ENFenJianCell(model: detailController.dataModel.value),
                ),
                // 商品列表
                Visibility(
                  visible: detailController.dataModel.value.spuNumber != null &&
                      detailController.dataModel.value.totalSku != null,
                  child: SectionTitleWidget(
                    title:
                        '拣货清单：${detailController.dataModel.value.spuNumber}个商品，共${detailController.dataModel.value.totalSku}个',
                  ),
                ),
                SizedBox(height: 20.h),
                ...constructShangpingList(),
                SizedBox(height: 50.h),
                buildButtonWidget(
                  width: 343.w,
                  height: 34.h,
                  radius: 2.0,
                  contentColor: Colors.white,
                  bgColor: AppConfig.themeColor,
                  buttonContent: '拣货完成',
                  handelClick: () {
                    WMSDialog.showOperationPromptDialog(context,
                        content: '该操作不可修改, 确认分拣完成?', handle: () {
                      enSortingCompleted();
                    });

                    // Get.to(() => ENFenJianPage());
                  },
                ),
              ],
            )),
      ),
    );
  }
}
