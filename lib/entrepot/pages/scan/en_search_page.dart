// 单子搜索页面
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/entrepot/controllers/en_search_page_controller.dart';
import 'package:wms/views/entrenpot/ruku/en_rkd_cell.dart';
import 'package:wms/views/entrenpot/ruku/en_ybrkd_cell.dart';
import 'package:wms/views/entrenpot/chuku/en_fenjian_cell.dart';
import 'package:wms/views/entrenpot/ruku/en_wzd_cell.dart';
import '../ruku/lihuo/en_dailihuo_detail_page.dart';
import '../chuku/en_fenjian_detail_page.dart';
import '../ruku/qianshou/en_ybrk_detail_page.dart';
import 'package:flutter_svg/svg.dart';
import '../ruku/qianshou/en_ybrk_custome_qianshou_page.dart';
import '../ruku/en_wzd_detail_page.dart';
import 'package:wms/views/common/input_search_bar_widget.dart';
import 'package:wms/views/entrenpot/chuku/en_chucang_cell.dart';
import '../chuku/en_chucang_licun_page.dart';
import 'package:wms/models/entrepot/chuku/en_chucang_model.dart';

class ENSearchPage extends StatelessWidget {
  final List<String> listType;
  final String placeHolder;
  final String filledValue;
  const ENSearchPage(
      {Key key, this.listType, this.placeHolder, this.filledValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ENSearchPageController pageController = Get.put(ENSearchPageController());
    if (filledValue != null) {
      pageController.textC.text = filledValue;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('搜索'),
        leading: BackButton(
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
            child: Column(
          children: [
            InputSearchBarWidget(
              searchHinterText: placeHolder,
              scanHinterText: '扫码',
              submitCallback: (value) {
                pageController.textC.text = value;
                pageController.request(listType);
              },
              cancelCallback: () {
                pageController.textC.text = '';
              },
            ),
            Expanded(
              child: Obx(
                () {
                  return pageController.textC.text.length == 0 &&
                          pageController.dataLength.value == 0
                      ? Center(
                          child: Text("暂无数据，请输入内容进行查询"),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return pageController.textC.text.length != 0 &&
                                    pageController.dataLength.value == 0
                                ? Container(
                                    margin: EdgeInsets.only(top: 60.h),
                                    child: Center(
                                        child: GestureDetector(
                                      onTap: () {
                                        print(pageController.textC.text);
                                        Get.to(
                                          () => ENYbrkSignNoForecastPage(
                                              mailNo:
                                                  pageController.textC.text),
                                        );
                                      },
                                      child: Column(children: [
                                        SvgPicture.asset(
                                          'assets/svgs/nofound.svg',
                                          width: 150.w,
                                        ),
                                        SizedBox(height: 20.h),
                                        Text("无数据,点击进入无预约签收页面")
                                      ]),
                                    )),
                                  )
                                : listType.contains('mail')
                                    ? ENYbrkdCell(
                                        model: pageController
                                            .dataSourceMail[index],
                                        callback: () {
                                          print("coddsdsol");
                                          Get.to(
                                            () => ENYbrkDetailPage(
                                              orderId: pageController
                                                  .dataSourceMail[index]
                                                  ?.orderId,
                                              ybrkModel: pageController
                                                  .dataSourceMail[index],
                                            ),
                                          );
                                        },
                                      )
                                    : listType.contains('prepareOrder')
                                        ? DaiLiHuoCell(
                                            model: pageController
                                                .dataSource1[index],
                                            imgshow: true,
                                            callback: () {
                                              Get.to(
                                                () => ENDaiLihuoDetailPage(
                                                  instoreOrderId: pageController
                                                      .dataSource1[index]
                                                      .orderId,
                                                  // orderIndex: index,
                                                ),
                                              );
                                            },
                                          )
                                        : listType.contains('outStoreName')
                                            ? GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                    () => ENFenJianDetailPage(
                                                      outOrderId: pageController
                                                          .dataSourceFenJian[
                                                              index]
                                                          .outOrderId,
                                                    ),
                                                  );
                                                },
                                                child: ENFenJianCell(
                                                  model: pageController
                                                      .dataSourceFenJian[index],
                                                ))
                                            : listType.contains('chucang')
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                        () =>
                                                            ENFenJianDetailPage(
                                                          outOrderId: pageController
                                                              .dataSourceChuCang[
                                                                  index]
                                                              .outOrderId,
                                                        ),
                                                      );
                                                    },
                                                    child: ENChuCangCell(
                                                        model: pageController
                                                                .dataSourceChuCang[
                                                            index],
                                                        callback: () {
                                                          if (pageController
                                                                          .dataSourceChuCang[
                                                                      index][
                                                                  'temporaryExistenceType'] ==
                                                              0) {
                                                            print("cool");
                                                            Get.to(() => ENChuCangLinCunPage(
                                                                orderId: pageController
                                                                            .dataSourceChuCang[
                                                                        index][
                                                                    'wmsOutStoreId'],
                                                                model: ENChuCangModel.fromJson(
                                                                    pageController
                                                                            .dataSourceChuCang[
                                                                        index])));
                                                          }
                                                        },
                                                        outStoreType: 'will'))
                                                : (listType
                                                        .contains('wzdMailNo'))
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                            () => ENWzdDetailPage(
                                                                id: pageController
                                                                    .dataSource[
                                                                        index]
                                                                    .id,
                                                                dataModel:
                                                                    pageController
                                                                            .dataSource[
                                                                        index]),
                                                          );
                                                        },
                                                        child: ENWzdCell(
                                                          model: pageController
                                                                  .dataSource[
                                                              index],
                                                        ),
                                                      )
                                                    : Container();
                            // return ENYbrkdCell(
                            //   model: pageController.dataSourceMail[index],
                            //   callback: () {
                            //     print("cool");
                            //     Get.to(
                            //       () => ENYbrkDetailPage(
                            //         orderId: pageController
                            //             .dataSourceMail[index]?.orderId,
                            //         ybrkModel:
                            //             pageController.dataSourceMail[index],
                            //       ),
                            //     );
                            //   },
                            // );
                          },
                          // itemCount: pageController.dataLength.value,
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
