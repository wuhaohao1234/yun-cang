import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/baseWidgets/wms_button.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:get/get.dart';

class StorageLinCunCellWidget extends StatelessWidget {
  final model;
  final buttonCallback;
  final showChuKuButton;
  final status;

  const StorageLinCunCellWidget(
      {Key key,
      this.model,
      this.buttonCallback,
      this.showChuKuButton = false,
      this.status = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.grey[100],
      margin: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child:
                model?.instoreOrderImg != null && model?.instoreOrderImg != ""
                    // || model?.outSkuOrderImg != null
                    ? GestureDetector(
                        onTap: () {
                          Get.to(() => PhotoViewPage(
                                images: model?.instoreOrderImg?.split(";"),
                                // : model?.outSkuOrderImg?.split(";"), //传入图片list
                                index: 0, //传入当前点击的图片的index
                              ));
                        },
                        child: Image.network(
                          // status == 0
                          model?.instoreOrderImg?.split(";")[0] ?? '',
                          // : model?.outSkuOrderImg?.split(";")[0] ?? '',
                          height: 80.h,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Center(child: Text('无图片')),
                        height: 80.h,
                        width: 80.w,
                      ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WMSText(
                  content: '入仓单号：${model.prepareOrderName ?? ''}',
                  bold: true,
                ),
                SizedBox(
                  height: 8.h,
                ),
                WMSText(
                  content: '预约箱数：${model?.boxTotal ?? 0}',
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WMSText(
                      content: '预约总数：${model?.skusTotal ?? 0}',
                    ),
                    Visibility(
                      visible: showChuKuButton,
                      child: WMSButton(
                        title: '手动出库',
                        callback: buttonCallback,
                        height: 20.h,
                        width: 70.w,
                        fontSize: 12.sp,
                        bgColor: Colors.transparent,
                        textColor: Colors.black,
                        showBorder: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                //设置不同的物流单号
                WMSText(
                  content:
                      '快递单号：${status == 0 ? model?.mailNo ?? '' : model.expressNumber ?? ''}',
                ),
                SizedBox(
                  height: 8.h,
                ),
                WMSText(
                  content: '仓库：${model.depotName ?? ''}',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
