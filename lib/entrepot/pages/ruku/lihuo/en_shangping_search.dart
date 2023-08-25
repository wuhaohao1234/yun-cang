/*
商品搜索界面
在理货详情中点击搜索框进入
*/

// 单子搜索页面
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/entrepot/controllers/en_spu_search_controller.dart';
import 'package:wms/views/entrenpot/en_rkd_top_widget.dart';

// import 'en_shangpin_sku_list_page.dart';
import 'en_rkd_add_wares_page.dart';
import 'package:flutter_svg/svg.dart';
import 'en_shangping.dart';

// import 'package:get/get.dart';
import 'package:wms/models/entrepot/sku/en_shangpin_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/views/common/input_search_bar_widget.dart';

class SkuSearchPage extends StatelessWidget {
  /*商品搜索界面 */
  final String placeHolder; //提示文字
  final num prepareOrderId; // 预约入库id
  final String filledValue; //预先填写好的内容,可能是单号,也可能是货号.如果
  final num orderOperationalRequirements;

  // scanDirectly为 true, 则为扫码的单号

  // 用于扫码选择商品时
  final bool notFoundAndCreate; //默认找不到, 让用户创建商品.
  final callback;

  const SkuSearchPage(
      {Key key,
      this.prepareOrderId,
      this.placeHolder,
      this.filledValue,
      this.notFoundAndCreate: false,
      this.orderOperationalRequirements,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SpuSearchPageController pageController = Get.put(SpuSearchPageController(prepareOrderId));

    if (filledValue != null) {
      pageController.textC.text = filledValue;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('商品搜索'),
        leading: BackButton(
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              // 顶部搜索开始
              InputSearchBarWidget(
                  searchHinterText: placeHolder,
                  submitCallback: (value) {
                    print("1111111");
                    pageController.textC.text = value;
                    pageController.request(prepareOrderId);
                  },
                  cancelCallback: () {
                    print("222222");
                    pageController.textC.text = '';
                    pageController.request(prepareOrderId);
                  }),

              // 顶部搜索结束
              // 内容部分开始
              Expanded(
                child: Obx(() => ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        // if (this.notFoundAndCreate == true) {
                        //   return Text("找不到, 请用货号搜索");
                        // }
                        // ;
                        // 如果存在商品列表的话, 则渲染
                        if (pageController.dataLength.value != 0) {
                          return GestureDetector(
                            onTap: () {
                              // Get.to(() => ENShangPinSkuListPage(
                              //     spuId: pageController.dataSource[index].spuId,
                              //     prepareOrderId: prepareOrderId,
                              //     orderOperationalRequirements:
                              //         orderOperationalRequirements));
                              var dataModel;
                              print(prepareOrderId);
                              print(pageController.dataSource[index]);
                              print(pageController.dataSource[index].spuId);
                              var res = HttpServices.getSPuDetail(
                                  prepareOrderId: prepareOrderId,
                                  spuId: pageController.dataSource[index].spuId,
                                  success: (data) {
                                    print(data);
                                    dataModel = ENShangPingModel.fromJson(data);
                                    Get.to(() => ENShangPingPage(
                                          prepareOrderId: prepareOrderId,
                                          spuId: pageController.dataSource[index].spuId,
                                          skuId: ENShangPingModel.fromJson(data)
                                              .sysPrepareOrderSpuList
                                              .sysPrepareOrderSpuList[0]
                                              .skuId,
                                          dataModel: ENShangPingModel.fromJson(data),
                                          orderOperationalRequirements: orderOperationalRequirements,
                                          callback: () {
                                            callback();
                                            Get.back();
                                          },
                                        ));
                                  },
                                  error: (error) {
                                    EasyLoadingUtil.hidden();
                                    ToastUtil.showMessage(message: error.message);
                                  });

                              // Get.to(() => ENShangPingPage(
                              //     prepareOrderId: prepareOrderId,
                              //     spuId: pageController.dataSource[index].spuId,
                              //     // skuId: pageController
                              //     //     .dataModel
                              //     //     .value
                              //     //     .sysPrepareOrderSpuList
                              //     //     .sysPrepareOrderSpuList[index]
                              //     //     .skuId,
                              //     // dataModel: pageController.dataSource[index],
                              //     orderOperationalRequirements:
                              //         orderOperationalRequirements));
                            },
                            child: ENRkdDetailTopWidget(
                              spuShow: true,
                              picturePath: pageController.dataSource[index].picturePath,
                              name: pageController.dataSource[index].commodityName,
                              brandName: pageController.dataSource[index].brandName,
                              stockCode: pageController.dataSource[index].stockCode,
                              spu: pageController.dataSource[index].spuId,
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(top: 60.h),
                            child: Center(
                                child: GestureDetector(
                              onTap: () {
                                print(pageController.textC.text);
                                Get.to(() => ENRkdAddwaresPage(
                                        orderId: this.prepareOrderId,
                                        orderOperationalRequirements: orderOperationalRequirements)
                                    // wmsCommodityInfoVOList: detailController.data['wmsCommodityInfoVOList']
                                    );
                              },
                              child: Column(children: [
                                SvgPicture.asset(
                                  'assets/svgs/nofound.svg',
                                  width: 150.w,
                                ),
                                SizedBox(height: 20.h),
                                Text("暂无商品数据,点击添加商品")
                              ]),
                            )),
                          );
                        }
                      },
                      itemCount: pageController.dataLength.value == 0 ? 1 : pageController.dataSource.length,
                    )),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
