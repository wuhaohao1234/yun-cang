/*
* 客户端入-仓储管理模块-无主件页面
* */

import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/customer/storage/wuzhudan/cs_wzj_detail_page.dart';
import 'package:wms/views/customer/storage/storage_wzj_cell_widget.dart';

class CSWzjPage extends StatefulWidget {
  @override
  _CSWzjPageState createState() => _CSWzjPageState();
}

class _CSWzjPageState extends State<CSWzjPage> {
  List wzjList = [];
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
    var res = await HttpServices().csWzjList(
      pageSize: AppConfig.pageSize.toString(),
      pageNum: pageNum.toString(),
      date: dateTime,
    );
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    final data = res["data"];
    final total = res["total"];
    if (data == []) {
      EasyLoadingUtil.hidden();
    }
    setState(() {
      if (pageNum == 1) {
        wzjList = data;
      } else {
        wzjList.addAll(data);
      }
      if (wzjList.length == total) {
        // 可以加载更多
        canMore = false;
      } else {
        // 不可以加载更多
        canMore = true;
      }
      print("共计 $total, 目前${wzjList.length}");
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
          content: '无主件',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: WMSDateSection(
                      data: dateTime,
                      callback: () => openPicker(context),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: RefreshView(
                  header: MaterialHeader(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                  onRefresh: onRefresh,
                  onLoad: onLoad,
                  child: wzjList.length != 0
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => CSWzjDetailPage(
                                      id: wzjList[index].id,
                                    ));
                              },
                              child: StorageWzjCellWidget(
                                model: wzjList[index],
                              ),
                            );
                          },
                          itemCount: wzjList.length,
                        )
                      : Center(child: Text('暂无数据')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
