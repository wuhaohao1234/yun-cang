// 待理货的列表界面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/views/entrenpot/ruku/en_daishangjia_cell.dart';
import './ShangJia/en_ShangJiaDetails.dart';
// import 'en_ybrk_custome_qianshou_page.dart';
import 'package:wms/views/common/input_search_bar_widget.dart';

class DaiShangJiaList extends StatefulWidget {
  // const DaiLihuoList({Key? key}) : super(key: key);
final refresh;

  const DaiShangJiaList({Key key, this.refresh}) : super(key: key);
  @override
  _DaiShangJiaListState createState() => _DaiShangJiaListState();
}

class _DaiShangJiaListState extends State<DaiShangJiaList> {
  var pageNum = 1;
  var canMore = true;
  var dataSource = [];
  TextEditingController searchContent;
  @override
  void initState() {
    super.initState();
    searchContent = TextEditingController(text: '');
    onRefresh();
  }

  requestData() async {
    EasyLoadingUtil.showLoading();
    HttpServices.getselStayTally(
        // pageSize: '${AppConfig.pageSize}',
        pageSize: '10',
        pageNum: pageNum.toString(),
        status: '3',
        instoreOrderCode:searchContent.text,
        success: (data, total) {
          setState(() {
            if (pageNum == 1) {
              dataSource = data;
            } else {
              dataSource.addAll(data);
            }

            if (dataSource.length == total) {
              // 可以加载更多
              canMore = false;
            } else {
              // 不可以加载更多
              canMore = true;
            }
            print("共计 $total, 目前${dataSource.length}");
          });

          EasyLoadingUtil.hidden();
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
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


  @override
  Widget build(BuildContext context) {
    // ENSjdPageController pageController = Get.put(ENSjdPageController());
    return Container(
        child: ScrollConfiguration(
      behavior: JKOverScrollBehavior(),
      child: Container(
        child: Column(
          children: [
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
            Expanded(
              child: RefreshView(
                header: MaterialHeader(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                ),
                onRefresh: onRefresh,
                onLoad: onLoad,
                child: dataSource.length > 0
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          final model = dataSource[index];
                          return ENDaiShangJiaCell(
                            index: index,
                            model: model,
                            callback: () {
                              print("model?.userCode${model?.userCode}");
                              Get.to(
                                () => ENShangJiaDetailsPage(
                                  resDepotPosition: model?.depotPosition,
                                  instoreOrderId: model?.instoreOrderId,
                                  prepareOrderId: model?.prepareOrderId,
                                  userCode: model?.userCode,
                                ),
                              ).then((value) {
                                if (value == true) {
                                  requestData();
                                  print(requestData());
                                }
                                requestData();
                                widget.refresh();
                              });
                              // Get.to(() => ENYbrkSignNoForecastPage());
                            },
                          );
                        },
                        itemCount: dataSource.length,
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        alignment: Alignment.center,
                        child: WMSText(content: '暂无数据～')),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    searchContent.dispose();
    super.dispose();
  }
}
