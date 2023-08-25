// 预约入库、提交页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:wms/utils/wms_check_util.dart';

typedef void CrossBorderVertifyCallback(model);

class CSCrossBorderVertifyPage extends StatefulWidget {
  final id;
  final CrossBorderVertifyCallback callback;
  final model;
  const CSCrossBorderVertifyPage({Key key, this.callback, this.id, this.model})
      : super(key: key);

  @override
  _CSCrossBorderVertifyPageState createState() =>
      _CSCrossBorderVertifyPageState();
}

class _CSCrossBorderVertifyPageState extends State<CSCrossBorderVertifyPage> {
  TextEditingController name;
  TextEditingController identifyCode;
  @override
  void initState() {
    super.initState();

    // requestOrderData();

    name = TextEditingController(text: widget.model.cardName);
    identifyCode = TextEditingController(text: widget.model.cardNum);
  }

//如何确保动态更新；
  bool checkInput() {
    if (name.text.length == 0) {
      ToastUtil.showMessage(message: '请确认是否提交姓名');
      return false;
    }
    if (identifyCode.text.length == 0) {
      ToastUtil.showMessage(message: '请确认是否提交身份证号');
      return false;
    }
    if (!WMSCheckUtil.isIdentifyCode(identifyCode.text)) {
      ToastUtil.showMessage(message: '身份证号格式错误');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              '填写实名信息',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10.0),
          WMSText(
            content: '根据海关规定，购买跨境商品需填写与付款账号一致的实名信息',
            color: Colors.grey,
            size: 12,
          ),
          WMSTextField(
            title: '姓名',
            hintText: '付款人真实姓名',
            keyboardType: TextInputType.text,
            controller: name,
          ),
          WMSTextField(
            title: '身份证',
            hintText: '付款人身份证号',
            keyboardType: TextInputType.text,
            controller: identifyCode,
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WMSButton(
                title: '取消',
                width: 120.w,
                bgColor: Colors.transparent,
                textColor: Colors.black,
                showBorder: true,
                callback: () {
                  Navigator.of(context).pop(false);
                },
              ),
              WMSButton(
                title: '保存',
                width: 120.w,
                bgColor: AppConfig.themeColor,
                textColor: Colors.white,
                showBorder: true,
                callback: () async {
                  print(name.text);
                  print(identifyCode.text);

                  if (checkInput() == true) {
                    EasyLoadingUtil.showLoading();
                    var res = await HttpServices().perfectInfo(
                      id: widget.id,
                      userName: name.text,
                      cardNum: identifyCode.text,
                    );
                    if (res['result'] == false) {
                      EasyLoadingUtil.hidden();
                      EasyLoadingUtil.showMessage(message: res['data']);
                      return false;
                    }

                    if (res['result']) {
                      print("cool");
                      EasyLoadingUtil.showMessage(message: '设置成功');
                      Navigator.of(context).pop(true);
                      // widget.callback(WMSUser.getInstance().userInfoModel);
                    } else {
                      return false;
                    }
                    // HttpServices.modifyUserInfo(
                    //     params: {
                    //       "cardName": name.text,
                    //       'cardNum': identifyCode.text
                    //     },
                    //     success: () {
                    //       EasyLoadingUtil.hidden();
                    //       ToastUtil.showMessage(message: '设置成功！');
                    //       WMSUser.getInstance().userInfoModel.cardName =
                    //           name.text;
                    //       WMSUser.getInstance().userInfoModel.cardNum =
                    //           identifyCode.text;
                    //       SPUtils.saveUserInfo(
                    //           WMSUser.getInstance().userInfoModel);
                    //       Navigator.of(context).pop(true);
                    //       widget.callback(WMSUser.getInstance().userInfoModel);
                    //     },
                    //     error: (error) {
                    //       EasyLoadingUtil.hidden();
                    //       ToastUtil.showMessage(message: error.message);
                    //       return false;
                    //     });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
