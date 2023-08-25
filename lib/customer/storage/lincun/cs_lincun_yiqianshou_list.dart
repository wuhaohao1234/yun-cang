// 临存 已签收页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合

import 'package:wms/views/customer/storage/storage_lincun_cell_widget.dart';
import 'cs_lincun_detail_page.dart';
import 'cs_lincun_chuku_post_page.dart';

class CSLinCunQianShouList extends StatefulWidget {
  @override
  State<CSLinCunQianShouList> createState() => _CSLinCunQianShouListState();
}

class _CSLinCunQianShouListState extends State<CSLinCunQianShouList> {
  List linCunQianShouList = [];
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

//已签收0
  Future<bool> requestData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().csTemporaryExistenceList(
      pageSize: AppConfig.pageSize,
      pageNum: pageNum,
      status: 0,
      orderName: '',
    );
    final data = res["data"];
    final total = res["total"];
    setState(() {
      if (pageNum == 1) {
        linCunQianShouList = data;
      } else {
        linCunQianShouList.addAll(data);
      }
      if (linCunQianShouList.length == total) {
        // 可以加载更多
        canMore = false;
      } else {
        // 不可以加载更多
        canMore = true;
      }
      print("共计 $total, 目前${linCunQianShouList.length}");
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
        child: linCunQianShouList.length != 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CSLinCunDetailPage(
                            prepareOrderId:
                                linCunQianShouList[index].prepareOrderId,
                            status: 0,
                          ),
                        );
                      },
                      child: StorageLinCunCellWidget(
                          showChuKuButton: true,
                          model: linCunQianShouList[index],
                          status: 0,
                          buttonCallback: () {
                            print("cool");
                            print(linCunQianShouList[index]);
                            Get.to(() => CSLinCunChuKuPostPage(
                                orderId:
                                    linCunQianShouList[index].prepareOrderId,
                                model: linCunQianShouList[index])).then((value) {
                                  requestData();
                            });
                          }));
                },
                itemCount: linCunQianShouList.length,
              )
            : Center(child: Text('暂无数据')),
      ),
    );
  }
}
