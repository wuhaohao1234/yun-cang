import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合

import '../controllers/cs_wallet_account_page_controller.dart';
import 'cs_account_detail_pagae.dart';
import 'cs_withdraw_cash_page.dart';
import '../../main/cs_main_page.dart';

class CSWalletAccountPage extends StatefulWidget {
  @override
  _CSWalletAccountPageState createState() => _CSWalletAccountPageState();
}

class _CSWalletAccountPageState extends State<CSWalletAccountPage> {
  @override
  Widget build(BuildContext context) {
    CSWalletAccountPageController pageController = Get.put(CSWalletAccountPageController());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: WMSText(
            content: '钱包账户',
            size: AppStyleConfig.navTitleSize,
          ),
          leading: BackButton(
            onPressed: () {
              Get.offAll(() => CSMainPage(defaultIndex: WMSUser.getInstance().depotPower?3:2));
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Get.to(() => CSAccountDetailPagae()),
              // onPressed: () => Get.to(() => CSStorageAccountPage()),

              child: WMSText(
                content: '账户明细',
                size: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: RefreshView(
            header: MaterialHeader(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ),
            onRefresh: pageController.onRefresh,
            child: Column(
              children: [
                // buildWalletInfoWidget(),
                // buildButtonWidget(title: '充值',textColor: Colors.white,bgcolor: Colors.black,callback: (){}),
                // buildButtonWidget(title: '账户明细',textColor: Colors.black,bgcolor: Colors.grey[200],callback: (){
                //   Get.to(()=>CSAccountDetailPagae());
                // }),

                // buildTitleWidget(title: '商城保证金', tips: '商城商家保证金'),
                // Obx(
                //   () => buildFundRow(
                //     amount: pageController.bond.value,
                //     isW: true,
                //     callback1: () {},
                //   ),
                // ),
                // buildTitleWidget(title: '仓储账户', tips: '可支付仓储/物流费用'),
                // Obx(
                //   () => buildFundRow(
                //       amount: pageController.warehouseMoney.value,
                //       isU: true,
                //       callback2: () {}),
                // ),
                // buildTitleWidget(title: '店铺账户', tips: '订单支付/收款账户'),
                Obx(
                  () => buildFundRow(
                      shopMoney: pageController.shopMoney.value,
                      territoryMoney: pageController.territoryMoney.value,
                      abroadMoney: pageController.abroadMoney.value,
                      isW: true,
                      callback1: () {
                        Get.to(() => CSWithdrawCashPage());
                      },
                      callback2: () {}),
                )
              ],
            ),
          ),
        ));
  }

  // isW 可提现  isU 可充值
  // 提现回调 callback1  充值回调 callback2
  Widget buildFundRow(
      {double shopMoney,
      double territoryMoney,
      double abroadMoney,
      bool isW = false,
      bool isU = false,
      Function callback1,
      Function callback2}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WMSText(
                content: '账户总余额：¥${(territoryMoney??0)+(abroadMoney??0)}',
                bold: true,
                size: 18,
              ),
              Row(
                children: [
                  Visibility(
                    // visible: isW,
                    visible: false,
                    child:
                        // buildWithdrawalBtn(callback1)
                        buildButtonWidget(
                      buttonContent: '充值',
                      handelClick: callback1,
                      radius: 2.0,
                    ),
                  ),
                  Visibility(
                      visible: false,
                      // visible: isU,
                      child: SizedBox(
                        width: 16.w,
                      )),
                  Visibility(
                    visible: false,
                    // visible: isU,
                    child: buildButtonWidget(
                      buttonContent: '我的余额',
                      handelClick: callback2,
                      radius: 2.0,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              WMSText(
                content: '境内账户余额：¥$territoryMoney',
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              WMSText(
                content: '境外账户余额：¥$abroadMoney',
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            alignment: Alignment.centerLeft,
            child: WMSText(
              color: Colors.grey,
              content: '(提现请登录云仓后台管理系统)',
              bold: false,
              size: 12,
            ),
          )
        ],
      ),
    );
  }

//
// Widget buildWalletInfoWidget() {
//   return Container(
//       margin: EdgeInsets.symmetric(vertical: 40.h),
//       child: Center(
//         child: Column(children: [
//           Container(
//             width: 60.w,
//             height: 60.w,
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(30.r),
//             ),
//             child: Icon(
//               Icons.monetization_on_outlined,
//               color: Colors.white,
//               size: 30.w,
//             ),
//           ),
//           SizedBox(
//             height: 16.h,
//           ),
//           Text(
//             '账户余额',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
//           ),
//           SizedBox(
//             height: 16.h,
//           ),
//           Text.rich(TextSpan(children: [
//             TextSpan(
//               text: "¥  ",
//               style: TextStyle(fontSize: 13.sp),
//             ),
//             TextSpan(
//               text: '30000.00',
//               style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
//             ),
//           ])),
//         ]),
//       ));
// }
//
}
