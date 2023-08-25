import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/customer/common.dart';
import 'package:wms/customer/storage/zizhucang/cs_zizhucang_detail_page.dart';
import 'package:wms/views/common/common_style_widget.dart';

class CSZiZhuCangGoodCell extends StatefulWidget {
  final Map model;
  const CSZiZhuCangGoodCell({Key key, this.model}) : super(key: key);

  @override
  _CSZiZhuCangGoodCellState createState() => _CSZiZhuCangGoodCellState();
}

class _CSZiZhuCangGoodCellState extends State<CSZiZhuCangGoodCell> {
  Future<bool> updNewsOrder(id, orderReview) async {
    // 请求特定页面的数据
    var data =
        await HttpServices().updNewsOrder(id: id, orderReview: orderReview);
    if (data != null) {
      print(data);
      setState(() {});

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WMSText(
                  content: '时间: ${widget.model['createTime']}',
                ),
                WMSText(
                  content: WMSUtil.orderReviewStringChange(
                      widget.model['orderReview']),
                  color: Colors.orange,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 80.w,
                  height: 60.h,
                  child: Image.network(
                    widget.model['picturePath'] ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WMSText(
                        content: '货号：${widget.model['stockCode']}',
                        color: Colors.grey,
                        size: 13,
                      ),
                      WMSText(
                        content: 'sku：${widget.model['labelBarCode']}',
                        color: Colors.grey,
                        size: 13,
                      ),
                      WMSText(
                        content: '数量：${widget.model['skuCount']}',
                        color: Colors.grey,
                        size: 13,
                      ),
                      WMSText(
                        content: '仓库：${widget.model['sourePlace']}',
                        color: Colors.grey,
                        size: 13,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Visibility(
                      visible: widget.model['orderReview'] == '1',
                      child: buildButtonWidget(
                        width: 48.w,
                        buttonContent: '取消',
                        handelClick: () {
                          openDialog(context, widget.model['id']);
                        },
                        radius: 2.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildButtonWidget(
                      width: 48.w,
                      buttonContent: '查看',
                      bgColor: AppConfig.themeColor,
                      contentColor: Colors.white,
                      handelClick: () {
                        Get.to(() => CSZiZhuCangDetailPage(
                            id: widget.model['id'], model: widget.model));
                      },
                      radius: 2.0,
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 设置自主仓新品取消
  void openDialog(context, int id) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => wvDialog(
        widget: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    '取消申请',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '您是否要取消本次的新品申请？',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildButtonWidget(
                      width: 120.w,
                      height: 34.h,
                      buttonContent: '取消',
                      handelClick: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Get.back();
                      },
                      radius: 2.0,
                    ),
                    buildButtonWidget(
                      width: 120.w,
                      height: 34.h,
                      bgColor: AppConfig.themeColor,
                      contentColor: Colors.white,
                      buttonContent: '确认',
                      handelClick: () {
                        updNewsOrder(id, '0');
                        Get.back();
                      },
                      radius: 2.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
