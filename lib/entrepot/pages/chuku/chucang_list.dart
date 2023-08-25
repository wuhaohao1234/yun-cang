// 出仓的列表界面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/views/entrenpot/chuku/en_chucang_cell.dart';
import 'en_chucang_licun_page.dart';
import 'package:wms/models/entrepot/chuku/en_chucang_model.dart';

class ChuCangList extends StatefulWidget {
  final String outStoreType;
  final String searchContent;

  const ChuCangList({Key key, this.outStoreType, this.searchContent = ''}) : super(key: key);

  State<ChuCangList> createState() => ChuCangListState();
}

class ChuCangListState extends State<ChuCangList> {
  final hs = HttpServices();
  Map<String, List> orders = {'本地': [], '跨境': []}; //两种类型的出仓单.
  var pageNum = 1;
  var canMore = true;
  var crossBorderType = "本地";
  String searchContent;

  @override
  void initState() {
    super.initState();
    onRefresh(searchContent: widget.searchContent);
  }

  // 发起数据请求
  Future requestData({searchContent}) async {
    EasyLoadingUtil.showLoading();

    final res = await hs.enWillOrAlreadyList(
        outStoreType: widget.outStoreType,
        pageNum: pageNum,
        crossBorder: crossBorderType == "本地" ? 0 : 1,
        pageSize: 10,
        outStoreName: searchContent);
    setState(() {
      if (res["data"].length == res["total"]) {
        canMore = false;
      }

      if (pageNum == 1) {
        orders[crossBorderType] = res["data"];
      } else {
        orders[crossBorderType].addAll(res["data"]);
      }
    });

    EasyLoadingUtil.hidden();
  }

  Future<void> onRefresh({searchContent}) async {
    setState(() {
      pageNum = 1;
      if (searchContent != null) {
        searchContent = searchContent;
      }
      requestData(searchContent: searchContent);
    });
  }

  Future<void> onLoad() async {
    setState(() {
      pageNum += 1;
      EasyLoadingUtil.showMessage(message: "加载更多");
      requestData(searchContent: widget.searchContent);
    });
  }

  // 切换本地或者跨境
  void switchCrossBorder(newCrossBorderType) {
    if (newCrossBorderType != crossBorderType) {
      pageNum = 1;
      crossBorderType = newCrossBorderType;
      requestData(searchContent: searchContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    switchCrossBorder("本地");
                  },
                  child: Container(
                    width: 80.w,
                    height: 34.h,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Color(0xfff2f2f2)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                      color: crossBorderType == "本地" ? Colors.white : Color(0xfff2f2f2),
                    ),
                    child: Center(
                      child: WMSText(
                        content: '本地',
                        bold: crossBorderType == "本地",
                        color: crossBorderType == "本地" ? Colors.black : Color(0xff666666),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    switchCrossBorder("跨境");
                  },
                  child: Container(
                      width: 80.w,
                      height: 34.h,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Color(0xfff2f2f2)),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        color: crossBorderType == "跨境" ? Colors.white : Color(0xfff2f2f2),
                      ),
                      child: Center(
                          child: WMSText(
                        content: '跨境',
                        bold: crossBorderType == "跨境",
                        color: crossBorderType == "跨境" ? Colors.black : Color(0xff666666),
                      ))),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshView(
              header: MaterialHeader(
                valueColor: AlwaysStoppedAnimation(Colors.black),
              ),
              onRefresh: onRefresh,
              onLoad: canMore ? onLoad : null,
              child: orders[crossBorderType].length == 0
                  ? Center(
                      child: Text("暂无数据"),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return widget.outStoreType == 'will'
                            ? ENChuCangCell(
                                model: orders[crossBorderType][index],
                                callback: () {
                                  if (orders[crossBorderType][index]['temporaryExistenceType'] == 0) {
                                    print("cool");
                                    Get.to(() => ENChuCangLinCunPage(
                                        orderId: orders[crossBorderType][index]['wmsOutStoreId'],
                                        model: ENChuCangModel.fromJson(orders[crossBorderType][index])));
                                  }
                                },
                                refresh: () {
                                  onRefresh();
                                },
                                outStoreType: 'will')
                            : ENChuCangCell(
                                model: orders[crossBorderType][index],
                                callback: () {
                                  Get.to(() => ENChuCangLinCunPage(
                                      orderId: orders[crossBorderType][index]['wmsOutStoreId'],
                                      model: ENChuCangModel.fromJson(orders[crossBorderType][index])));
                                },
                                refresh: () {
                                  onRefresh();
                                },
                                outStoreType: 'already');
                      },
                      itemCount: orders[crossBorderType].length ?? 0),
            ),
          )
        ],
      ),
    );
  }
}
