import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/customer/orders/cs_order_nav_bar.dart';
import 'controllers/cs_order_page_controller.dart';
import 'package:wms/customer/orders/cs_order_list_page.dart';
// import 'package:wms/customer/orders/controllers/cs_order_nav_bar_controller.dart';

// import 'package:wms/utils/event_bus_util.dart';
class OrderHomePage extends StatefulWidget {
  final int defaultIndex;

  const OrderHomePage({Key key, @required this.defaultIndex}) : super(key: key);

  @override
  _OrderHomePageState createState() => _OrderHomePageState();
}

class _OrderHomePageState extends State<OrderHomePage> with SingleTickerProviderStateMixin {
  List<String> _tabTitles = ['全部', '待付款', '待发货', '待收货', '已完成'];
  List<Widget> _pages = [
    CSOrderListPage(orderStatus: null),
    CSOrderListPage(orderStatus: "TO_PAY"),
    CSOrderListPage(orderStatus: "TO_DELIVERY"),
    CSOrderListPage(orderStatus: "TO_RECEIVE"),
    CSOrderListPage(orderStatus: "RECEIVED"),
  ];
  int activeIndex;
  TabController controller;
  var navStatus = 0;

  void initState() {
    super.initState();
    controller = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.defaultIndex ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabTitles.length,
      child: Scaffold(
        appBar: WMSUser.getInstance().depotPower
            ? AppBar(
                elevation: 0,
                centerTitle: true,
                //海关审核需取消
                title: CSOrderNavBar(),
                // title: WMSText(
                //   content: "订单",
                // ),
              )
            : null,
        body: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Container(
            child: Column(
              children: [
                WMSUser.getInstance().depotPower
                    ? SizedBox(
                        height: 0,
                      )
                    : SizedBox(
                        height: 32.h,
                      ),
                TabBar(
                  // controller: controller,
                  indicatorColor: AppStyleConfig.themColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: AppStyleConfig.themColor,
                  unselectedLabelColor: Colors.black,
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                  tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: _pages,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CSOrderNavBarNew() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              navStatus = 0;
              EventBusUtil.getInstance().fire(
                ChangeOrderModel(0),
              );
            });
          },
          child: Container(
            width: 120.w,
            height: 34.h,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Color(0xfff2f2f2)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              color: navStatus == 0 ? Colors.white : Color(0xfff2f2f2),
            ),
            child: Center(
              child: WMSText(
                content: '出售',
                bold: navStatus == 0,
                color: navStatus == 0 ? Colors.black : Color(0xff666666),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              navStatus = 1;
              EventBusUtil.getInstance().fire(
                ChangeOrderModel(1),
              );
            });
          },
          child: Container(
              width: 120.w,
              height: 34.h,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Color(0xfff2f2f2)),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                color: navStatus == 1 ? Colors.white : Color(0xfff2f2f2),
              ),
              child: Center(
                  child: WMSText(
                content: '购买',
                bold: navStatus == 1,
                color: navStatus == 1 ? Colors.black : Color(0xff666666),
              ))),
        ),
      ],
    );
  }
}
