// 仓库端个人信息页面
import 'dart:io';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:image_picker/image_picker.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/customer/login/pages/cs_login_page.dart';
import 'package:wms/models/mine/user_info_model.dart';
import 'package:wms/views/common/common_style_widget.dart';
// import 'en_main_page.dart';

class ENHomePage extends StatefulWidget {
  @override
  _ENHomePageState createState() => _ENHomePageState();
}

class _ENHomePageState extends State<ENHomePage> {
  final picker = ImagePicker();
  TextEditingController agentController = new TextEditingController();
  TextEditingController nameC = TextEditingController();
  UserInfoModel userInfo;
  @override
  void initState() {
    super.initState();
    EventBusUtil.getInstance().on<ReLogin>().listen((event) {
      String phone = WMSUser.getInstance().userInfoModel.phoneNum;
      WMSUser.getInstance().logOut();
      Get.offAll(CSLoginPage(
        phone: phone,
      ));
    });

    userInfo = WMSUser.getInstance().userInfoModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          // IconButton(
          //     icon: Icon(
          //       Icons.settings,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {})
        ],
      ),
      body: SafeArea(
        child: Container(
          child: ScrollConfiguration(
            behavior: JKOverScrollBehavior(),
            child: Column(
              children: [
                Expanded(child: drawer()),
                Container(
                  padding: EdgeInsets.only(bottom: 20.h),
                  // margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // buildButtonWidget(
                      //   width: 120.w,
                      //   height: 34.h,
                      //   radius: 2.0,
                      //   buttonContent: '切换账号',
                      //   handelClick: () {
                      //     String phone =
                      //         WMSUser.getInstance().userInfoModel.phoneNum;
                      //     WMSUser.getInstance().logOut();
                      //     Get.offAll(CSLoginPage(
                      //       phone: phone,
                      //     ));
                      //   },
                      // ),
                      GestureDetector(
                        onTap: () {
                          String phone =
                              WMSUser.getInstance().userInfoModel.phoneNum;
                          WMSUser.getInstance().logOut();
                          Get.offAll(CSLoginPage(
                            phone: phone,
                          ));
                        },
                        child: Container(
                          width: 343.w,
                          height: 34.h,
                          // margin: EdgeInsets.only(bottom: 20.h),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget drawer() {
    return Container(
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 20.h,
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  onTapHeadImageHandle();
                },
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    image: DecorationImage(
                        image: '${WMSUser.getInstance().userInfoModel.avatar}' !=
                                ""
                            ? NetworkImage(
                                '${WMSUser.getInstance().userInfoModel.avatar}')
                            : AssetImage('assets/images/avatar_default.png'),
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                  onTap: () {
                    nameC.text = WMSUser.getInstance().userInfoModel.nickName;
                    WMSDialog.showTextFieldDialog(context, nameC, () {
                      if (nameC.text.length == 0) {
                        return;
                      }
                      requestModifyNickName(nameC.text);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WMSText(
                        content: userInfo?.nickName ?? '请设置昵称',
                        bold: true,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Icon(
                        Icons.edit,
                        size: 12.sp,
                        color: Colors.grey,
                      ),
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Column(
            children: [
              buildProfileItem(
                  icon: Icons.person_pin_circle_outlined,
                  title: '员工编号',
                  value: WMSUser.getInstance().userInfoModel.userCode),
              buildProfileItem(
                  icon: Icons.person_outline_outlined,
                  title: '手机号码',
                  value: WMSUser.getInstance().userInfoModel.phoneNum),
              buildProfileItem(
                  icon: Icons.new_releases_outlined,
                  title: '员工职位',
                  value: '仓库管理'),
              buildProfileItem(
                  icon: Icons.timelapse,
                  title: '登记时间',
                  value:
                      '${WMSUser.getInstance().userInfoModel.createTime.substring(0, 11)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProfileItem({IconData icon, String title, String value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 8.w,
          ),
          WMSText(
            size: 16,
            content: title + '：' + value.toString() ?? '',
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

  void requestModifyAvatar(String avatar) {
    Map<String, dynamic> params = {'avatar': avatar};
    HttpServices.modifyUserInfo(
        params: params,
        success: () {
          EasyLoadingUtil.hidden();
          WMSUser.getInstance().userInfoModel.avatar = avatar;
          SPUtils.saveUserInfo(WMSUser.getInstance().userInfoModel);
          setState(() {});
        },
        error: (e) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: e.message);
        });
  }

  void requestModifyNickName(String nickName) {
    Map<String, dynamic> params = {'nickName': nickName};
    HttpServices.modifyUserInfo(
        params: params,
        success: () {
          EasyLoadingUtil.hidden();
          WMSUser.getInstance().userInfoModel.nickName = nickName;
          SPUtils.saveUserInfo(WMSUser.getInstance().userInfoModel);
          setState(() {});
        },
        error: (e) {
          EasyLoadingUtil.hidden();
          ToastUtil.showMessage(message: e.message);
        });
  }
}
