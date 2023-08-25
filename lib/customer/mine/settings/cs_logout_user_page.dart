import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/customer/login/pages/cs_login_page.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CSLogoutUserPage extends StatefulWidget {
  static final String sName = "enter";

  @override
  _CSLogoutUserPageState createState() => _CSLogoutUserPageState();
}

class _CSLogoutUserPageState extends State<CSLogoutUserPage> {
  /// 用户输入的密码
  String pwdData = '';

  String payPwd;
  final picker = ImagePicker();
  var times = 5;
  var timer;

  /*
    GlobalKey：整个应用程序中唯一的键
    ScaffoldState：Scaffold框架的状态
    解释：_scaffoldKey的值是Scaffold框架状态的唯一键
   */
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (times == 0) {
        timer.cancel();
      } else {
        setState(() {
          times = times - 1;
        });
      }
      // 取消定时器
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: WMSText(
            content: '账户注销',
            size: AppStyleConfig.navTitleSize,
          )),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext c) {
    return Container(
      width: double.maxFinite,
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              '账户注销',
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
            child: Text(
              '您在云仓的身份信息、账号信息等会员权益将被清空无法恢复。您在云仓的所有交易记录将被清空。',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              color: Colors.grey[200],
              child: Column(children: [
                ListTile(
                  minLeadingWidth: 20.w,
                  leading: Text('·', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)),
                  title:
                      Text("账号近期不存在交易：您的账号近15天内未有过交易记录、近3个月内为发布过出售商品等。", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  minLeadingWidth: 20.w,
                  leading: Text('·', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)),
                  title: Text("账号不存在进行中的违规记录：您的账号不存在正在进行中的违规处罚或权限记录", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ListTile(
                    minLeadingWidth: 20.w,
                    leading: Text('·', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)),
                    title: Text("账号相干财产权益以结清：您的账号不存在冻结中的商品保证金、账号在云仓产生的任何财产余额等",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Divider(),
                ListTile(
                    minLeadingWidth: 20.w,
                    leading: Text('', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)),
                    title: Text(
                      "云仓注销：请确保所有交易已完结且无纠纷，账号注销后因历史交易可能产生的退换货、维权相关的资金退回等权益将视为自动放弃。",
                      style: TextStyle(color: Colors.grey),
                    ))
              ])),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              width: double.maxFinite,
              child: MaterialButton(
                child: Text("确定注销" + (times == 0 ? "" : "(" + times.toString() + ")"),
                    style: TextStyle(color: Colors.white)),
                color: Colors.black,
                disabledColor: Colors.grey,
                onPressed: times == 0 ? () => submit() : null,
              ))
        ],
      ),
    );
  }

  void submit() {
    EasyLoadingUtil.showLoading();
    HttpServices.modifyUserInfo(
        params: {"status": "1"},
        success: () {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: '账号已注销！');
          Future.delayed(Duration(milliseconds: 500), () => logOut());
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  logOut() {
    WMSUser.getInstance().logOut();
    Get.offAll(CSLoginPage(
      phone: '',
    ));
  }
}
