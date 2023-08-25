// 集市瑕疵页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/customer/market/defect/market_defect_detail_page.dart';
import 'package:wms/views/customer/market/market_grid_cell_widget.dart';

// import 'cs_lincun_detail_page.dart';

class CSMarketDefectList extends StatefulWidget {
  final String searchContent;
  final List categoryList;

  const CSMarketDefectList({Key key, this.searchContent = '', this.categoryList}) : super(key: key);

  @override
  State<CSMarketDefectList> createState() => CSMarketDefectListState();
}

class CSMarketDefectListState extends State<CSMarketDefectList> with TickerProviderStateMixin{
  List marketDefectList = [];
  int pageNum = 1;
  bool canMore = true;
  String stateSearchContent;
  var categoryId;
  var initialIndex = 0;
ScrollController refreshScrollerController = new ScrollController();
  void initState() {
    super.initState();
    onRefresh(searchContent: widget.searchContent);
    setState(() {
      stateSearchContent = widget.searchContent;
    });
  }

  Future<void> onRefresh({searchContent}) async {
    print("请求瑕疵搜索内容为$searchContent");
    setState(() {
      pageNum = 1;
      if (searchContent != null) {
        searchContent = searchContent;
      }
      requestData(searchContent: searchContent);
    });
  }

  Future<void> onLoad() async {
    if (canMore) {
      setState(() {
        pageNum += 1;
        EasyLoadingUtil.showMessage(message: "加载更多");
        requestData(searchContent: this.stateSearchContent);
      });
    } else {
      EasyLoadingUtil.showMessage(message: "无更多数据");
    }
  }

  Future requestData({searchContent}) async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().csGetMarketSpuList(
        pageSize: 10, pageNum: pageNum, status: 1, searchContent: searchContent, categoryId: categoryId);
    if (res['result'] == false) {
      EasyLoadingUtil.showMessage(message: '${res['data']},请确认后台数据');
      return false;
    }
    final data = res["data"];
    final total = res["total"];
    setState(() {
      stateSearchContent = searchContent;
      if (pageNum == 1) {
        marketDefectList = data;
      } else {
        marketDefectList.addAll(data);
      }
      if (marketDefectList.length == total) {
        // 可以加载更多
        canMore = false;
      } else {
        // 不可以加载更多
        canMore = true;
      }
      print("共计 $total, 目前${marketDefectList.length}");
      EasyLoadingUtil.hidden();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Visibility(
              visible: widget.categoryList.length != 0,
              child: Container(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: TabController(
                    length: widget.categoryList.length,
                    vsync: this,
                    initialIndex: initialIndex,
                  ),
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  labelPadding: EdgeInsets.symmetric(horizontal: 10),
                  isScrollable: true,
                  onTap: (e) {
                    setState(() {
                      initialIndex = e;
                      categoryId = widget.categoryList[e]['categoryId'];
                    });
                    refreshScrollerController.jumpTo(0);
                    onRefresh(searchContent: widget.searchContent);
                    // requestData();
                  },
                  tabs: widget.categoryList
                      .map((title) => Tab(
                    text: title['categoryName'].toString(),
                  ))
                      .toList(),
                ),
              )),
          Expanded(child: RefreshView(
            scrollController: refreshScrollerController,
            header: MaterialHeader(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ),
            onRefresh: onRefresh,
            onLoad: onLoad,
            child: marketDefectList.length != 0
                ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //横轴三个子widget
                  childAspectRatio: 0.78, //宽高比为1时，子widget
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 4),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(
                          () => MarketDefectDetailPage(
                        spuId: marketDefectList[index].spuId,
                        status: 1,
                        model: marketDefectList[index],
                      ),
                    );
                  },
                  child: MarketGridCellWidget(
                    model: marketDefectList[index],
                  ),
                );
              },
              itemCount: marketDefectList.length,
            )
                : Container(
                padding: EdgeInsets.symmetric(vertical: 100),
                alignment: Alignment.center,
                child: WMSText(content: '暂无数据～')),
          ))
        ],
      ),
    );
  }
}
