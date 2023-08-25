import 'package:wms/customer/common.dart'; //页面通用依赖集合

import 'normal/cs_market_normal_list.dart';
import 'defect/cs_market_defect_list.dart';
import 'package:wms/views/common/input_search_bar_widget.dart';

class MarketHomePage extends StatefulWidget {
  const MarketHomePage({Key key}) : super(key: key);

  @override
  _MarketHomePageState createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<String> _tabTitles = ['正常', '瑕疵'];
  List tabKeys = [
    GlobalKey<CSMarketNormalListState>(),
    GlobalKey<CSMarketDefectListState>(),
  ];
  TabController controller;
  var searchContentController = TextEditingController();
  var searchContent;
  int activeIndex = 0;
  var categoryList = [];
  var depotId;
  @override
  void initState() {
    super.initState();
    setState(() {
      //设置初始index
      activeIndex = 0;
    });
    controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );

    controller.addListener(() {
      print("切换到了 ${controller.index.toString()}");
      setState(() {
        activeIndex = controller.index ?? 0;
        searchContentController.text = '';
      });
    });

    searchContentController.text = '';

    requestcategoryData();
  }

  Future<bool> requestcategoryData() async {
    // 请求商品品类的数据
    var res = await HttpServices().getFirstCategorys();
    if (res == false) {
      EasyLoadingUtil.showMessage(message: "获取后台品类数据出错");
      return false;
    }
    final data = res["data"];

    if (data != null) {
      if (data.length == 0) {
        EasyLoadingUtil.hidden();
        setState(() {
          categoryList = [];
        });
        EasyLoadingUtil.showMessage(message: "获取后台品类数据为空");
      }
      print(data);
      setState(() {
        categoryList = data;
        // final countNum = categoryList.fold(0, (previousValue, element) => previousValue + element['countNum']);
        // 'countNum': countNum
        categoryList.insert(0, {
          'categoryName': '全部',
          'categoryId': null,
        });
        print(categoryList);
      });
      print("categoryList.length${categoryList.length}");

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabTitles.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: GestureDetector(
              onTap: () {
                print(controller.index.toString() + '大大');
              },
              child: InputSearchBarWidget(submitCallback: (value) {
                print(activeIndex);
                print(tabKeys[activeIndex ?? 0]);
                setState(() {
                  searchContent = searchContentController.text;
                  tabKeys[activeIndex ?? 0].currentState.onRefresh(searchContent: value != null ? value : '');
                });
              }, cancelCallback: () {
                setState(() {
                  tabKeys[activeIndex].currentState.onRefresh(searchContent: '');
                });
              }),
            )),
        body: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Container(
            child: Column(
              children: [
                Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: controller,
                      indicatorColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      labelPadding: EdgeInsets.symmetric(horizontal: 0),
                      tabs: _tabTitles
                          .map((title) => Tab(
                                text: title,
                              ))
                          .toList(),
                    )),

                Flexible(
                  child: TabBarView(
                    children: [
                      CSMarketNormalList(
                        key: tabKeys[0],
                        categoryList:categoryList,
                        searchContent: activeIndex == 0 ? searchContentController.text : '',
                      ),
                      CSMarketDefectList(
                        key: tabKeys[1],
                        categoryList:categoryList,
                        searchContent: activeIndex == 1 ? searchContentController.text : '',
                      ),
                    ],
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
