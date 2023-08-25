import 'dart:io';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/mine/settings/cs_set_user_name_page.dart';
import 'package:wms/customer/mine/settings/cs_set_agent_name_page.dart';
import 'package:wms/customer/mine/settings/cs_add_wechat_page.dart';

class CSSetUserInfoPage extends StatefulWidget {
  static final String sName = "enter";

  @override
  _CSSetUserInfoPageState createState() => _CSSetUserInfoPageState();
}

class _CSSetUserInfoPageState extends State<CSSetUserInfoPage> {
  /// 用户输入的密码
  String pwdData = '';

  String payPwd;
  final picker = ImagePicker();
  var sex = '2';

  /*
    GlobalKey：整个应用程序中唯一的键
    ScaffoldState：Scaffold框架的状态
    解释：_scaffoldKey的值是Scaffold框架状态的唯一键
   */
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void submit() {
    EasyLoadingUtil.showLoading();
    HttpServices.modifyUserInfo(
        params: {"payPassword": payPwd},
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

  void requestData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();

    var res = await HttpServices().getWeChatAccount();

    if (res['result']) {
      print(res['data']);
      EasyLoadingUtil.hidden();
      WMSUser.getInstance().weChatAccount = res['data'];
      ;
    } else {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: res['data']);
    }
  }

  @override
  void initState() {
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '个人资料设置',
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
          Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              alignment: Alignment.centerLeft,
              child: Text(
                '基本信息',
                style: TextStyle(fontSize: 18.sp, color: Colors.grey),
              )),
          itemSectionWidget(
            title: '头像',
            showIcon: false,
            child: GestureDetector(
              onTap: () {
                onTapHeadImageHandle();
              },
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  image: DecorationImage(
                      image: NetworkImage(
                          WMSUser.getInstance().userInfoModel.avatar ?? ''),
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          GestureDetector(
            /*onTap: () => Get.to(()=>
                  () => CSSetPayPwdPage(),
            ),*/
            child: itemSectionWidget(
                title: '手机号',
                showIcon: false,
                child: Container(
                    child: Text(
                      WMSUser.getInstance().userInfoModel.phoneNum,
                      style: TextStyle(color: Colors.grey),
                    ),
                    padding: EdgeInsets.only(right: 16.w))),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => CSSetUserNamePage())
                  .then((value) => {setState(() {})});
            },
            child: itemSectionWidget(
                title: '店铺名称',
                child: Text(WMSUser.getInstance().userInfoModel.nickName ??
                    WMSUser.getInstance().userInfoModel.userCode)),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    //构建弹框中的内容
                    return buildBottomSheetWidget(context);
                  });
            },
            child: itemSectionWidget(title: '性别', child: Text(getUserSex())),
          ),
          //待修改
          // GestureDetector(
          //   onTap: () => Get.to(
          //     () => CSSetAgentNamePage(),
          //   ),
          //   child: itemSectionWidget(
          //       title: '店铺名称',
          //       child: Text(WMSUser.getInstance().agentName ??
          //           WMSUser.getInstance().agentName)),
          // ),

          itemSectionWidget(
            title: '添加微信号',
            child: Text(WMSUser.getInstance().weChatAccount ?? ''),
            callback: () => Get.to(() => CSAddWechatPage()),
          ),
        ],
      ),
    );
  }

  // 点击头像
  void onTapHeadImageHandle() {
    WMSBottomSheet.showCameraSheet(context, handle1: () async {
      Get.back();
      if (await Permission.camera.request().isGranted) {
        _getCamera();
      }
    }, handle2: () async {
      Get.back();
      if (await Permission.camera.request().isGranted) {
        _getPhotoAlbum();
      }
    });
  }

  Future _getCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    uploadImage(
      File(pickedFile.path),
    );
  }

  Future _getPhotoAlbum() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    uploadImage(
      File(pickedFile.path),
    );
  }

  // 上传图片
  void uploadImage(File imageFile) async {
    EasyLoadingUtil.showLoading();
    HttpServices.requestOss(
        dir: AppGlobalConfig.imageType5,
        success: (data) async {
          String url = await HttpServices.asyncUpLoadImage(
            model: data,
            file: imageFile,
          );
          if (url == null) {
            EasyLoadingUtil.hidden();
            ToastUtil.showMessage(message: '上传图片失败');
            return;
          }
          requestModifyUserInfo(url);
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          print(error.toString());
        });
  }

  void requestModifyUserInfo(String url) {
    Map<String, dynamic> params = {
      'avatar': url,
    };
    HttpServices.modifyUserInfo(
        params: params,
        success: () {
          EasyLoadingUtil.hidden();
          WMSUser.getInstance().userInfoModel.avatar = url;
          SPUtils.saveUserInfo(WMSUser.getInstance().userInfoModel);
          setState(() {});
        },
        error: (e) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: e.message);
        });
  }

  getUserSex() {
    sex = WMSUser.getInstance().userInfoModel.sex;
    if (sex == '0') return '男';
    if (sex == '1') return '女';
    return '未知';
  }

  Widget buildBottomSheetWidget(BuildContext context) {
    //弹框中内容  310 的调试
    return Container(
      height: 155.sp,
      child: Column(
        children: [
          InkWell(
              child: Container(
                  height: 50.sp,
                  alignment: Alignment.center,
                  child: Text('男', style: TextStyle(fontSize: 16.sp))),
              onTap: () {
                submitSex('0');
              }),
          Divider(
            height: 1.sp,
            color: Colors.black87,
          ),
          InkWell(
              child: Container(
                  height: 50.sp,
                  alignment: Alignment.center,
                  child: Text('女', style: TextStyle(fontSize: 16.sp))),
              onTap: () {
                submitSex('1');
              }),
          Divider(
            height: 1.sp,
            color: Colors.black87,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                height: 50.sp,
                alignment: Alignment.center,
                child: Text("取消", style: TextStyle(fontSize: 16.sp))),
          )
        ],
      ),
    );
  }

  void submitSex(type) {
    EasyLoadingUtil.showLoading();
    HttpServices.modifyUserInfo(
        params: {"sex": type},
        success: () {
          EasyLoadingUtil.hidden();
          Navigator.of(context).pop();

          setState(() {
            sex = type;
          });
          ToastUtil.showMessage(message: '设置成功！');
          WMSUser.getInstance().userInfoModel.sex = type;
          SPUtils.saveUserInfo(WMSUser.getInstance().userInfoModel);
          // Navigator.of(context).pop();
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: error.message);
        });
  }

  Widget itemSectionWidget(
      {String title, VoidCallback callback, Widget child, bool showIcon}) {
    showIcon ??= true;
    child ??= Container();
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
            Container(
                child: Row(
              children: [
                child,
                showIcon
                    ? Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      )
                    : Container()
              ],
            )),
          ],
        ),
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
}
