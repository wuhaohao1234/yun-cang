import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/customer/main/cs_main_page.dart';
// import '../chuku/cs_daichuku_detail_page.dart';
import '../chuku/cs_chuku_tab_page.dart';
import 'cs_kucun_page.dart';

class CSkuCunChuKuSuccessPage extends StatefulWidget {
  const CSkuCunChuKuSuccessPage({
    Key key,
  }) : super(key: key);

  @override
  _CSkuCunChuKuSuccessPageState createState() =>
      _CSkuCunChuKuSuccessPageState();
}

class _CSkuCunChuKuSuccessPageState extends State<CSkuCunChuKuSuccessPage> {
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
                      '出库指令已提交',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      '待仓库发货',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.blue[200],
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
                        Get.offAll(() => KuCunPage());
                      },
                      child: Text(
                        '库存页',
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
                        // TODO: 跳转路由重新获取订单信息传递过去
                        // ToastUtil.showMessage(message: '跳转路由重新获取订单信息传递过去');
                        // Get.to(() => CSOrderDetailPage(id: widget.id));
                        // Get.to(() => CSDaiChuKuDetailPage(
                        //       wmsOutStoreId: 0,
                        //     ));
                        //返回出库单列表；
                        Get.to(() => CSChuKuTabPage(
                              defaultIndex: 0,
                            ));
                      },
                      child: Text(
                        '出库单',
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
