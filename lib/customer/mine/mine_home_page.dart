import 'dart:io';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wms/common/baseWidgets/wms_bottom_sheet.dart';
import 'package:wms/configs/wms_user.dart';
import 'cs_address_manage_page.dart';
import 'cs_settings_page.dart';
import 'wallet/cs_wallet_account_page.dart';
import 'package:wms/customer/zaishou/cs_zaishou_tab_page.dart';
import 'package:wms/customer/storage/zizhucang/cs_zizhucang_page.dart';
import 'package:wms/test_user_settings.dart';

class MineHomePage extends StatefulWidget {
  @override
  _MineHomePageState createState() => _MineHomePageState();
}

class _MineHomePageState extends State<MineHomePage> {
  final picker = ImagePicker();
  TextEditingController agentController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {
                Get.to(() => CSSettingsPage()).then((value) => {setState(() {})});
              })
        ],
      ),
      body: Container(
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: ListView(
            children: [
              if (AppConfig.testUsers.contains(WMSUser.getInstance().userInfoModel.phoneNum)) TestUserExtraSettings(),
              userInfoSection(),
              SizedBox(
                height: 8.h,
              ),
              Visibility(
                  child: itemSectionWidget(
                    title: '钱包账户',
                    // iconData:
                    // Icon(Icons.account_balance_wallet_rounded, size: 18.w),
                    iconData: SvgPicture.asset(
                      'assets/svgs/人民币.svg',
                      width: 15.w,
                    ),
                    callback: () => Get.to(
                      () => CSWalletAccountPage(),
                    ),
                  ),
                  visible: WMSUser.getInstance().depotPower),
              Visibility(
                  child: itemSectionWidget(
                    title: '我的在售',
                    iconData: SvgPicture.asset(
                      'assets/svgs/我的在售.svg',
                      width: 15.w,
                    ),
                    callback: () => Get.to(
                      // () => CSWalletAccountPage(),
                      () => CSZaiShouTabPage(defaultIndex: 0),
                    ),
                  ),
                  visible: WMSUser.getInstance().depotPower)
              //海关审核需取消
              ,
              //海关审核需取消
              Visibility(
                  child: itemSectionWidget(
                    title: '自主仓-新品申请',
                    iconData: SvgPicture.asset(
                      'assets/svgs/自主仓-新品申请.svg',
                      width: 15.w,
                    ),
                    callback: () => Get.to(
                      // () => CSWalletAccountPage(),
                      () => CSZiZhuCangPage(),
                    ),
                  ),
                  visible: WMSUser.getInstance().depotPower),
              itemSectionWidget(
                  title: '地址管理',
                  iconData: SvgPicture.asset(
                    'assets/svgs/地址.svg',
                    width: 12.w,
                    color: Colors.black,
                  ),
                  callback: () {
                    Get.to(() => CSAddressManagePage());
                  }),
              // itemSectionWidget(
              //     title: '切换商家',
              //     iconData: Icons.group,
              //     callback: () {
              //       String phone = WMSUser.getInstance().userInfoModel.phoneNum;
              //       WMSUser.getInstance().logOut();
              //       Get.offAll(CSLoginPage(
              //         phone: phone,
              //       ));
              //       // Get.to(() => CSAddressManagePage());
              //     }),
              // itemSectionWidget(
              //     title: '全球云仓地址',
              //     iconData: Icons.emoji_transportation_rounded,
              //     callback: () {
              //       Get.to(() => YcAddressPage());
              //     }),
              //海关审核需取消
              Visibility(
                  child: GestureDetector(
                    onTap: () {
                      // getCustomer();
                    },
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 8.h),
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Icon(Icons.person),
                              SvgPicture.asset(
                                'assets/svgs/切换运营商.svg',
                                width: 15.w,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                '运营商: ${WMSUser.getInstance().agentName ?? ''}',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          // Icon(
                          //   Icons.chevron_right,
                          //   color: Colors.black,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  visible: WMSUser.getInstance().depotPower)

              // // itemSectionWidget(title: '电话客服', iconData: Icons.headset_mic_outlined, callback: () {}),
            ],
          ),
        ),
      ),
    );
  }

  // 用户信息
  Widget userInfoSection() {
    String imagePath = WMSUser.getInstance().userInfoModel.avatar ?? '';
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // 头像
          GestureDetector(
            onTap: () {
              onTapHeadImageHandle();
            },
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                image: DecorationImage(image: NetworkImage(imagePath), fit: BoxFit.contain),
              ),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "客户代码：${WMSUser.getInstance().userInfoModel.userCode}",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "手机号：${WMSUser.getInstance().userInfoModel.phoneNum}",
                style: TextStyle(fontSize: 15.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemSectionWidget({String title, Widget iconData, VoidCallback callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconData,
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
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

  Future getCustomer() async {
    print(WMSUser.getInstance().token);
    EasyLoadingUtil.showLoading();
    final data = await HttpServices().getAgentListNew();
    if (data == false) {
      EasyLoadingUtil.hidden();
      ToastUtil.showMessage(message: "请求失败");
      return false;
    }
    if (data != null) {
      EasyLoadingUtil.hidden();
      return showModalBottomSheet(
          context: context,
          isScrollControlled: true, //允许bottomSheet高度自定义
          backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
          builder: (BuildContext c) {
            return StatefulBuilder(builder: (context, setState) {
              return ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: Container(
                  color: Colors.grey[50],
                  child: IntrinsicHeight(
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      width: 375.w,
                      height: 400.h,
                      color: Colors.grey[50],
                      constraints: BoxConstraints(maxHeight: 500.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          agentCodeInputWidget(setState),
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                              child: data.length != 0
                                  ? ListView.builder(
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          alignment: Alignment.center,
                                          child: MaterialButton(
                                              minWidth: double.infinity,
                                              color: Colors.white,
                                              highlightElevation: 0,
                                              elevation: 0,
                                              child: Text(
                                                data[index]?.agentName,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: data[index].isChecked != null && data[index].isChecked
                                                        ? Colors.grey
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              onPressed: data[index].isChecked != null && data[index].isChecked
                                                  ? null
                                                  : () => changeAgent(data[index].agentId)),
                                        );
                                      })
                                  : Center(child: Text('未查询到其他运营商'))),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          });
    }
  }

// 切换运营商
  void changeAgent(int agentId) async {
    EasyLoadingUtil.showLoading();
    HttpServices.changeAgent(
        agentId: agentId,
        success: (data) {
          WMSUser.getInstance().agentName = data['agentName'];
          SPUtils.saveAgentName(data['agentName']);
          WMSUser.getInstance().token = data['token'];
          SPUtils.saveToken(data['token']);
          setState(() {});
          ToastUtil.showMessage(message: "切换成功");
          EasyLoadingUtil.hidden();
          Navigator.pop(context);
        },
        error: (error) {
          EasyLoadingUtil.hidden();
          print(error.toString());
        });
  }

  Widget agentCodeInputWidget(setState) {
    return Container(
      padding: EdgeInsets.only(left: 6.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              controller: agentController,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
              onChanged: (e) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: '请输入运营商编号',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 13.sp),
              ),
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: agentController.text == '' ? Colors.grey : Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Text(
                '添 加',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () {
              agentController.text == '' ? null : addAgentCode();
            },
          )
        ],
      ),
    );
  }

  addAgentCode() {
    EasyLoadingUtil.showLoading();
    HttpServices.addAgent(
        params: {'agentCode': agentController.text},
        success: (data) {
          agentController.text = '';
          changeAgent(data);
        },
        error: (error) {
          ToastUtil.showMessage(message: error.message);
          EasyLoadingUtil.hidden();
          print(error.toString());
        });
  }
}
