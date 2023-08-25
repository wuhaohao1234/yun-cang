import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/baseWidgets/wv_address_widget.dart';
import 'package:wms/customer/mine/cs_address_manage_page.dart';
import 'package:wms/models/address/address_model.dart';

/// Create by bigv on 21-7-17
/// Description: 地址组件
class RecipientInfoWidget extends StatefulWidget {
  /// 选择地址回调
  final Function callBack;

  /// 传入地址信息
  final AddressModel addressInfo;

  /// 地址组件
  RecipientInfoWidget({this.callBack, this.addressInfo});

  @override
  _RecipientInfoWidgetState createState() => _RecipientInfoWidgetState();
}

class _RecipientInfoWidgetState extends State<RecipientInfoWidget> {
  AddressModel addressInfo;

  void setAddressInfo(AddressModel v) {
    widget.callBack(v);
    setState(() {
      addressInfo = v;
    });
  }

  @override
  void initState() {
    addressInfo = widget.addressInfo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      color: Color(0xfff2f2f2),
      child: GestureDetector(
        onTap: () async {
          AddressModel res = await Get.to(() => CSAddressManagePage());
          setAddressInfo(res);
        },
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    if (addressInfo != null) {
      return AddressWidget(
        addressInfo: addressInfo,
        icon: Icon(
          Icons.arrow_forward_ios_sharp,
          color: Colors.black12,
          size: 18.sp,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_circle_outline_rounded),
        SizedBox(
          width: 8.w,
        ),
        WMSText(
          content: '添加收件人信息',
          size: 15,
          bold: true,
        ),
      ],
    );
  }
}
