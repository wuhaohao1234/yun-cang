import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/customer/storage/controllers/cs_st_search_page_controller.dart';
import 'package:wms/views/entrenpot/ruku/en_ybrkd_cell.dart';
// ignore: unused_import
import 'package:wms/views/common/common_style_widget.dart';
import 'package:wms/views/common/input_search_bar_widget.dart';
import '../ybrk/cs_ybd_detail_page.dart';

class CsStSearchPage extends StatelessWidget {
  const CsStSearchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CsStSearchPageController pageController =
        Get.put(CsStSearchPageController());
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
                  searchHinterText: '请输入物流单号',
                  scanHinterText: '扫码',
                  submitCallback: (value) {
                    pageController.requestYbrkd(value);
                  },
                  cancelCallback: () {
                    pageController.textC.text = '';
                    pageController.requestYbrkd('');
                  }),
              Expanded(
                child: Obx(
                  () {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        if (pageController.dataSource?.length == 0) {
                          return Container(
                            child: Center(
                              child: WMSText(
                                content: '暂无数据',
                              ),
                            ),
                          );
                        }

                        return ENYbrkdCell(
                          model: pageController.dataSource[index],
                          callback: () {
                            print(pageController.dataSource[index]);
                            Get.to(() => CSYbdDetailPage(
                                  orderId: pageController
                                      .dataSource[index].orderId
                                      ?.toString(),
                                  status:
                                      pageController.dataSource[index].status,
                                ));
                          },
                        );
                      },
                      itemCount: pageController.dataSource?.length == 0
                          ? 1
                          : pageController.dataSource?.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
