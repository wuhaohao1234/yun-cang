import 'package:flutter/material.dart';
import 'package:wms/common/payPwd/key_event.dart';
import 'package:wms/common/payPwd/wms_custom_password_field.dart';
import 'package:wms/common/payPwd/wms_keyboard.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/sp_utils.dart';
import 'package:wms/utils/toast_util.dart';

class CSSetPayPwdPage extends StatefulWidget {
  static final String sName = "enter";

  @override
  _CSSetPayPwdPageState createState() => _CSSetPayPwdPageState();
}

class _CSSetPayPwdPageState extends State<CSSetPayPwdPage> {
  /// 用户输入的密码
  String pwdData = '';

  String payPwd;

  /*
    GlobalKey：整个应用程序中唯一的键
    ScaffoldState：Scaffold框架的状态
    解释：_scaffoldKey的值是Scaffold框架状态的唯一键
   */
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // VoidCallback：没有参数并且不返回数据的回调
  VoidCallback _showBottomSheetCallback;

  void submit(){
    EasyLoadingUtil.showLoading();
    HttpServices.modifyUserInfo(
        params: {
          "payPassword":payPwd
        },
        success: () {
          EasyLoadingUtil.hidden();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          ToastUtil.showMessage(message: '设置成功！');
          WMSUser.getInstance().userInfoModel.payPassword = '******';
          SPUtils.saveUserInfo(WMSUser.getInstance().userInfoModel);
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  @override
  void initState() {
    _showBottomSheetCallback = _showBottomSheet;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '设置支付密码',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext c) {
    return Container(
      width: double.maxFinite,
      color: Color(0xffffffff),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: WMSText(
              content: payPwd == null ? '设置6位数支付密码' : '再次确认支付密码',
              size: 13,
            ),
          ),

          ///密码框
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: _buildPwd(pwdData),
          ),
        ],
      ),
    );
  }

  /// 密码键盘 确认按钮 事件
  void onAffirmButton() {
    if (payPwd == null) {
      payPwd = pwdData;
      pwdData = '';
    } else {
      if (payPwd == pwdData) {
        // 发送请求
        print('密码一致，发送请求');
        print('payPwd = $payPwd');
        print('pwdData = $pwdData');
        submit();

      } else {
        print('密码不一致，重设');
        ToastUtil.showMessage(message: '密码不一致，请重新设置');
        print('payPwd = $payPwd');
        print('pwdData = $pwdData');
        payPwd = null;
        pwdData = '';
      }
    }

    setState(() {});
  }

  /// 密码键盘的整体回调，根据不同的按钮事件来进行相应的逻辑实现
  void _onKeyDown(KeyEvent data) {
// 如果点击了删除按钮，则将密码进行修改
    if (data.isDelete()) {
      if (pwdData.length > 0) {
        pwdData = pwdData.substring(0, pwdData.length - 1);
        setState(() {});
      }
    }
// 点击了确定按钮时
    else if (data.isCommit()) {
      if (pwdData.length != 6) {
//        Fluttertoast.showToast(msg: "密码不足6位，请重试", gravity: ToastGravity.CENTER);
        return;
      }
      onAffirmButton();
    }
//点击了数字按钮时  将密码进行完整的拼接
    else {
      if (pwdData.length < 6) {
        pwdData += data.key;
      }
      setState(() {});
    }
  }

  /// 底部弹出 自定义键盘  下滑消失
  void _showBottomSheet() {
    setState(() {
      // disable the button  // 禁用按钮
      _showBottomSheetCallback = null;
    });

    /*
      currentState：获取具有此全局键的树中的控件状态
      showBottomSheet：显示持久性的质感设计底部面板
      解释：联系上文，_scaffoldKey是Scaffold框架状态的唯一键，因此代码大意为，
           在Scaffold框架中显示持久性的质感设计底部面板
     */
    _scaffoldKey.currentState
        .showBottomSheet<void>((BuildContext context) {
          /// 将自定义的密码键盘作为其child   这里将回调函数传入
          return new MyKeyboard(_onKeyDown);
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // re-enable the button  // 重新启用按钮
              _showBottomSheetCallback = _showBottomSheet;
            });
          }
        });
  }

  /// 构建 密码输入框  定义了其宽度和高度
  Widget _buildPwd(var pwd) {
    return new GestureDetector(
      child: new Container(
        width: 250.0,
        height: 40.0,
//      color: Colors.white,  自定义密码输入框的使用
        child: CustomJPasswordField(pwd),
      ),
// 用户点击输入框的时候，弹出自定义的键盘
      onTap: () {
        _showBottomSheetCallback();
      },
    );
  }
}
