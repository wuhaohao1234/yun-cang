/*
* 客户端入-仓储管理模块-无主件详情页面
* */
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import '../controllers/cs_wzj_detail_page_controller.dart';
import 'package:wms/views/common/common_style_widget.dart';
import 'package:get/get.dart';
import 'package:wms/entrepot/pages/en_logistics_page.dart';

class CSWzjDetailPage extends StatelessWidget {
  final int id;

  CSWzjDetailPage({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CSWzjDetailPageController pageController =
        Get.put(CSWzjDetailPageController(id));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '无主单详情',
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
                      SectionTitleWidget(title: '基础信息'),
                      Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                          ),
                          child: infoSectionWidget(pageController)),
                      SectionTitleWidget(title: '图片'),
                      Obx(
                        () => WMSImageWrap(
                          imagePaths: pageController
                              .dataModel.value.ownerlessImg
                              ?.split(';'),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Obx(
                      () => WMSButton(
                        title: pageController.btnTitle.value,
                        bgColor: AppConfig.themeColor,
                        callback: pageController.btnable.value
                            ? () => pageController.onTapCommitHandle(context)
                            : null,
                      ),
                    )),
              ],
            )),
      ),
    );
  }

  Widget infoSectionWidget(CSWzjDetailPageController pageController) {
    return Obx(
      () => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoItemWidget(
                title: '无主单号：',
                content: pageController.dataModel.value.orderIdName ?? ''),
            Row(
              children: [
                Expanded(
                  child: infoItemWidget(
                      title: '物流单号：',
                      content: pageController.dataModel.value?.mailNo ?? '-'),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ENLogisticsPage(
                        dataCode: pageController.dataModel.value.mailNo));
                  },
                  child: stateWidget(
                    title: '查看物流',
                    bgColor: Colors.deepOrangeAccent,
                    contentColor: Colors.white,
                  ),
                )
              ],
            ),

            // Container(
            //         child: GestureDetector(
            //           onTap: () {
            //             Get.to(() => ENLogisticsPage(
            //                 dataCode: pageController.dataModel.value.mailNo));
            //           },
            //           child: stateWidget(
            //             title: '查看物流',
            //             bgColor: Colors.deepOrangeAccent,
            //             contentColor: Colors.white,
            //           ),
            //         ),
            //       ),
            infoItemWidget(
                title: '签收日期：',
                content: pageController.dataModel.value.createTime ?? ''),
            infoItemWidget(
                title: '仓库：',
                content: pageController.dataModel.value.depotName ?? ''),
          ],
        ),
      ),
    );
  }

  Widget buildImageWidget({
    String imagePath,
    int count,
  }) {
    return Container(
      alignment: Alignment(0, 0),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
              imagePath,
            ),
            fit: BoxFit.contain),
      ),
      child: Visibility(
        visible: count > 0,
        child: Text(
          "+$count",
          style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
