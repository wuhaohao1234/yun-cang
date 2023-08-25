/*
* 客户端入-仓储管理模块-异常件页面
* */
import 'package:wms/customer/common.dart'; //页面通用依赖集合

import 'package:wms/views/customer/storage/storage_ycj_cell_widget.dart';

import 'cs_ycd_detail_page.dart';

class CSYcjPage extends StatefulWidget {
  @override
  _CSYcjPageState createState() => _CSYcjPageState();
}

class _CSYcjPageState extends State<CSYcjPage> {
  List ycjList = [];
  int pageNum = 1;
  var dateTime = WMSUtil.getCurrentDate();
  bool canMore = true;
  void initState() {
    super.initState();
    requestData('');
  }

  Future<void> onRefresh() async {
    setState(() {
      pageNum = 1;
    });
    await requestData(dateTime);
  }

  Future<void> onLoad() async {
    if (canMore) {
      setState(() {
        pageNum += 1;
        EasyLoadingUtil.showMessage(message: "加载更多");
        requestData(dateTime);
      });
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }

  Future<bool> requestData(dateTime) async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().getExceptionOrderList(
      pageSize: AppConfig.pageSize,
      pageNum: pageNum,
      date: dateTime,
    );
    final data = res["data"];
    final total = res["total"];
    setState(() {
      if (pageNum == 1) {
        ycjList = data;
      } else {
        ycjList.addAll(data);
      }
      if (ycjList.length == total) {
        // 可以加载更多
        canMore = false;
      } else {
        // 不可以加载更多
        canMore = true;
      }
      print("共计 $total, 目前${ycjList.length}");
      EasyLoadingUtil.hidden();
    });
     return true;
  }

  @override
  Widget build(BuildContext context) {
    void openPicker(BuildContext context) {
      setUpWidget(
        context,
        PickerTimeWidget(
          item: dateTime,
          callback: (String data) async {
            dateTime = data;
            await requestData(dateTime);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '异常件',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            children: [
              WMSDateSection(
                data: dateTime,
                callback: () => openPicker(context),
              ),
              Expanded(
                child: RefreshView(
                  header: MaterialHeader(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                  onRefresh: onRefresh,
                  onLoad: onLoad,
                  child: ycjList.length != 0
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => CSYcdDetailPage(
                                      exceptionOrderId:
                                          ycjList[index].exceptionOrderId,
                                    ));
                              },
                              child: StorageYcjCellWidget(
                                model: ycjList[index],
                              ),
                            );
                          },
                          itemCount: ycjList.length,
                        )
                      : Center(child: Text("暂无数据")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
