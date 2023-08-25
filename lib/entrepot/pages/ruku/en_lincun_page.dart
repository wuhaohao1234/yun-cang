// 临存列表
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/utils/jk_over_scroll_behavior.dart';
import 'package:wms/views/entrenpot/ruku/en_ybrkd_cell.dart';
import 'en_lincun_detail_page.dart';
import '../en_main_page.dart';

class ENLinCunPage extends StatefulWidget {
  @override
  State<ENLinCunPage> createState() => _ENLinCunPageState();
}

class _ENLinCunPageState extends State<ENLinCunPage> {
  List linCunList = [];
  int pageNum = 1;
  bool canMore = true;
  TextEditingController searchContent;
  void initState() {
    super.initState();
    searchContent = TextEditingController(text: '');
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
    final res = await HttpServices().enTemporaryExistenceOrderList(
      // pageSize: AppConfig.pageSize,
      pageSize: 10,
      pageNum: pageNum,
    );
    final data = res["data"];
    final total = res["total"];
    setState(() {
      if (pageNum == 1) {
        linCunList = data;
      } else {
        linCunList.addAll(data);
      }
      if (linCunList.length == total) {
        // 可以加载更多
        canMore = false;
      } else {
        // 不可以加载更多
        canMore = true;
      }
      print("共计 $total, 目前${linCunList.length}");
      EasyLoadingUtil.hidden();
    });
  }

  //搜物流单号
  void requestmMail() {
    EasyLoadingUtil.showLoading();
    HttpServices.enQueryByMailNo(
        mailNo: searchContent.text,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          setState(() {
            linCunList = [];
            linCunList = data;

            EasyLoadingUtil.hidden();
          });
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
          setState(() {
            linCunList = [];
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '临存列表',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => ENMainPage());
          },
        ),
      ),
      body: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(children: [
                Container(
                  color: Colors.white,
                  child: InputSearchBarWidget(
                      searchHinterText: '请输入物流单号',
                      submitCallback: (value) {
                        searchContent.text = value;
                        requestmMail();
                      },
                      cancelCallback: () {
                        searchContent.text = '';
                        requestData();
                      }),
                ),
                Expanded(
                  child: linCunList.length > 0
                      ? RefreshView(
                          header: MaterialHeader(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                          onLoad: onLoad,
                          onRefresh: onRefresh,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ENYbrkdCell(
                                index: index,
                                model: linCunList[index],
                                callback: () {
                                  print("点击了临存  $index");
                                  print(linCunList);
                                  print(linCunList[index].orderId);
                                  Get.to(
                                    () => ENLinCunDetailPage(
                                      orderId: linCunList[index].orderId,
                                      ybrkModel: linCunList[index],
                                    ),
                                  );
                                },
                              );
                            },
                            itemCount: linCunList.length,
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 100),
                          alignment: Alignment.center,
                          child: WMSText(content: '暂无数据～')),
                ),
              ]))),
    );
  }
}
