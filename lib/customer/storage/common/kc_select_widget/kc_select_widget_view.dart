import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/models/market/market_wares_model.dart';
import 'package:wms/models/size_qty_model.dart';

import 'kc_select_widget_logic.dart';
import 'kc_select_widget_state.dart';

class KcSelectWidgetPage extends StatefulWidget {
  final MarketWaresModel data;

  const KcSelectWidgetPage({Key key, this.data}) : super(key: key);

  @override
  _KcSelectWidgetPageState createState() => _KcSelectWidgetPageState();
}

class _KcSelectWidgetPageState extends State<KcSelectWidgetPage> {
  final KcSelectWidgetLogic logic = Get.find<KcSelectWidgetLogic>();
  final KcSelectWidgetState state = Get.find<KcSelectWidgetLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KcSelectWidgetLogic>(
        // autoRemove: false,
        // assignId: true,
        initState: (_) => logic.setDate(widget.data),
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 49.0,
                    alignment: Alignment.center,
                    child: Text('手动选择'),
                  ),
                  Positioned(
                    child: CloseButton(),
                    right: 0,
                    top: 0,
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('选择尺码'),
                    SizedBox(height: 10.w),
                    Column(
                      children: [
                        Row(
                          children: List.generate(
                            state.sizeQty.length,
                            (index) => Container(
                              margin: EdgeInsets.only(right: 10.w),
                              alignment: Alignment.center,
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                color: Color(0xfff2f2f2),
                                border: state.skuId == state.sizeQty[index].skuId
                                    ? Border.all(width: 2.0, color: Colors.black)
                                    : null,
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => logic.setSkuId(state.sizeQty[index].skuId, index),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      state.sizeQty[index].size,
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    Text(
                                      state.sizeQty[index].qty.toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('选择商品'),
                    SizedBox(height: 10.w),
                    buildDataTable(context),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          // style: TextButton.styleFrom(
                          //   primary: Colors.white,
                          //   backgroundColor: Colors.black,
                          // ),
                          onPressed: () {
                            // kcStoreController.setStr('sdfsdfsdf');
                            // logic.addData(state.skuId, state.commodityData);
                            print('state.commodityData ${state.commodityData}');
                            logic.addData(state.skuId, state.commodityData);
                            Get.back();
                            //data
                          },
                          child: Text('确认'),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Theme buildDataTable(BuildContext context) {
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
              columns: <DataColumn>[
                DataColumn(
                  label: Text('尺码'),
                ),
                DataColumn(
                  label: Text('颜色'),
                ),
                DataColumn(
                  label: Text('状态'),
                ),
                DataColumn(
                  label: Text('图片'),
                ),
                DataColumn(
                  label: Text('在售'),
                ),
              ],
              rows: List<DataRow>.generate(
                state.sizeQty.isNotEmpty ? state.sizeQty[state.skuIdIndex].childrenList.length : 0,
                (index) {
                  ChildrenList _data = state.sizeQty[state.skuIdIndex].childrenList[index];
                  return DataRow(
                    selected: _data?.selected ?? false,
                    // selected: true,
                    onSelectChanged: (selected) {
                      setState(() {
                        _data.selected = selected;
                      });
                    },
                    cells: <DataCell>[
                      DataCell(Text(_data?.size)),
                      DataCell(Text(_data?.color ?? '-')),
                      DataCell(Text(_data?.status == '0' ? '正常' : '瑕疵')),
                      DataCell(
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                child: Image.network(
                                  _data?.imgUrl,
                                  height: 48.0,
                                  width: 48.0,
                                ),
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  print('图片1');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(Text(_data?.isForSale == '1' ? '可售' : '不可售')),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

// @override
// void dispose() {
//   Get.delete<KcSelectWidgetLogic>();
//   super.dispose();
// }
}
