// 分拣-快递的列表界面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/views/entrenpot/chuku/en_fenjian_cell.dart';
import 'en_fenjian_detail_page.dart';
import 'package:wms/views/common/input_search_bar_widget.dart';

class KuaidiList extends StatefulWidget {
  const KuaidiList({
    Key key,
  }) : super(key: key);

  @override
  _KuaidiListState createState() => _KuaidiListState();
}

class _KuaidiListState extends State<KuaidiList> {
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
    //获取快递数据
    HttpServices.enSortingList(
        transportType: 5,
        pageSize: AppConfig.pageSize,
        pageNum: pageNum,
        outStoreName: searchContent.text,
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
    return Container(
      color: Colors.white,
        child: Column(
      children: [
        Container(
          color: Colors.white,
          child: InputSearchBarWidget(
              searchHinterText: '请输入出库单号',
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
            onLoad: canMore ? onLoad : null,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ENFenJianCell(
                  index: index,
                  model: dataSource[index],
                  callback: () {
                    Get.to(() => ENFenJianDetailPage(
                        outOrderId: dataSource[index].outOrderId,
                        outStoreName: dataSource[index].outStoreName,
                        tenantUserCode: dataSource[index].tenantUserCode,
                        dataModel: dataSource[index]));
                  },
                );
              },
              itemCount: dataSource.length,
            ),
          ),
        ),
      ],
    ));
  }
}
