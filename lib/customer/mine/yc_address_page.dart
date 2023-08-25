import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wms/common/baseWidgets/wms_button.dart';
import 'package:wms/common/baseWidgets/wms_refresh_view.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/models/mine/mine_info_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YcAddressPage extends StatefulWidget {
  const YcAddressPage({Key key}) : super(key: key);

  @override
  _YcAddressPageState createState() => _YcAddressPageState();
}

class _YcAddressPageState extends State<YcAddressPage> {
  MineInfoModel mineInfoModel;

  @override
  void initState() {
    super.initState();
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '全球云仓地址',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: RefreshView(
          header: MaterialHeader(
            valueColor: AlwaysStoppedAnimation(Colors.black),
          ),
          onRefresh: onRefresh,
          child: mineInfoModel == null ? Container() : ListView(children: [
            SizedBox(
              height: 12.h,
            ),
            WMSText(
              content: '收件人:${mineInfoModel?.recipients ?? ''}',
            ),
            SizedBox(
              height: 12.h,
            ),
            WMSText(
              content: '电话:${mineInfoModel?.phone ?? ''}',
            ),
            SizedBox(
              height: 12.h,
            ),
            WMSText(
              content: '${mineInfoModel?.addressCN ?? ''}',
            ),
            SizedBox(
              height: 12.h,
            ),
            WMSText(
              content: '${mineInfoModel?.addressEN ?? ''}',
            ),

            SizedBox(height: 40.h,),
            WMSButton(title: '复制',callback: (){

              String str = '收件人:${mineInfoModel.recipients} \n电话:${mineInfoModel.phone} \n中文地址：${mineInfoModel.addressCN} \n英文地址：${mineInfoModel.addressEN} \n';

              Clipboard.setData(ClipboardData(text:str ),).then((value){
                ToastUtil.showMessage(message: '复制成功');
              });
            },),
          ],),
        )
      ),
    );
  }

  Widget mineInfoWidget() {
    return Visibility(
      visible: mineInfoModel != null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
    );
  }

  Future onRefresh() async{
    requestData();
  }

  void requestData() {
    EasyLoadingUtil.showLoading();
    HttpServices.mineInfo(success: (data) {
      EasyLoadingUtil.hidden();
      setState(() {
        mineInfoModel = data;
      });
    }, error: (e) {
      EasyLoadingUtil.hidden();
      ToastUtil.showMessage(message: e.message);
    });
  }
}
