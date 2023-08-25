import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/customer/storage/cs_ckd_cell_good.dart';
import 'package:wms/models/storage/cs_dck_model.dart';

class CSDaiChuKuDetailPage extends StatefulWidget {
  final int wmsOutStoreId;

  const CSDaiChuKuDetailPage({Key key, this.wmsOutStoreId}) : super(key: key);

  @override
  _CSDaiChuKuDetailPageState createState() => _CSDaiChuKuDetailPageState();
}

class _CSDaiChuKuDetailPageState extends State<CSDaiChuKuDetailPage> {
  var dataModel = CsChuKuModel();
  // var goodList = [SkuListItem()];
  var goodList = [];
  void initState() {
    super.initState();
    requestData();
  }

  Future<bool> requestData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var data = await HttpServices().csOutStoreDetail(
      wmsOutStoreId: widget.wmsOutStoreId.toString(),
    );
    if (data == false) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: '出错');
    }
    if (data != null) {
      print(data);
      setState(() {
        dataModel = data;
        goodList = data.skuList;
        print(dataModel);
        print(goodList);
      });
      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '待出库详情',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: ListView(
            children: [
              SectionTitleWidget(title: '基础信息'),
              Padding(
                  padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                  child: infoSectionWidget(dataModel)),
              SectionTitleWidget(title: '收件人信息'),
              buildAddressInfoWidget(dataModel),
              SectionTitleWidget(title: '出仓物品清单'),
              if (goodList?.length == 0 || goodList == null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  alignment: Alignment.center,
                  child: WMSText(content: '无商品列表'),
                )
              else
                Column(
                  children: [
                    Container(
                      // color: Colors.white,
                      child: buildList(goodList),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoSectionWidget(dataModel) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          infoItemWidget(
              title: '出库单号：', content: '${dataModel.wmsOutStoreName ?? ''}'),
          infoItemWidget(
              title: '创建时间：', content: '${dataModel.createTime ?? ''}'),
          infoItemWidget(
              title: '配送方式：', content: '${dataModel.logisticsName ?? '快递'}'),
          // Row(
          //   children: [
          //     Expanded(
          //       child: infoItemWidget(
          //           title: '快递单号：', content: '${dataModel.expressNumber}'),
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         Get.to(
          //             () => ENLogisticsPage(dataCode: dataModel.expressNumber));
          //       },
          //       child: stateWidget(
          //         title: '查看物流',
          //         bgColor: Colors.deepOrangeAccent,
          //         contentColor: Colors.white,
          //       ),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget buildList(goodList) {
    return ListView.separated(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CSDkdGoodCell(
          model: goodList[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey[200],
          height: 20.h,
          thickness: 1,
        );
      },
      itemCount: goodList.length ?? 0,
    );
  }
}
