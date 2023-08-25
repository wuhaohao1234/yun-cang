// 无主单列表
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/views/entrenpot/ruku/en_wzd_cell.dart';
import 'en_wzd_detail_page.dart';
import '../en_main_page.dart';

class ENWuZhuDanPage extends StatefulWidget {
  @override
  State<ENWuZhuDanPage> createState() => _ENLinCunPageState();
}

class _ENLinCunPageState extends State<ENWuZhuDanPage> {
  List wuZhuDanList = [];
  int pageNum = 1;
  var canMore = true;
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

  Future<bool> requestData() async {
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().enOwnerLessList(
      mailNo: searchContent.text ?? '',
      pageSize: 10,
      pageNum: pageNum,
    );
    if (res['result']) {
      print(res['result']);
      setState(() {
        if (pageNum == 1) {
          wuZhuDanList = res['data']['data'];
        } else {
          wuZhuDanList.addAll(res['data']['data']);
        }

        if (wuZhuDanList.length == res['data']['total']) {
          // 可以加载更多
          canMore = false;
        } else {
          // 不可以加载更多
          canMore = true;
        }
        print("共计 $res['data']['total'], 目前${wuZhuDanList.length}");
      });

      EasyLoadingUtil.hidden();
      return true;
    } else {
      ToastUtil.showMessage(message: res['data']);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '无主单列表',
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
                        requestData();
                      },
                      cancelCallback: () {
                        searchContent.text = '';
                        requestData();
                      }),
                ),

                //待修改TODO
                Expanded(
                  child: wuZhuDanList.length > 0
                      ? RefreshView(
                          onLoad: onLoad,
                          onRefresh: onRefresh,
                          header: MaterialHeader(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ENWzdCell(
                                model: wuZhuDanList[index],
                                callback: () {
                                  print("点击了无主单  $index");

                                  print(wuZhuDanList);
                                  print(wuZhuDanList[index].orderId);
                                  Get.to(
                                    () => ENWzdDetailPage(
                                      id: wuZhuDanList[index].id,
                                      dataModel: wuZhuDanList[index],
                                    ),
                                  );
                                },
                              );
                            },
                            itemCount: wuZhuDanList.length,
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
