import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/customer/storage/common/kc_select_widget/kc_select_widget_logic.dart';
import 'package:wms/customer/storage/common/kc_select_widget/kc_select_widget_state.dart';
import 'package:wms/customer/storage/old/cs_kc_sub_page.dart.old';
import 'package:wms/models/market/market_wares_model.dart';

import 'kc_tabbarview_logic.dart';
import 'kc_tabbarview_state.dart';

class KcTabbarviewPage extends StatelessWidget {
  final int categoryId;
  final Map<int, Map<int, List<MarketWaresModel>>> selectCommodityData;
  final Function onChangedAllCheckboxChild;

  KcTabbarviewPage({this.categoryId, this.selectCommodityData, this.onChangedAllCheckboxChild});

  final KcSelectWidgetLogic parentLogic = Get.find<KcSelectWidgetLogic>();
  final KcSelectWidgetState parentState = Get.find<KcSelectWidgetLogic>().state;

  final KcTabbarviewLogic logic = Get.put(KcTabbarviewLogic());
  final KcTabbarviewState state = Get.find<KcTabbarviewLogic>().state;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<KcTabbarviewLogic>(
      initState: (_) => logic.loadDate(categoryId),
      builder: (_) {
        return Column(
          children: [
            Expanded(
              child: CSKcSubPage(
                categoryId: categoryId,
                // key: Key(categoryId.toString()),
                selected: false,
                selectCommodityData: selectCommodityData,
                selectSpuIds: parentState.spuSelectAllCheckbox,
                // 1:库存
                type: 1,
                selectCallBack: (v) {
                  parentLogic.openPicker(context, v);
                },
                onChangedAllCheckbox: onChangedAllCheckboxChild,
                loadCallBack: (List<MarketWaresModel> v) {
                  print('asdas');
                  parentState.spuDataList = v;
                  print("parentState.spuSelectAllCheckbox = "+ parentState.spuSelectAllCheckbox.toString());
                  var check = true;
                  parentState.spuDataList.forEach((element) {
                    print("element.spuId = " + element.spuId.toString());
                    print(parentState.spuSelectAllCheckbox[element.spuId].toString());
                    if(parentState.spuSelectAllCheckbox[element.spuId] == null){
                      check = false;
                      parentLogic.update();
                      return;
                    }
                  });
                  if(check == true){
                    parentState.allCheckbox = true;
                  }else{
                    parentState.allCheckbox = false;
                  }
                  print('parentState.allCheckbox = true;');
                  // parentState.allCheckbox = true;
                  parentLogic.update();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
