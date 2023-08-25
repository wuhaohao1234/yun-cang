import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/models/market/market_wares_model.dart';

import 'kc_select_widget/kc_select_widget_logic.dart';
import 'kc_select_widget/kc_select_widget_state.dart';

/// Create by bigv on 21-7-30
/// Description:

class KcUpWidget extends StatefulWidget {
  @override
  _KcUpWidgetState createState() => _KcUpWidgetState();
}

class _KcUpWidgetState extends State<KcUpWidget> {
  final KcSelectWidgetLogic logic = Get.find<KcSelectWidgetLogic>();
  final KcSelectWidgetState state = Get.find<KcSelectWidgetLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 30.0,
                bottom: 10.0,
                left: 15.0,
                right: 15.0,
              ),
              child: Text('清单(${state.spuSelectAllCheckbox?.keys?.length ?? ''})'),
            ),
            Divider(),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.spuSelectAllCheckbox?.length ?? 0,
                      (index) {
                        int key = state.spuSelectAllCheckbox.keys.elementAt(index);
                        MarketWaresModel _item = state.spuSelectAllCheckbox[key]['model'];
                        Map<String, List> _itemChild = state.spuSelectAllCheckbox[key]['childData'];
                        return Container(
                          decoration:
                              BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Color(0xfff2f2f2)))),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  child: _item.picturePath != null
                                      ? Image.network(
                                          _item.picturePath,
                                          width: 90.0,
                                          height: 90.0,
                                        )
                                      : SizedBox(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: Text('${_item.commodityName}'),
                                      width: MediaQuery.of(context).size.width - 90 - 30,
                                    ),
                                    Text(
                                      '货号:${_item.stockCode}',
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    Text(
                                      '颜色:${_item.color}',
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    Text('${_itemChild !=null?logic.getChildStr(_itemChild):'全部'}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  mainAxisSize: MainAxisSize.max,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
