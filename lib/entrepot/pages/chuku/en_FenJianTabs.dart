// 分拣页面,包含了: 快递、自提、车送
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/utils/jk_over_scroll_behavior.dart';
// ignore: unused_import
import '../scan/en_search_page.dart';
// import 'fenjian_list.dart';
import 'en_kuaidi_list.dart';
import '../en_main_page.dart';

class ENFenJianPage extends StatefulWidget {
  const ENFenJianPage({
    Key key,
  }) : super(key: key);
  @override
  _ENFenJianPageState createState() => _ENFenJianPageState();
}

class _ENFenJianPageState extends State<ENFenJianPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> tabTitles = [
    '快递',
    // '自提',
    // '车送',
  ];
  List<Widget> pages = [
    KuaidiList(),
    // ZitiList(),
    // CheSongList(),
  ];
  TabController controller;

  var sortingCounts = {
    '快递': '',
    '自提': '',
    '车送': '',
  };
  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 1,
      vsync: this,
    );
    enSortingCount();
    controller.addListener(() {
      enSortingCount();
      print('切换到了' + controller.index.toString());
    });
  }

  // 开始获取数据
  enSortingCount() async {
    var data = await HttpServices().enSortingCount();
    if (data != null) {
      print(data);
      setState(() {
        sortingCounts['快递'] = (data['expressDelivery'] ?? 0).toString();
        sortingCounts['自提'] = (data['selfMention'] ?? 0).toString();
        sortingCounts['车送'] = (data['carDelivery'] ?? 0).toString();
      });
    } else {
      sortingCounts = {
        '快递': '0',
        '自提': '0',
        '车送': '0',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("分拣单列表"),
          leading: BackButton(
            onPressed: () {
              Get.offAll(() => ENMainPage());
            },
          ),
        ),
        body: ScrollConfiguration(
            behavior: JKOverScrollBehavior(),
            child: Container(
                child: Column(children: [
              // Container(
              //   color: Colors.white,
              //   child: CommonSearchBar(
              //       placeHolder: '请输入出库单号',
              //       width: 360.w,
              //       showScanIcon: true,
              //       searchCallBack: () {
              //         //获取其他页面搜索数据
              //         print(controller.index);
              //         Get.to(
              //           () => ENSearchPage(
              //             placeHolder: '请输入出库单号',
              //             listType: ['outStoreName'],
              //           ),
              //         );
              //       }
              //       // requestCommodityData(value);
              //       ),
              // ),
              TabBar(
                controller: controller,
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(horizontal: 0),
                tabs: tabTitles
                    .map((title) => Tab(
                          child: Text(
                            '$title(${sortingCounts[title]})',
                          ),
                          // Positioned(
                          //     right: 30,
                          //     top: 12,
                          //     child: Text(sortingCounts[title],
                          //         style: TextStyle(
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.bold)))
                        ))
                    .toList(),
              ),
              Expanded(
                  child: TabBarView(
                children: pages,
                controller: controller,
              )),
            ]))),
      ),
    );
  }
}
