import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_refresh_view.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/entrepot/controllers/en_logistics_page_controller.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/utils/wms_util.dart';
import 'package:wms/views/common/logistics_cell.dart';

class ENLogisticsPage extends StatelessWidget {
  final String dataCode;

  const ENLogisticsPage({Key key, this.dataCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ENLogisticsPageController pageController =
        Get.put(ENLogisticsPageController(dataCode));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '物流详情',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        child: Obx(
          () => pageController.dataModel.value == null
              ? Container(
                  padding: EdgeInsets.all(10.h),
                  child: Center(
                    child: Text("查询中"),
                  ),
                )
              : RefreshView(
                  header: MaterialHeader(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                  onRefresh: pageController.onRefresh,
                  child: pageController.dataModel.value.Traces.length == 0
                      ? Container(
                          padding: EdgeInsets.all(10.h),
                          child: Center(
                            child: Text("暂无物流轨迹信息"),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.w, horizontal: 16.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: Colors.black),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     WMSText(
                                    //       content:
                                    //           '运单号：${pageController.dataModel.value.LogisticCode ?? '无'}',
                                    //       color: Colors.white,
                                    //       bold: true,
                                    //     ),
                                    //     SizedBox(
                                    //       width: 8.w,
                                    //     ),
                                    //   ],
                                    // ),
                                    // WMSText(
                                    //   content:
                                    //       '运单号：${pageController.dataModel.value.LogisticCode ?? '无'}',
                                    //   color: Colors.white,
                                    //   bold: true,
                                    // ),
                                    // WMSText(
                                    //   content: WMSUtil.stateStringForState(
                                    //     pageController.dataModel.value.State,
                                    //   ),
                                    //   color: Colors.white,
                                    // ),
                                    Text(
                                      "运单号: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        '${pageController.dataModel.value.LogisticCode ?? '无'}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(text: '$dataCode'),
                                        ).then((value) {
                                          ToastUtil.showMessage(
                                              message: '复制成功');
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w, vertical: 2.h),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.h, color: Colors.white),
                                        ),
                                        child: WMSText(
                                          content: '复制',
                                          color: Colors.white,
                                          size: 13,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 50.w,
                                      child: Container(
                                        // color: Colors.red,
                                        child: Text(
                                          '${WMSUtil.stateStringForState(
                                                pageController
                                                    .dataModel.value.State,
                                              ) ?? '无'}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return LogisticsCell(
                              model: pageController.dataModel.value.Traces[
                                  pageController.dataModel.value.Traces.length -
                                      index],
                            );
                          },
                          itemCount:
                              pageController.dataModel.value.Traces?.length == 0
                                  ? 1
                                  : pageController
                                          .dataModel.value.Traces?.length +
                                      1,
                        ),
                ),
        ),
      ),
    );
  }
}
