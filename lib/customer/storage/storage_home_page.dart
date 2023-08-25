/*
* 仓储管理主页
* */
import 'package:wms/customer/common.dart'; //页面通用依赖集合

import 'package:permission_handler/permission_handler.dart';

import 'package:wms/customer/storage/scan_test_page.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/jk_over_scroll_behavior.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/views/common/section_title_widget.dart';

import 'old/storage_home_page_controller.dart.old';
import '../../views/common/common_search_bar.dart';
import 'ybrk/cs_st_search_page.dart';
import 'wuzhudan/cs_wzj_page.dart';
import 'ybrk/cs_ybd_detail_page.dart';
import 'yichangdan/cs_ycj_page.dart';
import 'ybrk/cs_ybrk_tab_page.dart';
import 'chuku/cs_chuku_tab_page.dart';
import 'lincun/cs_lincun_tab_page.dart';
import 'kucun/cs_kucun_page.dart';
// import 'package:qrscan/qrscan.dart' as scanner;

// 支付页面测试

class StorageHomePage extends StatefulWidget {
  @override
  _StorageHomePageState createState() => _StorageHomePageState();
}

class _StorageHomePageState extends State<StorageHomePage> {
  var dataModel;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() => {});
    }
    requestData();
  }

  void requestData() {
    EasyLoadingUtil.showLoading();
    HttpServices.warehouseNum(success: (data) {
      EasyLoadingUtil.hidden();
      print(data);
      setState(() {
        dataModel = data;
      });
      EasyLoadingUtil.hidden();
    }, error: (error) {
      EasyLoadingUtil.hidden();
      ToastUtil.showMessage(message: error.message);
    });
  }

  Future<void> onRefresh() async {
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonSearchBar(
          searchCallBack: () {
            Get.to(() => CsStSearchPage());
          },
          scanCallBack: () {
            // _scan();
            scanTest();
          },
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            if (dataModel != null)
              Expanded(
                child: ScrollConfiguration(
                  behavior: JKOverScrollBehavior(),
                  child: RefreshView(
                    header: MaterialHeader(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    ),
                    onRefresh: onRefresh,
                    child: ListView(
                      children: [
                        SectionTitleWidget(title: '数据看板'),
                        buildDataKanbanWidget(),
                        SectionTitleWidget(title: '在库管理'),
                        buildStorageManage(),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget buildDataKanbanWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey[200],
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildKanbanItemWidget(
              title: '今日入仓', data: '${dataModel.nowNum ?? 0}'),
          buildKanbanItemWidget(title: '在仓总数', data: '${dataModel.num ?? 0}'),
          buildKanbanItemWidget(
              title: '今日出仓', data: '${dataModel.outNum ?? 0}'),
        ],
      ),
    );
  }

  Widget buildKanbanItemWidget({String title, String data}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          WMSText(
            content: data ?? '',
            bold: true,
            size: 20,
          ),
          SizedBox(
            height: 8.h,
          ),
          WMSText(
            content: title ?? '',
            size: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget buildStorageManage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey[200],
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: contentContainerWidget(
        child: [
          itemWidget(
              title: '入库单',
              iconData: Icon(Icons.send, color: Colors.white),
              bgColor: Colors.green,
              callback: () {
                Get.to(() => CSYbrkTabPage(defaultIndex: 0));
              }),
          itemWidget(
              title: '已出库',
              iconData: Icon(Icons.access_time_rounded, color: Colors.white),
              bgColor: Colors.yellow,
              callback: () {
                Get.to(() => CSChuKuTabPage(defaultIndex: 0));
              }),
          itemWidget(
              title: '异常件',
              iconData: Icon(Icons.error_outline, color: Colors.white),
              bgColor: Colors.grey,
              callback: () {
                Get.to(() => CSYcjPage());
              }),
          itemWidget(
              title: '无主件',
              iconData: Icon(Icons.menu_outlined, color: Colors.white),
              bgColor: Colors.blue,
              callback: () {
                Get.to(() => CSWzjPage());
              }),
          itemWidget(
              title: '库存',
              iconData:
                  Icon(Icons.store_mall_directory_rounded, color: Colors.white),
              bgColor: Colors.lightGreen,
              callback: () {
                // Get.to(() => CSKcPage());
                Get.to(() => KuCunPage());
              }),
          // itemWidget(
          //     title: '库存旧',
          //     iconData: Icons.store_mall_directory_rounded,
          //     bgColor: Colors.lightGreen,
          //     callback: () {
          //       Get.to(() => CSKcPage());
          //       // Get.to(() => KuCunPage());
          //     }),
          itemWidget(
              title: '临存',
              // iconData: Icons.store_mall_directory_rounded,
              iconData: SvgPicture.asset(
                'assets/svgs/临存.svg',
                width: 36.w,
                color: Colors.white,
              ),
              bgColor: Colors.lightGreen,
              callback: () {
                Get.to(() => CSLinCunTabPage(defaultIndex: 0));
              }),
          // 测试隐藏
          // itemWidget(
          //   title: '测试支付',
          //   iconData:
          //       Icon(Icons.store_mall_directory_rounded, color: Colors.white),
          //   bgColor: Colors.lightGreen,
          //   callback: () {
          //     Get.to(() => PaymentTestPage());
          //   },
          // ),
        ],
      ),
    );
  }

  Widget contentContainerWidget({@required List<Widget> child}) {
    return Container(
        child: Wrap(
      children: child,
    ));
  }

  Widget itemWidget(
      {String title, Widget iconData, Color bgColor, VoidCallback callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0.w),
        width: ((375 - 40) / 3).w,
        child: Center(
          child: Column(
            children: [
              Container(
                height: 50.w,
                width: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: Colors.black),
                child: Center(
                  //
                  child: iconData,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  scanTest() async {
    print('点击扫码按钮');
    await Permission.camera.request();
    Get.to(() => ScanTestPage()).then((value) {
      if (value != null) {
        HttpServices.enQueryByMailNo(
            mailNo: value,
            success: (data, total) {
              if (data != null && (data?.length ?? 0) > 0) {
                Get.to(() => CSYbdDetailPage(
                      orderId: data.first.orderId?.toString(),
                    ));
              } else {
                ToastUtil.showMessage(message: '未匹配到预约入库单');
              }
            },
            error: (error) {
              ToastUtil.showMessage(message: error.message);
            });
      }
    });
  }
}
