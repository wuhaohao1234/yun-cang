import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/customer/mine/moneys_log_cell.dart';

class CSStorageAccountPage extends StatefulWidget {
  final String yearMonth;
  const CSStorageAccountPage({Key key, this.yearMonth = ''}) : super(key: key);

  @override
  CSStorageAccountPageState createState() => CSStorageAccountPageState();
}

class CSStorageAccountPageState extends State<CSStorageAccountPage> {
  String yearMonth; //时间筛选
  List moneyLogList = [];
  int pageNum = 1;
  bool canMore = true;

  void initState() {
    super.initState();
    onRefresh(newYearMonth: widget.yearMonth);
  }

  Future<void> onRefresh({newYearMonth}) async {
    setState(() {
      //重置分页相关
      pageNum = 1;
      canMore = true;

      // 对两个要获取数据的变量进行初始化

      if (newYearMonth != null) {
        yearMonth = newYearMonth;
      }

      //拿数据
      requestData(updatedYearMonth: yearMonth);
    });
  }

  Future<void> onLoad() async {
    if (canMore) {
      setState(() {
        pageNum += 1;
        EasyLoadingUtil.showMessage(message: "加载更多");

        // 这里使用已经搞好的日期即可
        requestData(updatedYearMonth: yearMonth);
      });
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }

  Future requestData({updatedYearMonth}) async {
    print("当前新日期: $updatedYearMonth");
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    final res = await HttpServices().shopMoneysLog(
      dateTime: updatedYearMonth,
      pageSize: AppConfig.pageSize,
      pageNum: pageNum,
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
        moneyLogList = [];
      });

      // Get.to(() => CSYbrkTabPage());
    } else {
      setState(() {
        if (pageNum == 1) {
          moneyLogList = data;
        } else {
          moneyLogList.addAll(data);
        }
        if (moneyLogList.length == total) {
          // 可以加载更多
          canMore = false;
        } else {
          // 不可以加载更多
          canMore = true;
        }
        print("共计 $total, 目前${moneyLogList.length}");
        EasyLoadingUtil.hidden();
      });
    }
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
        child: moneyLogList.length != 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return MoneysLogCell(
                    model: moneyLogList[index],
                  );
                },
                itemCount: moneyLogList.length,
              )
            : Center(child: Text('暂无数据～')),
      ),
    );
  }
}
