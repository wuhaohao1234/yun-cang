import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_size_tag_widget.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/models/orderShow_model.dart';

import 'shopping_cart_page_logic.dart';
import 'shopping_cart_page_state.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final ShoppingCartPageLogic logic = Get.put(ShoppingCartPageLogic());
  final ShoppingCartPageState state = Get.find<ShoppingCartPageLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '购物车',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: SafeArea(
        child: GetBuilder<ShoppingCartPageLogic>(
          builder: (_) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.newOrderDataMap?.length ?? 0,
                    itemBuilder: (context, index) {
                      String key = state.newOrderDataMap.keys.elementAt(index);
                      OrderShowModel _item = state.newOrderDataMap[key];
                      WmsUserOrderDetailsList _itemChild =
                          _item.wmsUserOrderDetailsList[0];
                      return CheckboxListTile(
                        title: Container(
                          child: Row(
                            children: [
                              Image.network(
                                _item.wmsUserOrderDetailsList[0].picturePath,
                                fit: BoxFit.contain,
                                width: 50.w,
                                height: 50.w,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      _itemChild?.commodityName ?? '-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp),
                                    ),
                                    WMSText(
                                      content:
                                          '货号：${_itemChild?.stockCode ?? '-'}',
                                      color: Colors.grey,
                                      size: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            WMSSizeTagWidget(
                                              title: _itemChild?.size ?? '无尺码',
                                            ),
                                            SizedBox(width: 5.w),
                                            WMSSizeTagWidget(
                                              title: _itemChild?.color ?? '-',
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '￥${_itemChild?.appPrice ?? '-'}',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () =>
                                                  logic.onTapSubtractionHandle(
                                                      _itemChild),
                                              child: Container(
                                                color: Colors.grey[200],
                                                alignment: Alignment.center,
                                                width: 30.w,
                                                height: 24.w,
                                                child: WMSText(content: '-'),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Container(
                                              color: Colors.grey[200],
                                              alignment: Alignment.center,
                                              width: 30.w,
                                              height: 24.w,
                                              child: WMSText(
                                                content:
                                                    _itemChild.count.toString(),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            GestureDetector(
                                              onTap: () => logic
                                                  .onTapAddHandle(_itemChild),
                                              child: Container(
                                                color: Colors.grey[200],
                                                alignment: Alignment.center,
                                                width: 30.w,
                                                height: 24.w,
                                                child: WMSText(content: '+'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        value: _item?.selected ?? false,
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (v) => logic.itemOnChanged(v, key),
                        // onChanged: (value) {
                        //   print('value $value');
                        //   _item.selected = value;
                        //   logic.update();
                        // },
                      );
                    },
                  ),
                ),
                // Text('${state.allCheckbox}'),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            logic.onChangedAllCheckbox(state.allCheckbox),
                        child: Row(
                          children: [
                            Checkbox(
                              value: state.allCheckbox,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              tristate: true,
                              onChanged: (_) =>
                                  logic.onChangedAllCheckbox(state.allCheckbox),
                            ),
                            Text(
                              '全选',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14.sp),
                              children: [
                                TextSpan(text: '价格:\r'),
                                TextSpan(
                                  text: '123.0',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 15.w),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size(90.w, 32.w),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            onPressed: () {
                              logic.submit();
                            },
                            child: Text(
                              '结算',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<ShoppingCartPageLogic>();
    super.dispose();
  }
}
