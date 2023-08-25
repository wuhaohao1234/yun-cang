// 临存 已出库页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合

import 'package:wms/views/customer/storage/storage_lincun_cell_widget.dart';
import 'cs_lincun_detail_page.dart';

class CSLinCunChuKuList extends StatefulWidget {
  @override
  State<CSLinCunChuKuList> createState() => _CSLinCunChuKuListState();
}

class _CSLinCunChuKuListState extends State<CSLinCunChuKuList> {
  List linCunChuKuList = [];
  int pageNum = 1;
  bool canMore = true;
  void initState() {
    super.initState();
    requestData();
  }

  Future<void> onRefresh() async {
    setState(() {
      pageNum = 1;
    });
    await requestData();
  }

  Future<void> onLoad() async {
    if (canMore) {
      setState(() {
        pageNum += 1;
        EasyLoadingUtil.showMessage(message: "加载更多");
        requestData();
      });
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }

//已出库1
  Future<bool> requestData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().csTemporaryExistenceList(
      pageSize: AppConfig.pageSize,
      pageNum: pageNum,
      status: 1,
      orderName: '',
    );
    final data = res["data"];
    final total = res["total"];
    setState(() {
      if (pageNum == 1) {
        linCunChuKuList = data;
      } else {
        linCunChuKuList.addAll(data);
      }
      if (linCunChuKuList.length == total) {
        // 可以加载更多
        canMore = false;
      } else {
        // 不可以加载更多
        canMore = true;
      }
      print("共计 $total, 目前${linCunChuKuList.length}");
      EasyLoadingUtil.hidden();
    });
     return true;
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
        child: linCunChuKuList.length != 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CSLinCunDetailPage(
                            prepareOrderId:
                                linCunChuKuList[index].prepareOrderId,
                            status: 1,
                          ),
                        );
                      },
                      child: StorageLinCunCellWidget(
                        model: linCunChuKuList[index],
                        status: 1,
                      ));
                },
                itemCount: linCunChuKuList.length,
              )
            : Center(child: Text('暂无数据')),
      ),
    );
  }
}
