import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/models/storage/cs_dck_model.dart';
import 'package:wms/views/commodity_kucun_cell_widget.dart';
import 'cs_kucun_sale_page.dart';
import 'cs_kucun_sale_xiaci_page.dart';
import 'package:wms/views/customer/storage/cs_kucun_defect_data_table.dart';

class CSKuCunDetailPage extends StatefulWidget {
  final model;
  final int spuId;
  final int depotId;
  final status;

  const CSKuCunDetailPage({Key key, this.model, this.spuId, this.depotId, this.status}) : super(key: key);

  @override
  _CSKuCunDetailPageState createState() => _CSKuCunDetailPageState();
}

class _CSKuCunDetailPageState extends State<CSKuCunDetailPage> {
  var dataModel = CsChuKuModel();

  // var sizeTableRow;
  var normalSpuInfo = [];
  var defectSpuInfo = [];
  var defectSpuDetailInfo = [];
  var selectedNormalStoreIndex = 0;
  var selectedDefectStoreIndex = 0;
  var showDefectTableList;

  @override
  void initState() {
    super.initState();
    requestNormalData();
    requestDefectData();
  }

//获取正常件出售详情
  Future<bool> requestNormalData() async {
    // 单品出售,查询出售信息详情
    EasyLoadingUtil.showLoading();
    print('get commodity sale info');
    var res = await HttpServices().spuShelfNormalDetail(
      depotId: widget.depotId,
      spuId: widget.spuId,
    );
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (res != null) {
      final data = res['data'];
      final total = res['total'];
      print(data);
      setState(() {
        normalSpuInfo = data;
      });
      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

//获取瑕疵件出售详情
  Future<bool> requestDefectData() async {
    // 获得瑕疵件点击出售详情
    EasyLoadingUtil.showLoading();
    print('get commodity defect sale info');
    var res = await HttpServices().spuShelfDefectDetail(
      depotId: widget.depotId,
      spuId: widget.spuId,
    );
    if (res == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (res != null) {
      final data = res;
      var all = data.map((e) => e['storeId']).toSet().toList();

      // final total = res['total'];
      print(data);
      setState(() {
        defectSpuInfo = data; //返回storeId与size
        defectSpuInfo.insert(0, {'storeId': all, 'size': '全部'});
      });
      EasyLoadingUtil.hidden();
      final resdetail = await requestDefectDetailData(all, data.sublist(1));
      if (resdetail) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> requestDefectDetailData(storeId, sizeList) async {
    // 获得瑕疵件点击出售详情
    EasyLoadingUtil.showLoading();
    print('get commodity defect detail info');

    var res = await HttpServices().spuShelfDefect(
        // condition: defectSpuInfo.map((each) => each['storeId']).toList(),
        condition: storeId,
        pageSize: 10,
        pageNum: 1);
    if (res == false) {
      EasyLoadingUtil.hidden();
      setState(() {
        defectSpuDetailInfo = [];
      });
      return false;
    }
    if (res != null) {
      final data = res;
      print(data);
      if (data.length != 0) {
        EasyLoadingUtil.hidden();
        setState(() {
          defectSpuDetailInfo = data; //返回瑕疵件详细信息
          defectSpuDetailInfo.forEach((each) => each['maxCount'] = 1);
          defectSpuDetailInfo.forEach((each) => each['id'] = each['storeId']);
          defectSpuDetailInfo.forEach((each) => each['count'] = 0);
          defectSpuDetailInfo.forEach((each) => each['status'] = 1);
          // defectList.forEach(
          //     (each) => each['size'] = sizeList.forEach((each) => each['size']));
          print(sizeList.length);
          print(defectSpuDetailInfo.length);
          for (var i = 0; i < defectSpuDetailInfo.length; i++) {
            if (i < sizeList.length) {
              defectSpuDetailInfo[i]['size'] = sizeList[i]['size'];
            } else {
              defectSpuDetailInfo[i]['size'] = sizeList[0]['size'];
            }
          }
          showDefectTableList = defectSpuDetailInfo;
        });
      } else {
        setState(() {
          defectSpuDetailInfo = [];
        });
      }

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
          content: '单品库存',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    CommodityKuCunCellWidget(model: widget.model),
                    infoItemWidget(title: '库存总数：', content: '${widget.model.factCount ?? 0}'),
                    infoItemWidget(title: '锁定库存总数：', content: '${widget.model.lockCount ?? 0}'),
                    Visibility(visible: widget.status == 0, child: SectionTitleWidget(title: '正常商品')),
                    Visibility(
                        visible: widget.status == 0,
                        child: normalSpuInfo.length != 0
                            ? buildSizeNumberTable(context, normalSpuInfo)
                            : Text('未查询到正常商品数据')),
                    Visibility(visible: widget.status != 0, child: SectionTitleWidget(title: '瑕疵商品')),
                    Visibility(
                        visible: widget.status != 0,
                        child: defectSpuInfo.length != 0
                            ? sizeWidget(
                                commoditySPuList: defectSpuInfo,
                                groupValue: selectedDefectStoreIndex,
                                tapCallback: (index) {
                                  setState(() {
                                    selectedDefectStoreIndex = index;
                                    if (index == 0) {
                                      showDefectTableList = defectSpuDetailInfo;
                                    } else {
                                      showDefectTableList = defectSpuDetailInfo
                                          .where((each) => each['size'] == defectSpuInfo[index]['size'])
                                          .toList();
                                    }

                                    print(showDefectTableList);
                                  });
                                },
                                status: 1)
                            : Text('未查询到瑕疵商品数据')),
                    Visibility(
                        visible: widget.status != 0,
                        child: defectSpuDetailInfo.length != 0
                            ? DefectDataTable(
                                model: showDefectTableList,
                                selectedMultiModel: false,
                                onModelChangeCallback: (model, indexSelected, selected) {
                                  setState(() {
                                    model[indexSelected]['selected'] = selected;
                                    if (selected) {
                                      model[indexSelected]['count'] = 1;
                                    }
                                  });
                                },
                              )
                            : Text('未查询到瑕疵商品数据')),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: WMSButton(
                    title: '添加可售',
                    bgColor: AppConfig.themeColor,
                    callback: () {
                      //正常商品进入正常出售
                      if (widget.model.status == 0) {
                        Get.to(
                            () => CSKuCunSalePage(spuId: widget.spuId, depotId: widget.depotId, model: widget.model));
                      }
                      if (widget.model.status == 1) {
                        Get.to(() =>
                            CSKuCunSaleXiaCiPage(spuId: widget.spuId, depotId: widget.depotId, model: widget.model));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sizeWidget({List commoditySPuList, Function tapCallback, int status = 0, groupValue}) {
    //status 代表着瑕疵，默认0 正常，1 瑕疵
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
      child: Wrap(
        children: List.generate(
          commoditySPuList.length,
          (index) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              tapCallback(index);
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
              alignment: Alignment.center,
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),
                border: groupValue == index ? Border.all(width: 2.0, color: AppStyleConfig.btnColor) : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${commoditySPuList[index]['size'] ?? '无尺码'}${commoditySPuList[index]['specification'] != null ? "/" + commoditySPuList[index]['specification'] : ''}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  // Text(
                  //   status == 0
                  //       ? ((commoditySPuList[index]['bazaarOnSaleCount'] ?? 0) +
                  //               (commoditySPuList[index]
                  //                       ['bazaarMaxSaleCount'] ??
                  //                   0))
                  //           .toString()
                  //       : '1',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold, color: Colors.black38),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Theme buildSizeNumberTable(BuildContext context, list) {
    var sizeTableRow = list.map((e) => e['size']).toList();
    sizeTableRow.insert(0, '尺寸');
    var specificationTableRow = list.map((e) => e['specification']).toList();
    specificationTableRow.insert(0, '规格');
    var totalSaleTableRow = list.map((e) => e['useCount']).toList();
    totalSaleTableRow.insert(0, '可用库存');
    var lockSaleTableRow = list.map((e) => e['lockCount']).toList();
    lockSaleTableRow.insert(0, '锁定库存');
    var bazaarMaxSaleTableRow = list.map((e) => e['bazaarMaxSaleCount']).toList();
    bazaarMaxSaleTableRow.insert(0, '集市最大可售数量');
    var appMaxSaleTableRow = list.map((e) => e['appMaxSaleCount']).toList();
    appMaxSaleTableRow.insert(0, '小程序最大可售数量');
    var bazaarOnSaleTableRow = list.map((e) => e['bazaarOnSaleCount']).toList();
    bazaarOnSaleTableRow.insert(0, '集市在售数量');
    var appOnSaleTableRow = list.map((e) => e['appOnSaleCount']).toList();
    appOnSaleTableRow.insert(0, '小程序在售数量');
    if (normalSpuInfo == null) {
      return null;
    }
    if (normalSpuInfo?.length != 0) {
      print(normalSpuInfo.length);

      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: Colors.black, onPrimary: Colors.white),
        ),
        child: Container(
          color: Theme.of(context).colorScheme.onPrimary,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 30.0),
              child: DataTable(
                  headingRowColor:
                      MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Color(0xfff2f2f2)),
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
                  headingTextStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                  columnSpacing: 20.0,
                  columns: List<DataColumn>.generate(sizeTableRow.length, (index) {
                    return DataColumn(
                      label: Text(sizeTableRow[index] ?? '无尺码'),
                    );
                  }),
                  rows: [
                    // DataRow(
                    //   cells: maxSaleTableRow,
                    // ),
                    DataRow(
                      cells: List.generate(
                        specificationTableRow.length,
                        (index) => DataCell(Text((specificationTableRow[index] ?? "").toString())),
                      ),
                    ),
                    DataRow(
                      cells: List.generate(
                        totalSaleTableRow.length,
                        (index) => DataCell(GestureDetector(
                            child: Text((totalSaleTableRow[index] ?? 0).toString(),
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig.themeColor)),
                            onTap: () {
                              if (index != 0) {
                                Get.to(() => CSKuCunSalePage(
                                    spuId: widget.spuId,
                                    depotId: widget.depotId,
                                    model: widget.model,
                                    initIndex: index - 1));
                              }
                            })),
                      ),
                    ),
                    DataRow(
                      cells: List.generate(
                        lockSaleTableRow.length,
                        (index) => DataCell(Text((lockSaleTableRow[index] ?? 0).toString())),
                      ),
                    ),
                    DataRow(
                      cells: List.generate(
                        bazaarMaxSaleTableRow.length,
                        (index) => DataCell(Text((bazaarMaxSaleTableRow[index] ?? 0).toString())),
                      ),
                    ),
                    DataRow(
                      cells: List.generate(
                        appMaxSaleTableRow.length,
                        (index) => DataCell(Text((appMaxSaleTableRow[index] ?? 0).toString())),
                      ),
                    ),
                    DataRow(
                      cells: List.generate(
                        bazaarOnSaleTableRow.length,
                        (index) => DataCell(Text((bazaarOnSaleTableRow[index] ?? 0).toString())),
                      ),
                    ),
                    DataRow(
                      cells: List.generate(
                        appOnSaleTableRow.length,
                        (index) => DataCell(Text((appOnSaleTableRow[index] ?? 0).toString())),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      );
    }
  }
}
