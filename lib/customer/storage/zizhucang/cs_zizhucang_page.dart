/*
* 客户端入-仓储管理模块-自主仓列表（我的）
* */

import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/customer/storage/cs_zizhu_good_cell.dart';
import 'cs_zizhucang_detail_page.dart';

class CSZiZhuCangPage extends StatefulWidget {
  @override
  _CSZiZhuCangPageState createState() => _CSZiZhuCangPageState();
}

class _CSZiZhuCangPageState extends State<CSZiZhuCangPage> {
  List ziZhuCangList = [];
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

  Future requestData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    final res = await HttpServices().newsOrderList(
      pageSize: AppConfig.pageSize,
      pageNum: pageNum,
    );
    final data = res["data"];
    final total = res["total"];
    setState(() {
      if (pageNum == 1) {
        ziZhuCangList = data;
      } else {
        ziZhuCangList.addAll(data);
      }
      if (ziZhuCangList.length == total) {
        // 可以加载更多
        canMore = false;
      } else {
        // 不可以加载更多
        canMore = true;
      }
      print("共计 $total, 目前${ziZhuCangList.length}");
      EasyLoadingUtil.hidden();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '自主仓新品申请列表',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            children: [
              Expanded(
                child: RefreshView(
                  header: MaterialHeader(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                  onRefresh: onRefresh,
                  onLoad: onLoad,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => CSZiZhuCangDetailPage(
                              id: ziZhuCangList[index]['id'],
                              model: ziZhuCangList[index]));
                        },
                        child: CSZiZhuCangGoodCell(
                          model: ziZhuCangList[index],
                        ),
                      );
                    },
                    itemCount: ziZhuCangList.length,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
