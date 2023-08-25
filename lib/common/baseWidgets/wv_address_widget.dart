import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/models/address/address_model.dart';

/// Create by bigv on 21-7-17
/// Description:
class AddressWidget extends StatelessWidget {
  const AddressWidget({Key key, @required this.addressInfo, this.icon})
      : super(key: key);

  final AddressModel addressInfo;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 10.w),
      // color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 15.w),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Colors.red,
                  size: 30,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          WMSText(
                            content: '${addressInfo?.userName ?? '-'}',
                            bold: true,
                          ),
                          SizedBox(width: 6.w),
                          WMSText(
                            content: '${addressInfo?.userPhone}',
                          ),
                        ],
                      ),
                      WMSText(
                        content:
                            '${addressInfo?.province} ${addressInfo?.city}${addressInfo?.area}${addressInfo?.userAddress}',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),
          icon != null ? icon : SizedBox(),
        ],
      ),
    );
  }
}
