// 待收货的列表界面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/views/entrenpot/ruku/en_ybrkd_cell.dart';
import 'qianshou/en_ybrk_detail_page.dart';
import 'package:wms/views/common/input_search_bar_widget.dart';
import '../ruku/qianshou/en_ybrk_custome_qianshou_page.dart';

class DaiShouhuoList extends StatefulWidget {
  final refresh;

  const DaiShouhuoList({Key key, this.refresh}) : super(key: key);
  @override
  _DaiShouhuoListState createState() => _DaiShouhuoListState();
}

class _DaiShouhuoListState extends State<DaiShouhuoList> {
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
    HttpServices.enPrepareOrderList(
        // pageSize: '${AppConfig.pageSize}',
        pageSize: '10',
        pageNum: pageNum.toString(),
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

  //搜物流单号
  void requestmMail() {
    EasyLoadingUtil.showLoading();
    HttpServices.enQueryByMailNo(
        mailNo: searchContent.text,
        success: (data, total) {
          EasyLoadingUtil.hidden();
          setState(() {
            dataSource = [];
            dataSource = data;

            EasyLoadingUtil.hidden();
          });
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
          setState(() {
            dataSource = [];
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    // ENYbrkPageController pageController = Get.put(ENYbrkPageController());
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
                    requestmMail();
                  },
                  cancelCallback: () {
                    searchContent.text = '';
                    requestData();
                  }),
            ),
            Expanded(
              child: dataSource.length > 0
                  ? RefreshView(
                      header: MaterialHeader(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                      onRefresh: onRefresh,
                      onLoad: onLoad,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ENYbrkdCell(
                            index: index,
                            model: dataSource[index],
                            callback: () {
                              Get.to(
                                () => ENYbrkDetailPage(
                                  orderId: dataSource[index]?.orderId,
                                  ybrkModel: dataSource[index],
                                ),
                              ).then((value) {
                                widget.refresh();
                                requestData();
                              });
                            },
                          );
                        },
                        itemCount: dataSource.length,
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 60.h),
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ENYbrkSignNoForecastPage(mailNo: searchContent.text),
                          );
                        },
                        child: Column(children: [
                          SvgPicture.asset(
                            'assets/svgs/nofound.svg',
                            width: 150.w,
                          ),
                          SizedBox(height: 20.h),
                          Text("无数据,点击进入无预约签收页面")
                        ]),
                      )),
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
