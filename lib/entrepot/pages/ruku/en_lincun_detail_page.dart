//临存详情页面
import 'package:wms/views/common/section_title_widget.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
// import 'package:wms/entrepot/controllers/en_ybrk_page_controller.dart';
import '../en_logistics_page.dart';

class ENLinCunDetailPage extends StatelessWidget {
  final num orderId;
  final ybrkModel;

  const ENLinCunDetailPage({
    Key key,
    @required this.orderId,
    this.ybrkModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(ybrkModel.prepareImgUrl?.split(';'));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: WMSText(
            content: '临存入仓详情',
            size: AppStyleConfig.navTitleSize,
          ),
        ),
        body: RefreshView(
          header: MaterialHeader(
            valueColor: AlwaysStoppedAnimation(Colors.black),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SectionTitleWidget(
                  title: '基础信息',
                ),
                Column(
                  children: [
                    // Text(
                    //   '(DEBUG) prepareOrderId: ${ybrkModel.prepareImgUrl} ',
                    //   style: TextStyle(
                    //     fontSize: 10,
                    //     color: Colors.redAccent,
                    //   ),
                    // ),
                    WMSInfoRow(
                      title: '入仓单号：',
                      content: ybrkModel.orderIdName?.toString() ?? '',
                    ),
                    Visibility(
                      visible: ybrkModel.logisticsMode == '自提',
                      child: WMSInfoRow(
                        title: '物流状态：',
                        content: '自提',
                      ),
                    ),
                    Visibility(
                      visible: ybrkModel.logisticsMode == '快递',
                      child: Row(
                        children: [
                          Expanded(
                              child: WMSInfoRow(
                            title: '物流状态：',
                            content: ybrkModel?.mailNo ?? '',
                          )),
                          GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  ENLogisticsPage(dataCode: ybrkModel?.mailNo));
                            },
                            child: stateWidget(
                              title: '查看物流',
                              bgColor: Colors.deepOrangeAccent,
                              contentColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    WMSInfoRow(
                      title: '预约箱数：',
                      content: ybrkModel.boxTotal.toString() ?? '',
                    ),
                    WMSInfoRow(
                      title: '预约总数：',
                      content: ybrkModel.skusTotal.toString() ?? '',
                    ),
                    WMSInfoRow(
                      title: '用户代码：',
                      content: ybrkModel.customerCode ?? '',
                    ),
                    WMSInfoRow(
                      title: '签收时间：',
                      content: ybrkModel.updateTime ?? '',
                    ),
                    WMSInfoRow(
                      title: '仓库：',
                      content: ybrkModel.depotName ?? '',
                    ),
                  ],
                ),
                SectionTitleWidget(
                  title: '入仓商品清单',
                ),
                WMSInfoRow(
                  title: '入库商品箱数：',
                  content: '${ybrkModel.boxTotalFact ?? '无'}',
                ),
                WMSInfoRow(
                  title: '入库照片：',
                  content: '',
                ),
                ybrkModel.instoreOrderImg == null
                    ? Text("暂无照片")
                    : WMSImageWrap(
                        imagePaths: ybrkModel.instoreOrderImg?.split(';'),
                      ),
              ],
            ),
          ),
        ));
  }
}
