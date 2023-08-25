//商品简单信息，图片+名称+货号+品牌
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:get/get.dart';

class ENRkdDetailTopWidget extends StatelessWidget {
  final String picturePath; // 商品图片
  final String name; // 商品名称
  final String brandName; // 品牌
  final String stockCode; //货号
  final int spu;
  final bool spuShow;

  const ENRkdDetailTopWidget({
    Key key,
    this.picturePath,
    this.name,
    this.brandName,
    this.stockCode,
    this.spu,
    this.spuShow: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80.h,
      margin: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 100.w,
              height: 100.w,
              // decoration: BoxDecoration(
              //   image: picturePath == null
              //       ? null
              //       :

              //       DecorationImage(
              //           image: NetworkImage(
              //             picturePath,
              //           ),
              //           fit: BoxFit.contain,
              //         ),
              //   border: Border.all(
              //     width: 1.w,
              //     color: Colors.grey[200],
              //   ),
              // ),
              child: picturePath == null && picturePath != ''
                  ? Center(
                      child: Text("无图片"),
                    )
                  : GestureDetector(
                      onTap: () {
                        Get.to(() => PhotoViewPage(
                              images: picturePath.split(';'), //传入图片list
                              index: 0, //传入当前点击的图片的index
                            ));
                      },
                      child: Image.network(
                        picturePath,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: WMSText(
                        content: '货号：${stockCode ?? '暂无'}',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: WMSText(
                        content: '品牌：${brandName ?? '暂无'}',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: WMSText(
                        content: '商品名称: ${name ?? '暂无'}',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: spuShow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: WMSText(
                          content: '商品spu: ${spu ?? '暂无'}',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
