// 我的在售 集市
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/customer/controllers/on_sale_controller.dart';
import 'package:wms/views/customer/storage/cs_onsale_commodity_cell_widget.dart';
import 'cs_zaishou_tab_page.dart';

class CSZaiShouList extends StatefulWidget {
  final int type;
  final int index;
  const CSZaiShouList({Key key, this.type,this.index}) : super(key: key);

  @override
  State<CSZaiShouList> createState() => _CSZaiShouListState();
}

class _CSZaiShouListState extends State<CSZaiShouList> with AutomaticKeepAliveClientMixin {
  OnSaleController cellController = Get.find();

  // List onSaleList = [];
  int pageNum = 1;



  void initState() {
    super.initState();
    cellController.setPageNum(num: pageNum);
    cellController.requestData(type: widget.type,index:widget.index);
  }

  Future<void> onRefresh() async {
    setState(() {
      pageNum = 1;
    });
    cellController.setPageNum(num: pageNum);
    await cellController.requestData(type: widget.type,index:widget.index);
  }

  Future<void> onLoad() async {
    if (cellController.canMore.value) {
      setState(() {
        pageNum += 1;
        cellController.setPageNum(num: pageNum);
        EasyLoadingUtil.showMessage(message: "加载更多");
        cellController.requestData(type: widget.type,index:widget.index);
      });
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }

  // Future<bool> requestData() async {
  //   OrderCellController cellController = Get.find();
  //   print("widget.search Str ${cellController.searchStr}");
  //   // 请求特定页面的数据
  //   EasyLoadingUtil.showLoading();
  //   var res = await HttpServices().csOnSaleList(
  //     pageSize: AppConfig.pageSize,
  //     pageNum: pageNum,
  //     type: widget.type,
  //   );
  //   final data = res["data"];
  //   final total = res["total"];
  //   setState(() {
  //     if (pageNum == 1) {
  //       onSaleList = data;
  //     } else {
  //       onSaleList.addAll(data);
  //     }
  //     if (onSaleList.length == total) {
  //       // 可以加载更多
  //       canMore = false;
  //     } else {
  //       // 不可以加载更多
  //       canMore = true;
  //     }
  //     print("共计 $total, 目前${onSaleList.length}");
  //     EasyLoadingUtil.hidden();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Visibility(
              visible: widget.type == 3,
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text("转售：指在集市中转售其他用户商品，在小程序售卖。"),
              )),
          Expanded(
              child: Obx(() => RefreshView(
                    header: MaterialHeader(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    ),
                    onRefresh: onRefresh,
                    onLoad: onLoad,
                    child: cellController.onSaleList[widget.index].length != 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    // Get.to(
                                    //   () => CSLinCunDetailPage(
                                    //     prepareOrderId:
                                    //         linCunQianShouList[index].prepareOrderId,
                                    //   ),
                                    // );
                                  },
                                  child: CSOnSaleCommodityWidget(
                                      model: cellController.onSaleList[widget.index][index],
                                      type: widget.type,
                                      index:widget.index,
                                      callback: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) =>
                                              wvDialog(
                                            widget: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20.h,
                                                  horizontal: 24.w),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Text(
                                                      '下架提示',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      '您确定要下架此商品吗？',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ),
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
                                                        bgColor:
                                                            Colors.transparent,
                                                        textColor: Colors.black,
                                                        showBorder: true,
                                                        callback: () {
                                                          Navigator.of(context)
                                                              .pop(false);
                                                        },
                                                      ),
                                                      WMSButton(
                                                        title: '确认',
                                                        width: 120.w,
                                                        bgColor: AppConfig
                                                            .themeColor,
                                                        textColor: Colors.white,
                                                        showBorder: true,
                                                        callback: () async {
                                                          // widget.onDeleteFunc(widget.skuIndex);
                                                          Navigator.of(context)
                                                              .pop(true);
                                                          var data = await HttpServices().csOffShelf(
                                                              stringStoreIds:
                                                                  cellController
                                                                      .onSaleList[widget.index][
                                                                          index]
                                                                      .stringStoreIds,
                                                              type:
                                                                  widget.type);
                                                          if (data != false) {
                                                            // EasyLoadingUtil.showLoading(statusText: "...");
                                                            EasyLoadingUtil
                                                                .showMessage(
                                                                    message:
                                                                        '已下架商品');
                                                            //如果1小程序 跳转index1 如果2集市 跳转0 如果3 转售 跳转2
                                                            Get.offAll(() =>
                                                                CSZaiShouTabPage(
                                                                    defaultIndex: widget.type ==
                                                                            1
                                                                        ? 1
                                                                        : widget.type ==
                                                                                2
                                                                            ? 0
                                                                            : 2));
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
                                      }
                                      // buttonCallback: () {
                                      //   print("cool");
                                      //   print(onSaleList[index]);
                                      // Get.to(() => CSLinCunChuKuPostPage(
                                      //     orderId:
                                      //         linCunQianShouList[index].prepareOrderId,
                                      //     model: linCunQianShouList[index])
                                      // );
                                      // }
                                      ));
                            },
                            itemCount: cellController.onSaleList[widget.index].length,
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(child: Text('暂无数据')),
                          ),
                  )))
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
