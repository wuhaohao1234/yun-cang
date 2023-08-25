/*
* 客户端入-仓储管理模块-异常单详情
* */
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/customer/storage/controllers/cs_ycj_detail_page_controller.dart';
import 'package:wms/views/customer/storage/cs_ckd_cell_good.dart';
import 'package:wms/entrepot/pages/en_logistics_page.dart';

class CSYcdDetailPage extends StatefulWidget {
  CSYcdDetailPage({Key key, this.exceptionOrderId}) : super(key: key);
  final int exceptionOrderId;

  @override
  _CSYcdDetailPageState createState() => _CSYcdDetailPageState();
}

class _CSYcdDetailPageState extends State<CSYcdDetailPage> {
  CSYcjDetailPageController pageController;

  @override
  void initState() {
    pageController =
        Get.put(CSYcjDetailPageController(widget.exceptionOrderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '异常单详情',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Obx(
          () => ScrollConfiguration(
            behavior: JKOverScrollBehavior(),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SectionTitleWidget(title: '基础信息'),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              infoItemWidget(
                                  title: '异常单号：',
                                  content: pageController
                                          .data.value?.exceptionOrderCode ??
                                      '-'),
                              infoItemWidget(
                                  title: '异常类型：',
                                  content: WMSUtil.getExceptionTypeString(
                                          pageController
                                              .data.value?.exceptionType) ??
                                      '-'),
                              infoItemWidget(
                                  title: '仓库：',
                                  content:
                                      pageController.data.value?.depotName ??
                                          '-'),
                              infoItemWidget(
                                  title: '预约数量：',
                                  content: pageController.data.value?.skusTotal
                                      .toString()),
                              infoItemWidget(
                                  title: '入库数量：',
                                  content: pageController
                                      .data.value?.skusTotalFact
                                      .toString()),
                              infoItemWidget(
                                  title: '入库时间：',
                                  content:
                                      pageController.data.value?.createTime ??
                                          '-'),
                              infoItemWidget(
                                  title: '预约入库单：',
                                  content:
                                      pageController.data.value?.orderIdName ??
                                          '-'),
                              infoItemWidget(
                                  title: '入库单：',
                                  content: pageController
                                          .data.value?.instoreOrderCode ??
                                      '-'),
                              Row(
                                children: [
                                  Expanded(
                                    child: infoItemWidget(
                                        title: '物流单号：',
                                        content:
                                            pageController.data.value?.mailNo ??
                                                '-'),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => ENLogisticsPage(
                                          dataCode: pageController
                                              .data.value.mailNo));
                                    },
                                    child: stateWidget(
                                      title: '查看物流',
                                      bgColor: Colors.deepOrangeAccent,
                                      contentColor: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SectionTitleWidget(title: '瑕疵件'),
                      // Theme(
                      //   data: Theme.of(context).copyWith(
                      //     colorScheme: Theme.of(context).colorScheme.copyWith(
                      //         primary: Colors.black, onPrimary: Colors.white),
                      //   ),
                      //   child: Container(
                      //     color: Theme.of(context).colorScheme.onPrimary,
                      //     margin: EdgeInsets.symmetric(horizontal: 5.0),
                      //     child: SingleChildScrollView(
                      //       scrollDirection: Axis.horizontal,
                      //       child: ConstrainedBox(
                      //         constraints: BoxConstraints(
                      //             minWidth:
                      //                 MediaQuery.of(context).size.width - 10.0),
                      //         child: DataTable(
                      //           // onSelectAll: pageController.onSelectAll,
                      //           headingRowColor:
                      //               MaterialStateProperty.resolveWith<Color>(
                      //                   (Set<MaterialState> states) =>
                      //                       Colors.black.withOpacity(0.08)),
                      //           decoration: BoxDecoration(
                      //               border: Border.all(
                      //                   width: 1, color: Colors.black12)),
                      //           headingTextStyle: TextStyle(
                      //               fontWeight: FontWeight.normal,
                      //               color: Colors.black),
                      //           columnSpacing: 20.0,
                      //           columns: <DataColumn>[
                      //             DataColumn(
                      //               label: Text('商品名称'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('尺码'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('图片'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('状态'),
                      //             ),
                      //           ],
                      //           rows: List<DataRow>.generate(
                      //             (pageController.data.value?.skuDetai?.skus ??
                      //                     [])
                      //                 .length,
                      //             (index) {
                      //               SkuListItem _item = pageController
                      //                   .data.value?.skuDetai?.skus[index];
                      //               return DataRow(
                      //                 // selected: _item?.selected ?? false,
                      //                 // onSelectChanged: (selected) {
                      //                 //   print('selected $selected');
                      //                 //   setState(() {
                      //                 //     _item.selected = selected;
                      //                 //   });
                      //                 //   pageController.onSelectChanged();
                      //                 // },
                      //                 cells: <DataCell>[
                      //                   DataCell(
                      //                     ConstrainedBox(
                      //                       constraints: BoxConstraints(
                      //                         maxWidth: 40.0,
                      //                       ),
                      //                       child: Text(
                      //                         _item.skuName ?? "skuName",
                      //                         maxLines: 1,
                      //                         overflow: TextOverflow.ellipsis,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   DataCell(Text(
                      //                       _item.size ?? 'size' ?? '无尺码')),
                      //                   DataCell(
                      //                     Container(
                      //                       // width: 400,
                      //                       child: Row(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         children: [
                      //                           GestureDetector(
                      //                             child: Image.network(
                      //                               _item.imgUrl ?? '',
                      //                               height: 48.0,
                      //                               width: 48.0,
                      //                             ),
                      //                             behavior: HitTestBehavior
                      //                                 .translucent,
                      //                             onTap: () {
                      //                               print('图片1');
                      //                               Get.to(() => PhotoViewPage(
                      //                                     images: _item
                      //                                             .imgUrl ??
                      //                                         ''.split(
                      //                                             ';'), //传入图片list
                      //                                     index:
                      //                                         0, //传入当前点击的图片的index
                      //                                   ));
                      //                             },
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   DataCell(Text(
                      //                       _item.status == '0' ? '正常' : '瑕疵')),
                      //                 ],
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                      if (pageController.data.value?.skuDetai?.skus?.length ==
                              0 ||
                          pageController.data.value?.skuDetai?.skus == null)
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
                              child: buildList(
                                  pageController.data.value?.skuDetai?.skus),
                              // child: Text("good")
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                //隐藏瑕疵件退回按钮
                // Padding(
                //   padding: EdgeInsets.only(
                //       bottom: MediaQuery.of(context).padding.bottom),
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: ElevatedButton(
                //       onPressed: pageController.skuIds.length == 0
                //           ? null
                //           : () {
                //               pageController.selectExceptionSkuSendBack();
                //             },
                //       child: Text('瑕疵件退回'),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(goodList) {
    return ListView.separated(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CSDkdGoodCell(
          exceptionType: true,
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
