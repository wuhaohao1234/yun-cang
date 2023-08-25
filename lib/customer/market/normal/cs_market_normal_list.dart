// 集市正常商品页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/customer/market/normal/market_normal_detail_page.dart';
import 'package:wms/views/customer/market/market_grid_cell_widget.dart';

// import 'cs_lincun_detail_page.dart';

class CSMarketNormalList extends StatefulWidget {
  final String searchContent;
  final List categoryList;
  const CSMarketNormalList({Key key, this.searchContent = '', this.categoryList}) : super(key: key);

  @override
  State<CSMarketNormalList> createState() => CSMarketNormalListState();
}

class CSMarketNormalListState extends State<CSMarketNormalList> with TickerProviderStateMixin {
  List marketNormalList = [];
  int pageNum = 1;
  bool canMore = true;
  String stateSearchContent;
  var categoryId;
  var initialIndex = 0;

  ScrollController refreshScrollerController = new ScrollController();
  void initState() {
    super.initState();
    print(widget.searchContent);
    onRefresh(searchContent: widget.searchContent);
    setState(() {
      stateSearchContent = widget.searchContent;
    });
  }

  Future<void> onRefresh({searchContent}) async {
    setState(() {
      pageNum = 1;
      if (searchContent != null) {
        stateSearchContent = searchContent;
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
    return true;
  }

  Future requestData({searchContent}) async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var res = await HttpServices().csGetMarketSpuList(
        pageSize: 10, pageNum: pageNum, status: 0, searchContent: searchContent, categoryId: categoryId);
    if (res['result'] == false) {
      EasyLoadingUtil.showMessage(message: '${res['data']},请确认后台数据');
      return false;
    }
    final data = res["data"];
    final total = res["total"];
    setState(() {
      stateSearchContent = searchContent;
      if (pageNum == 1) {
        marketNormalList = data;
      } else {
        marketNormalList.addAll(data);
      }
      if (marketNormalList.length == total) {
        canMore = false;
      } else {
        canMore = true;
      }
      print("共计 $total, 目前${marketNormalList.length}");

      EasyLoadingUtil.hidden();
    });
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
                    print('widget.searchContent${widget.searchContent}');
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
          Expanded(
              child: RefreshView(
                scrollController: refreshScrollerController,
            header: MaterialHeader(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ),
            onRefresh: onRefresh,
            onLoad: onLoad,
            child: marketNormalList.length != 0
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //横轴三个子widget
                        childAspectRatio: 0.85, //宽高比为1时，子widget
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => MarketNormalDetailPage(
                              spuId: marketNormalList[index].spuId,
                              status: 0,
                              model: marketNormalList[index],
                            ),
                          );
                        },
                        child: MarketGridCellWidget(
                          model: marketNormalList[index],
                        ),
                      );
                    },
                    itemCount: marketNormalList.length,
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
