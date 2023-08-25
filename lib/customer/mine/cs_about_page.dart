import 'dart:io';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/common/baseWidgets/wms_web_page.dart';
import 'package:wms/network/http_apis.dart';
import 'package:package_info/package_info.dart';

class CSAboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '关于云仓',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        color: Colors.white,
        // color: Colors.red,
        child: Column(
          children: [
            buildVersionInfoWidget(),
            GestureDetector(
              onTap: () => Get.to(
                () => WMSWebPage(
                  title: '公司官网',
                  url: HttpApis.aboutUs,
                ),
              ),
              child: itemSectionWidget(
                title: '公司官网',
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(
                    () => WMSWebPage(
                  title: '公司信息',
                  url: HttpApis.companyInfo,
                ),
              ),
              child: itemSectionWidget(
                title: '公司信息',
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                checkVersion(context);
              },
              child: itemSectionWidget(
                title: '检查更新',
              ),
            ),
            Spacer(),
            // 版权声明
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                children: [Text("Copyright © 2018-2022"), Text("斐宁唯选  版权所有")],
              ),
            )
          ],
        ),
      ),
    );
  }

  // check Version
  void checkVersion(BuildContext context) {
    EasyLoadingUtil.showLoading();

    String platform;
    if (Platform.isIOS) {
      platform = 'ios';
    } else {
      platform = 'android';
    }

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String buildNumber = packageInfo.buildNumber;
      print(buildNumber);
      HttpServices.upDateVersion(
          platform: platform,
          success: (result) {
            print(AppConfig.versionNumber);
            if (result.edition > int.parse(buildNumber)) {
              WMSDialog.showVersionDialog(context, result);
            } else {
              ToastUtil.showMessage(message: '已是最新版本');
            }
          },
          error: (e) {
            print(e.message);
          });
      EasyLoadingUtil.hidden();
    });

    // HttpServices.upDateVersion(
    //     platform: platform,
    //     success: (result) {
    //       EasyLoadingUtil.hidden();
    //       if (result.edition > AppConfig.versionNumber) {
    //         WMSDialog.showVersionDialog(context, result);
    //       } else {
    //         ToastUtil.showMessage(message: '已是最新版本');
    //       }
    //     },
    //     error: (e) {
    //       EasyLoadingUtil.hidden();
    //       ToastUtil.showMessage(message: e.message);
    //     });
  }

  Widget buildVersionInfoWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              image: DecorationImage(
                image: AssetImage('assets/images/ic_launcher.png'),
              ),
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            'V 1.0.0',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget itemSectionWidget({String title, VoidCallback callback}) {
    return Container(
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
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
