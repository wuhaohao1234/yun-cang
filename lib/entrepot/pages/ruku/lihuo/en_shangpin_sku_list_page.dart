// skuId搜索页面
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/entrepot/controllers/en_sku_search_controller.dart';
import 'en_shangping.dart';
import 'package:wms/views/entrenpot/en_sku_cell.dart';

class ENShangPinSkuListPage extends StatelessWidget {
  final num spuId; //spuId
  final num prepareOrderId; // 预约入库id
  final num orderOperationalRequirements;

  const ENShangPinSkuListPage({
    Key key,
    this.prepareOrderId,
    this.spuId,
    this.orderOperationalRequirements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SkuSearchPageController pageController =
        Get.put(SkuSearchPageController(prepareOrderId, spuId));

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.h),
              child: Container(
                height: 52.0,
                child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[200]),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 8.w,
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      onSubmitted: (value) {},
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.search,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(top: -8.h),
                                          hintStyle: TextStyle(fontSize: 13.sp),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: new Icon(Icons.cancel),
                                  color: Colors.grey,
                                  iconSize: 18.0,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.back(),
                          child: WMSText(
                            content: '取消',
                          ),
                        )
                      ],
                    )),
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      if (pageController.dataLength.value != 0) {
                        return GestureDetector(
                            onTap: () {
                              Get.to(() => ENShangPingPage(
                                  prepareOrderId: prepareOrderId,
                                  spuId: pageController.dataModel.value.spuId,
                                  skuId: pageController
                                      .dataModel
                                      .value
                                      .sysPrepareOrderSpuList
                                      .sysPrepareOrderSpuList[0]
                                      .skuId,
                                  dataModel: pageController.dataModel.value,
                                  orderOperationalRequirements:
                                      orderOperationalRequirements));
                            },
                            child: buildSkuWdidget(
                              pageController
                                  .dataModel
                                  .value
                                  .sysPrepareOrderSpuList
                                  .sysPrepareOrderSpuList[index],
                            ));
                      } else {
                        return Container(
                          margin: EdgeInsets.only(top: 60.h),
                          child: Center(
                            child: WMSText(
                              content: '暂无商品数据',
                            ),
                          ),
                        );
                      }
                    },
                    itemCount: pageController.dataLength.value == 0
                        ? 1
                        : pageController.dataLength.value,
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
