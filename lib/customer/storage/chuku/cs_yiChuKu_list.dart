// 已出库页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/customer/storage/storage_chuku_cell_widget.dart';
import 'cs_yichuku_detail_page.dart';

class CSYiChuKuList extends StatefulWidget {
  final String monthOutTime;
  const CSYiChuKuList({Key key, this.monthOutTime}) : super(key: key);

  @override
  State<CSYiChuKuList> createState() => _CSYiChuKuListState();
}

class _CSYiChuKuListState extends State<CSYiChuKuList> {
  List yckList = [];
  int pageNum = 1;
  bool canMore = true;
  void initState() {
    super.initState();
    requestData('');
  }

  Future<void> onRefresh() async {
    setState(() {
      pageNum = 1;
    });
    await requestData(widget.monthOutTime);
  }

  Future<void> onLoad() async {
    if (canMore) {
      setState(() {
        pageNum += 1;
        EasyLoadingUtil.showMessage(message: "加载更多");
        requestData(widget.monthOutTime);
      });
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }

  Future<bool> requestData(dateTime) async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().getAlreadyList(
      pageSize: AppConfig.pageSize,
      pageNum: pageNum,
      outStoreName: '',
      monthOutTime: dateTime,
    );
    final data = res["data"];
    final total = res["total"];
    setState(() {
      if (pageNum == 1) {
        yckList = data;
      } else {
        yckList.addAll(data);
      }
      if (yckList.length == total) {
        // 可以加载更多
        canMore = false;
      } else {
        // 不可以加载更多
        canMore = true;
      }
      print("共计 $total, 目前${yckList.length}");
      EasyLoadingUtil.hidden();
    });
     return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:RefreshView(
        header: MaterialHeader(
          valueColor: AlwaysStoppedAnimation(Colors.black),
        ),
        onRefresh: onRefresh,
        onLoad: onLoad,
        child: yckList.length != 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => CSYiChuKuDetailPage(
                          wmsOutStoreId: yckList[index].wmsOutStoreId,
                        ),
                      );
                    },
                    child: StorageChuKuCellWidget(
                        model: yckList[index], chukuType: 'already'),
                  );
                },
                itemCount: yckList.length,
              )
            : Center(
                child: Text('暂无数据'),
              ),
      ),
    );
  }
}
