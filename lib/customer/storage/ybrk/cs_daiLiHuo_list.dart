// 预约入库页面 -已理货status='1'
import 'package:wms/customer/common.dart'; //页面通用依赖集合

import 'package:wms/views/customer/storage/storage_ybrk_cell_widegt.dart';
import 'cs_ybd_detail_page.dart';

class CSDaiLihuoList extends StatefulWidget {
  final int depotId;
  final String yearMonth;
  const CSDaiLihuoList({Key key, this.depotId, this.yearMonth = ''})
      : super(key: key);

  @override
  CSDaiLihuoListState createState() => CSDaiLihuoListState();
}

class CSDaiLihuoListState extends State<CSDaiLihuoList> {
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

  Future<bool> requestData({updatedYearMonth, updatedDepotId}) async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().prepareOrderList(
      date: updatedYearMonth,
      depotId: '$updatedDepotId',
      mailNo: '',
      status: '1',
      pageSize: AppConfig.pageSize.toString(),
      pageNum: pageNum.toString(),
    );
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
    return true;
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
                              status: "1",
                              tabIndex: 1,
                            ));
                      },
                      child: StorageYbrkCellWidegt(
                        model: ybrkList[index],
                      ));
                },
                itemCount: ybrkList.length,
              )
            : Center(child: Text('暂无数据～')),
      ),
    );
  }
}
