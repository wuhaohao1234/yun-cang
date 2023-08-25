import 'package:flutter/material.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';

class WMSAgreementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        centerTitle: true,
        title: WMSText(
          content: '用户协议',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        child: Text(''),
      ),
    );
  }
}
