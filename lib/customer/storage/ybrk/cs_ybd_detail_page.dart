/*
* 客户端入-仓储管理模块-预约单详情页面
* */

import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/customer/storage/controllers/cs_ybrk_detail_page_controller.dart';
import 'package:wms/views/commodity_cell_widget.dart';
import 'package:wms/views/commodity_sku_cell_widget.dart';
import 'package:wms/views/commodity_table_head_cell_widget.dart';
import 'cs_ybrk_tab_page.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';
import 'package:wms/entrepot/pages/en_logistics_page.dart';

class CSYbdDetailPage extends StatelessWidget {
  final String orderId;
  final String status;
  final int tabIndex;

  const CSYbdDetailPage({Key key, this.orderId, this.status, this.tabIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CSYbrkDetailPageController pageController =
        Get.put(CSYbrkDetailPageController(orderId, status));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '预约单详情',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            Get.delete<CSYbrkDetailPageController>();
            Get.offAll(() => CSYbrkTabPage(defaultIndex: tabIndex));
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: ScrollConfiguration(
            behavior: JKOverScrollBehavior(),
            child: RefreshView(
              header: MaterialHeader(
                valueColor: AlwaysStoppedAnimation(Colors.black),
              ),
              onRefresh: pageController.onRefresh,
              child: ListView(
                children: [
                  SectionTitleWidget(title: '基础信息'),
                  Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: infoSectionWidget(pageController, context)),
                ],
              ),
            )),
      ),
    );
  }

  Widget infoSectionWidget(
      CSYbrkDetailPageController pageController, BuildContext context) {

    List<Widget> constructShangpingList() {
      List<Widget> list = [];
      for (var index = 0;
          index < pageController.commodityList.length;
          index++) {

        print("commodityList-${pageController.commodityList[index]}");
        list.add(
          Column(
            children: [
              // 这里的单位是单个商品
              CommodityCellWidget(
                picturePath:
                    pageController.commodityList[index]['picturePath'] ?? '',
                name: pageController.commodityList[index]['commodityName'],
                brandName: pageController.commodityList[index]['brandName'],
                stockCode:
                    pageController.commodityList[index]['stockCode'] ?? '',
              ),
              // 表头
              buildTableHeadWdidget(['尺码/规格', '条形码(sku)', '预约数量']),
              // // 这里是商品的列表
              buildSKuInfoWdidget(
                list: pageController.commodityList[index]
                    ['sysPrepareOrderSpuList'],
                skuCodeShow: true,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }
      return list;
    }

    return Container(child: Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            color: Colors.grey[100],
            child: Column(children: [
              infoItemWidget(
                  title: '预约入库单号：',
                  content: pageController.dataModel.value.prepareOrderCode ??
                      pageController.dataModel.value.instoreOrderCode),
              infoItemWidget(
                  title: '预约箱数：',
                  content:
                      pageController.dataModel.value.boxTotal?.toString() ??
                          ''),
              infoItemWidget(
                  title: '预约总数：',
                  content:
                      pageController.dataModel.value.skusTotal?.toString() ??
                          ''),
              Visibility(
                visible: status != "0",
                child: infoItemWidget(
                    title: '实收总数：',
                    content: pageController.dataModel.value.skusTotalFact
                            ?.toString() ??
                        ''),
              ),
              Visibility(
                visible: status != "0",
                child: infoItemWidget(
                    title: '已理货数：',
                    content:
                        pageController.dataModel.value.skusTotal?.toString() ??
                            ''),
              ),
              infoItemWidget(
                title: '处理模式：',
                content: WMSUtil.orderOperationalRequirementsStringChange(
                    pageController.dataModel.value.orderOperationalRequirements
                        .toString()),
              ),
              infoItemWidget(
                title: '快递单号：',
                innerWidget: Container(
                    height: 20,
                    child:
                        // TextField(
                        //     maxLines: 1,
                        //     cursorColor: Colors.black,
                        //     // onEditingComplete: onTapCommitHandle,
                        //     onSubmitted: (value) {
                        //       pageController.onTapCommitHandle();
                        //     },
                        //     controller: pageController.mailNo,
                        //     decoration: InputDecoration(
                        //       enabledBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(color: Colors.grey),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //           borderSide:
                        //               BorderSide(color: Colors.black)),
                        //       suffixIcon: GestureDetector(
                        //           onTap: () {
                        //             pageController.onTapCommitHandle();
                        //           },
                        //           child: Icon(
                        //               Icons.check_circle_outline_rounded,
                        //               color: Colors.green,
                        //               size: 18.w)),
                        //       contentPadding:
                        //           EdgeInsets.symmetric(horizontal: 10.r),
                        //       border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(0),
                        //           borderSide: BorderSide(
                        //               color: Colors.black, width: 0.1)),
                        //       hintText: '',
                        //       hintStyle: TextStyle(fontSize: 8.sp),
                        //     ),
                        //   )
                        // // : Text(
                        //     pageController.dataModel.value.mailNo ?? "",
                        //     style: TextStyle(fontSize: 14.sp),
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(pageController.dataModel.value.mailNo ?? "",
                                style: TextStyle(fontSize: 14.sp)),
                            SizedBox(width: 10.w),
                            Visibility(
                              visible:
                                  pageController.dataModel.value.status == '0',
                              child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      // context: new BuildContext( context),
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) =>
                                          wvDialog(
                                        widget: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h, horizontal: 30.w),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.topCenter,
                                                child: Text(
                                                  '请输入快递单号',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(height: 20.0),
                                              TextField(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    pageController.mailNo,
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
                                                        pageController.mailNo
                                                            .text = value;
                                                      });
                                                    },
                                                    child: SvgPicture.asset(
                                                      'assets/svgs/scan.svg',
                                                      width: 15.w,
                                                    ),
                                                  ),
                                                  hintText: '请输入修改后的快递单号',
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 4.0,
                                                          horizontal: 10.0),
                                                ),
                                              ),
                                              SizedBox(height: 20.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  WMSButton(
                                                    title: '取消',
                                                    width: 120.w,
                                                    bgColor: Colors.transparent,
                                                    textColor: Colors.black,
                                                    showBorder: true,
                                                    callback: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                  ),
                                                  WMSButton(
                                                    title: '确认单号',
                                                    width: 120.w,
                                                    bgColor:
                                                        AppConfig.themeColor,
                                                    textColor: Colors.white,
                                                    showBorder: true,
                                                    callback: () async {
                                                      // widget.onDeleteFunc(widget.skuIndex);
                                                      Navigator.of(context)
                                                          .pop(true);
                                                      pageController
                                                          .onTapCommitHandle();
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
                                  child: Icon(Icons.edit,
                                      color: Colors.black, size: 18.w)),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ENLogisticsPage(
                                dataCode:
                                    pageController.dataModel.value.mailNo));
                          },
                          child: FittedBox(
                            child: stateWidget(
                              title: '查看物流',
                              bgColor: Colors.deepOrangeAccent,
                              contentColor: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )),

                // SizedBox(
                //   height: 20.h,
                //   child: stateWidget(
                //       title: WMSUtil.statusStringChange(
                //           pageController.dataModel.value?.status),
                //       bgColor: pageController.dataModel.value?.status == '2'
                //           ? Colors.black
                //           : Colors.deepOrangeAccent),
                // ),
              )
            ]),
          ),
          ...constructShangpingList(),
          Container(
            alignment: Alignment.centerRight,
            child: WMSText(
              bold: true,
              content:
                  '共 ${pageController.commodityList.length.toString()} 个商品，入库总数量 ${pageController.dataModel.value.skusTotalFact.toString()} ',
              textAlign: TextAlign.right,
            ),
          )
        ],
      );
    }));
  }
}
