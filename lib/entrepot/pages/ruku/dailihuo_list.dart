// 待理货的列表界面
import 'package:wms/views/entrenpot/ruku/en_rkd_cell.dart';
// import 'package:wms/entrepot/controllers/ruku/en_rkd_page_controller.dart';
import 'lihuo/en_dailihuo_complete_page.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
//页面通用依赖集合
import 'package:wms/views/common/input_search_bar_widget.dart';

class DaiLihuoList extends StatefulWidget {
  final refresh;

  const DaiLihuoList({Key key, this.refresh}) : super(key: key);
  @override
  _DaiLihuoListState createState() => _DaiLihuoListState();
}

class _DaiLihuoListState extends State<DaiLihuoList> {
  var pageNum = 1;
  var canMore = true;
  var dataSource = [];
  TextEditingController searchContent;
  var orderRequirementsList = [
    {"require": '', 'text': '全部'},
    {"require": '1', 'text': '理货点数'},
    {"require": '0', 'text': '拍照质检'},
  ];
  var requirements='';

  @override
  void initState() {
    super.initState();
    searchContent = TextEditingController(text: '');
    onRefresh();
  }

  requestData(require) async {
    EasyLoadingUtil.showLoading();
    dataSource.clear();
    HttpServices.getselStayTally(
        // pageSize: '${AppConfig.pageSize}',
        pageSize: '10',
        pageNum: pageNum.toString(),
        status: '2',
        instoreOrderCode: searchContent.text,
        inspectionRequirement:require,
        success: (data, total) {
          setState(() {
            var _data = data;
            // var _data = require == null
            //     ? data
            //     : data
            //         .where((element) =>
            //             element.orderOperationalRequirements == require)
            //         .toList();
            if (pageNum == 1) {
              dataSource = _data;
            } else {
              dataSource.addAll(_data);
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
    await requestData(requirements);
  }

  Future<void> onLoad() async {
    if (canMore) {
      setState(() {
        pageNum += 1;
        EasyLoadingUtil.showMessage(message: "加载更多");
        requestData(requirements);
      });
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }

  updateRequirements(index) {
    requirements = orderRequirementsList[index]['require'];

    print('获取${orderRequirementsList[index]['require']}');
    requestData(requirements);
  }


  @override
  Widget build(BuildContext context) {
    // ENRkdPageController pageController = Get.put(ENRkdPageController());
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
                    requestData(requirements);
                  },
                  cancelCallback: () {
                    searchContent.text = '';
                    requestData(requirements);
                  }),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List<Widget>.generate(
                  orderRequirementsList.length,
                  (int index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        pageNum = 1;
                      });
                      updateRequirements(index);
                    },
                    child: Container(
                        width: 80.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.5, color: Color(0xfff2f2f2)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          color: requirements ==
                                  orderRequirementsList[index]['require']
                              ? Colors.white
                              : Color(0xfff2f2f2),
                        ),
                        child: Center(
                            child: WMSText(
                          content: orderRequirementsList[index]['text'],
                          bold: requirements ==
                              orderRequirementsList[index]['require'],
                          color: requirements ==
                                  orderRequirementsList[index]['require']
                              ? Colors.black
                              : Color(0xff666666),
                        ))),
                  )
                ),
              ),
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
                          return DaiLiHuoCell(
                            model: dataSource[index],
                            imgshow: true,
                            callback: () {
                              Get.to(
                                () => ENDaiLihuoCompletePage(
                                  model: dataSource[index],
                                  instoreOrderId:
                                      dataSource[index]?.instoreOrderId,
                                  prepareOrderId: dataSource[index]
                                      ?.prepareOrderId, //TODO: 待理货的prepareOrderId, 这里后端的api似乎有问题
                                  orderOperationalRequirements:
                                      dataSource[index]
                                          ?.orderOperationalRequirements,
                                ),
                              ).then((value) {

                                requestData(requirements);
                                widget.refresh();
                              });
                            },
                            index: index,
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
