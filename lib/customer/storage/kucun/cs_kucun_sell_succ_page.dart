import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/customer/main/cs_main_page.dart';
import 'cs_kucun_page.dart';
import 'cs_kucun_sale_xiaci_page.dart';
import 'cs_kucun_sale_page.dart';

class CSkuCunSellSuccessPage extends StatefulWidget {
  final model;
  final depotId;
  final spuId;
  final status;
  const CSkuCunSellSuccessPage(
      {Key key, this.model, this.depotId, this.spuId, this.status = "0"})
      : super(key: key);

  @override
  _CSkuCunSellSuccessPageState createState() => _CSkuCunSellSuccessPageState();
}

class _CSkuCunSellSuccessPageState extends State<CSkuCunSellSuccessPage> {
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
                      '添加出售成功',
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
                        // Get.back();
                        print(widget.model);
                        print(widget.spuId);

                        if (widget.status == "1")
                          Get.to(
                              () => CSKuCunSaleXiaCiPage(
                                  depotId: widget.depotId,
                                  spuId: widget.spuId,
                                  model: widget.model),
                              preventDuplicates: true);
                        else
                          Get.to(
                              () => CSKuCunSalePage(
                                    depotId: widget.depotId,
                                    spuId: widget.spuId,
                                    model: widget.model,
                                  ),
                              preventDuplicates: true);
                      },
                      child: Text(
                        '继续销售',
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
                        Get.to(() => KuCunPage());
                      },
                      child: Text(
                        '库存页',
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
