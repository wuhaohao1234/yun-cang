/*
* 客户端-订单管理模块-待支付
* * */
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/customer/order_cell_widget.dart';

import 'controllers/cs_order_page_controller.dart';
import 'controllers/cs_order_nav_bar_controller.dart';

class CSOrderListPage extends StatefulWidget {
  final String orderStatus;
  const CSOrderListPage({Key key, this.orderStatus}) : super(key: key);

  @override
  _CSOrderListPageState createState() => _CSOrderListPageState();
}

class _CSOrderListPageState extends State<CSOrderListPage> {
  @override
  Widget build(BuildContext context) {
    print('widget.orderStatus ${widget.orderStatus}');
    // print(EventBusUtil.getInstance().on<ChangeOrderModel>());
    Get.delete<CSOrderPageController>();
    CSOrderNavBarController navController = Get.put(CSOrderNavBarController());
    print(navController.model.value);
    CSOrderPageController pageController = Get.put(
        CSOrderPageController(navController.model.value, widget.orderStatus));
    return Container(
      child: ScrollConfiguration(
        behavior: JKOverScrollBehavior(),
        child: Obx(
          () => RefreshView(
            header: MaterialHeader(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ),
            onRefresh: pageController.onRefresh,
            onLoad: pageController.canMore.value ? pageController.onLoad : null,
            child: pageController.dataSource.length == 0
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    alignment: Alignment.center,
                    child: WMSText(
                      content: '暂无数据～',
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return OrderCellWidget(
                        state: widget.orderStatus,
                        type: navController.model.value,
                        dataModel: pageController.dataSource[index],
                        callBack: () {
                          pageController.requestData();
                        },
                      );
                    },
                    itemCount: pageController.dataSource.length,
                  ),
          ),
        ),
      ),
    );
  }
}
