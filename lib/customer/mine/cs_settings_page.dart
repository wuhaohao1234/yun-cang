import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/login/pages/cs_login_page.dart';
import 'package:wms/customer/mine/settings/cs_logout_user_page.dart';
import 'package:wms/customer/mine/settings/cs_modify_pwd_page.dart';
import 'package:wms/customer/mine/settings/cs_set_user_info_page.dart';
import 'package:wms/customer/others/webview_page.dart';
import 'package:wms/common/baseWidgets/wms_web_page.dart';
import 'cs_about_page.dart';

class CSSettingsPage extends StatefulWidget {
  @override
  _CSSettingsPageState createState() => _CSSettingsPageState();
}

class _CSSettingsPageState extends State<CSSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '设置',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () => Get.to(
                    () => CSSetUserInfoPage(),
                  ),
                  child: itemSectionWidget(
                    title: '个人资料设置',
                  ),
                ),

                // GestureDetector(
                //   onTap: () => Get.to(
                //     () => CSSetPayPwdPage(),
                //   ),
                //   child: itemSectionWidget(
                //     title: '设置支付密码',
                //   ),
                // ),
                itemSectionWidget(
                  title: '修改登录密码',
                  callback: () => Get.to(
                    () => CSModifyPwdPage(),
                  ),
                ),

                itemSectionWidget(
                  title: '关于云仓',
                  callback: () => Get.to(() => CSAboutPage()),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.to(
                    () => WMSWebPage(
                      title: '用户协议',
                      url: AppGlobalConfig.userAAgreement,
                    ),
                  ),
                  child: itemSectionWidget(
                    title: '用户协议',
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.to(() => WebviewPage(
                        title: '隐私政策',
                        url: AppGlobalConfig.privacyAgreement,
                      )),
                  child: itemSectionWidget(
                    title: '隐私政策',
                  ),
                ),
                GestureDetector(
                  // onTap: () => Get.to(
                  //    () => CSCancelUserPage(),
                  // ),
                  onTap: () => Get.to(() => CSLogoutUserPage()),
                  child: itemSectionWidget(
                    title: '注销账户',
                  ),
                ),
              ],
            ),
            buildExitButtonWidget(),
          ],
        ),
      ),
    );
  }

  Widget itemSectionWidget({String title, VoidCallback callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Colors.grey[100],
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExitButtonWidget() {
    return GestureDetector(
      onTap: () {
        String phone = WMSUser.getInstance().userInfoModel.phoneNum;
        WMSUser.getInstance().logOut();
        Get.offAll(CSLoginPage(
          phone: phone,
        ));
      },
      child: Container(
        width: 343.w,
        height: 34.h,
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Text(
            '退出登录',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
