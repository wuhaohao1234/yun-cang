import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/wms_user.dart';

import 'package:wms/configs/app_style_config.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/sp_utils.dart';
import 'package:wms/utils/toast_util.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CSSetAgentNamePage extends StatefulWidget {
  static final String sName = "enter";

  @override
  _CSSetAgentNamePageState createState() => _CSSetAgentNamePageState();
}

class _CSSetAgentNamePageState extends State<CSSetAgentNamePage> {
  /// 用户输入的密码
  String pwdData = '';

  String payPwd;
  final picker = ImagePicker();

  /*
    GlobalKey：整个应用程序中唯一的键
    ScaffoldState：Scaffold框架的状态
    解释：_scaffoldKey的值是Scaffold框架状态的唯一键
   */
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var textEditingController = new TextEditingController();
  var focusNode = new FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      bool focus = focusNode.hasFocus;
      print(focus.toString());
      if (focus == false) {
        textEditingController.text =
            textEditingController.text.replaceAll(" ", "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '设置店铺名称',
          size: AppStyleConfig.navTitleSize,
        ),
        actions: <Widget>[
          Center(
              child: InkWell(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                child: Text('保存',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp))),
            onTap: () => handleSubmit(),
          ))
        ],
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
          Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              alignment: Alignment.centerLeft,
              child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: WMSUser.getInstance().agentName ?? '',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  maxLines: 1,
                  maxLength: 20,
                  focusNode: focusNode,
                  keyboardType: TextInputType.text,
                  controller: textEditingController,
                  onChanged: (e) {})),
        ],
      ),
    );
  }

  handleSubmit() async {
    focusNode.unfocus();
    if (textEditingController.text == '') {
      ToastUtil.showMessage(message: '请输入店铺名称');
    } else {
      submit();
    }
  }

  void submit() {
    EasyLoadingUtil.showLoading();
    HttpServices.modifyUserInfo(
        params: {"agentName": textEditingController.text},
        success: () {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: '设置成功！');
          WMSUser.getInstance().agentName = textEditingController.text;
          SPUtils.saveAgentName(WMSUser.getInstance().agentName);
          // SPUtils.saveUserInfo(WMSUser.getInstance().userInfoModel);
          Navigator.pop(context);
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }
}
