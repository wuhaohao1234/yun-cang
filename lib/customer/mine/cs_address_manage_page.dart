import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/customer/mine/address_cell_widget.dart';

import 'controllers/cs_address_manage_page_controller.dart';

class CSAddressManagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CSAddressManagePageController pageController =
        Get.put(CSAddressManagePageController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '地址管理',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            children: [
              Expanded(child: Obx(() {
                return RefreshView(
                  header: MaterialHeader(
                    valueColor:
                        AlwaysStoppedAnimation(AppStyleConfig.themColor),
                  ),
                  onRefresh: pageController.onRefresh,
                  onLoad: pageController.canMore.value
                      ? pageController.onLoad
                      : null,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      // print('pageController.dataSource[index] ${pageController.dataSource[index]}');
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.2,
                        child: Container(
                            color: Colors.white,
                            child: AddressCellWidget(
                              model: pageController.dataSource[index],
                              select: () {
                                Get.back(
                                    result: pageController.dataSource[index]);
                              },
                              callback: () {
                                print('huidiao');
                                pageController.toEditPage(index);
                              },
                            )),
                        secondaryActions: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 8.h),
                            child: IconSlideAction(
                              caption: '删除',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                WMSDialog.showOperationPromptDialog(context,
                                    content: "确认删除地址吗?", handle: () async {
                                  EasyLoadingUtil.showLoading();
                                  final result = await HttpServices().deleteAddress(
                                      id: pageController.dataSource[index].id);
                                  EasyLoadingUtil.hidden();
                                  if (result == true) {
                                    EasyLoadingUtil.showMessage(
                                        message: "删除成功");
                                 Get.find<CSAddressManagePageController>().requestData();
                                  } else {
                                    EasyLoadingUtil.showMessage(
                                        message: "删除失败: ${result.message}");
                                  }
                                }, cancelHandle: () {});
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: pageController.dataSource.length,
                  ),
                );
              })),
              buildAddButtonWidget(pageController),
            ],
          ),
        ),
      ),
    );
  }

  // 添加新地址按钮
  Widget buildAddButtonWidget(CSAddressManagePageController pageController) {
    return GestureDetector(
      onTap: pageController.toAddPage,
      child: Container(
        width: 343.w,
        height: 34.h,
        margin: EdgeInsets.only(bottom: 40.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: AppStyleConfig.btnColor,
        ),
        child: Center(
          child: Text(
            '添加新地址',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
