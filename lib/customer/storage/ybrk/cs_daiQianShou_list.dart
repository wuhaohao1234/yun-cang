// 预约入库页面 -待签收status=‘0’
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/customer/storage/storage_ybrk_cell_widegt.dart';
import 'cs_ybd_detail_page.dart';
import 'cs_post_ybrk_page.dart';
import 'cs_ybrk_tab_page.dart';
import 'package:wms/common/baseWidgets/wms_dialog.dart';

class CSDaiQianShouList extends StatefulWidget {
  final int depotId;
  final String yearMonth;
  const CSDaiQianShouList({Key key, this.depotId, this.yearMonth = ''})
      : super(key: key);

  @override
  CSDaiQianShouListState createState() => CSDaiQianShouListState();
}

class CSDaiQianShouListState extends State<CSDaiQianShouList> {
  // 下面两个条件是发起预约入库单请求的必要条件
  int depotId; //哪个仓库
  String yearMonth; //时间筛选

  List ybrkList = [];
  int pageNum = 1;
  bool canMore = true;

  void initState() {
    super.initState();
    onRefresh(newDepotId: widget.depotId, newYearMonth: widget.yearMonth);
  }

  Future<void> onRefresh({newDepotId, newYearMonth}) async {
    setState(() {
      //重置分页相关
      pageNum = 1;
      canMore = true;

      // 对两个要获取数据的变量进行初始化
      if (newDepotId != null) {
        depotId = newDepotId;
      }
      if (newYearMonth != null) {
        yearMonth = newYearMonth;
      }

      //拿数据
      requestData(updatedYearMonth: yearMonth, updatedDepotId: depotId);
    });
  }

  Future<void> onLoad() async {
    if (canMore) {
      setState(() {
        pageNum += 1;
        EasyLoadingUtil.showMessage(message: "加载更多");

        // 这里使用已经搞好的日期和仓库即可
        requestData(updatedYearMonth: yearMonth, updatedDepotId: depotId);
      });
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }

  Future requestData({updatedYearMonth, updatedDepotId}) async {
    print("当前新日期: $updatedYearMonth, 当前新depotId: $updatedDepotId");
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    final res = await HttpServices().prepareOrderList(
      date: updatedYearMonth,
      depotId: '$updatedDepotId',
      mailNo: '',
      status: '0',
      pageSize: AppConfig.pageSize.toString(),
      pageNum: pageNum.toString(),
    );
    // 要先写这个处理, 不然怎么下面能走通
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }

    final data = res["data"];
    final total = res["total"];

    if (data.length == 0) {
      EasyLoadingUtil.hidden();
      setState(() {
        ybrkList = [];
      });

      // Get.to(() => CSYbrkTabPage());
    } else {
      setState(() {
        if (pageNum == 1) {
          ybrkList = data;
        } else {
          ybrkList.addAll(data);
        }
        if (ybrkList.length == total) {
          // 可以加载更多
          canMore = false;
        } else {
          // 不可以加载更多
          canMore = true;
        }
        print("共计 $total, 目前${ybrkList.length}");
        EasyLoadingUtil.hidden();
      });
    }
  }

  good(newDepotId) {
    setState(() {
      depotId = newDepotId;
      print("当前depotId 为 $depotId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshView(
        header: MaterialHeader(
          valueColor: AlwaysStoppedAnimation(Colors.black),
        ),
        onRefresh: onRefresh,
        onLoad: onLoad,
        child: ybrkList.length != 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Get.to(() => CSYbdDetailPage(
                              orderId: ybrkList[index].orderId?.toString(),
                              status: "0",
                              tabIndex: 0,
                            ));
                      },
                      child: StorageYbrkCellWidegt(
                          model: ybrkList[index],
                          prepareType: true,
                          tapCallBack: () {
                            // Get.to(() => CSYbrkAddPage());

                            Get.to(() => CSYbrkPostPage(
                                  orderIdName: ybrkList[index].orderIdName,
                                  orderId: ybrkList[index].orderId,
                                  depotId: ybrkList[index].depotId,
                                  orderOperationalRequirements: ybrkList[index]
                                      .orderOperationalRequirements,
                                  prepareOrderInfo: ybrkList[index].toJson(),
                                  httpType: 1, //修改预约入库单
                                ));
                          },
                          cancelCallBack: () {
                            WMSDialog.showOperationPromptDialog(context,
                                content: '该操作不可修改, 确认取消?', handle: () async {
                              var data =
                                  await HttpServices().updataPrepareOrder(
                                orderId: ybrkList[index].orderId,
                                mailNo: ybrkList[index].mailNo,
                                status: '3',
                                logisticsMode: ybrkList[index].logisticsMode,
                                boxTotal: ybrkList[index].boxTotal,
                                remark: ybrkList[index].remark,
                                prepareImgUrl: ybrkList[index].prepareImgUrl,
                              );
                              if (data != false) {
                                EasyLoadingUtil.showMessage(
                                    message: '已取消该预约入库数据');
                                Get.offAll(
                                    () => CSYbrkTabPage(defaultIndex: 0));
                              }
                              // EasyLoadingUtil.showLoading(statusText: "...");
                            });
                          }));
                },
                itemCount: ybrkList.length,
              )
            : Center(child: Text('暂无数据～')),
      ),
    );
  }
}
