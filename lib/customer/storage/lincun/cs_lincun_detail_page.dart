import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/models/storage/cs_dck_model.dart';
import 'package:wms/entrepot/pages/en_logistics_page.dart';

class CSLinCunDetailPage extends StatefulWidget {
  final int prepareOrderId;
  final int status;

  const CSLinCunDetailPage({Key key, this.prepareOrderId, this.status = 0})
      : super(key: key);

  @override
  _CSLinCunDetailPageState createState() => _CSLinCunDetailPageState();
}

class _CSLinCunDetailPageState extends State<CSLinCunDetailPage> {
  var dataModel = CsChuKuModel();
  void initState() {
    super.initState();
    requestData();
  }

  Future<bool> requestData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    //status=1 ,已出库
    var data = await HttpServices().csTemporaryExistenceListDetail(
      prepareOrderId: widget.prepareOrderId,
    );
    if (data != null) {
      print(data);
      setState(() {
        dataModel = data;
        print(dataModel);
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
          content: widget.status == 0 ? '临存单详情' : '出仓单详情',
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
              SectionTitleWidget(title: '入仓信息'),
              infoItemWidget(
                  padding: EdgeInsets.only(left: 16.w, top: 8.h),
                  title: '入仓箱数：',
                  content: '${dataModel.boxTotalFact ?? 0}'),
              infoItemWidget(
                title: '入仓照片：',
                padding: EdgeInsets.only(left: 16.w, top: 8.h),
              ),
              WMSImageWrap(
                imagePaths: WMSUtil.segmentationImageUrl(
                  dataModel.instoreOrderImg,
                ),
              ),
              if (widget.status == 1) ...[
                SectionTitleWidget(title: '出仓信息'),
                infoItemWidget(
                    padding: EdgeInsets.only(left: 16.w, top: 8.h),
                    title: '出仓箱数：',
                    content: '${dataModel.skuTotal ?? 0}'),
                infoItemWidget(
                    padding: EdgeInsets.only(left: 16.w, top: 8.h),
                    title: '出仓照片：'),
                WMSImageWrap(
                  imagePaths: WMSUtil.segmentationImageUrl(
                    dataModel.outSkuOrderImg,
                  ),
                ),
              ]
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
              title: '预约单号：', content: '${dataModel.prepareOrderName}'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: infoItemWidget(
                    title: '快递单号：',
                    content:
                        '${widget.status == 0 ? dataModel.mailNo : dataModel.expressNumber}'),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => ENLogisticsPage(
                      dataCode: widget.status == 0
                          ? dataModel.mailNo
                          : dataModel.expressNumber));
                },
                child: stateWidget(
                  title: '查看物流',
                  bgColor: Colors.deepOrangeAccent,
                  contentColor: Colors.white,
                ),
              )
              // WMSStateLabel(
              //   title: '物流轨迹',
              //   callback: () => Get.to(
              //     () => ENLogisticsPage(
              //       dataCode: widget.status == 0
              //           ? dataModel.mailNo
              //           : dataModel.expressNumber,
              //     ),
              //   ),
              // ),
            ],
          ),
          // infoItemWidget(
          //     title: '出库时间：',
          //     content: '${pageController.dataModel.value.outTime}'),
          infoItemWidget(title: '仓库：', content: '${dataModel.depotName}'),
        ],
      ),
    );
  }
}
