import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/main/cs_main_page.dart';
import 'cs_order_detail_page.dart';

class OrderSuccessPage extends StatefulWidget {
  final int id;
  const OrderSuccessPage({Key key, this.id}) : super(key: key);

  @override
  _OrderSuccessPageState createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_turned_in,
                      color: Colors.black,
                      size: 60.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      '下单成功',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 130.0),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Color(0xfff2f2f2),
                        // minimumSize: Size(80.w, 34.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      onPressed: () {
                        Get.offAll(() => CSMainPage());
                      },
                      child: Text(
                        '返回首页',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    OutlinedButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Color(0xfff2f2f2),
                        // minimumSize: Size(80.w, 34.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      onPressed: () {
                        // 跳转路由重新获取订单信息传递过去
                        // Get.to(() => CSOrderDetailPage(id: widget.id),
                        //     preventDuplicates: true);
                        Get.offAll(() => CSMainPage(defaultIndex: WMSUser.getInstance().depotPower?1:0));
                      },
                      child: Text(
                        '订单列表',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
