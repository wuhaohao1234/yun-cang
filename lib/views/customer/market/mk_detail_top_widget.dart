import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:get/get.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MKdetailTopWidget extends StatelessWidget {
  final String imagePath; // 商品图片
  final String name; // 商品名称
  final String brand; // 品牌
  final String color; // 商品颜色
  final int spuId;
  final int total; // 在售数量
  final bool showInfo;
  const MKdetailTopWidget(
      {Key key,
      this.imagePath,
      this.name,
      this.brand,
      this.color,
      this.spuId,
      this.total,
      this.showInfo = true})
      : super(key: key); //货号

  @override
  Widget build(BuildContext context) {
    var imgsList = imagePath.split(';');
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
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => PhotoViewPage(
                    images: imgsList, //传入图片list
                    index: 0, //传入当前点击的图片的index
                  ));
            },
            child: Container(
              height: 250,
              child: new Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return new Image.network(
                    imgsList[index],
                    fit: BoxFit.contain,
                  );
                },
                itemCount: imgsList.length,
                pagination: new SwiperPagination(), //如果不填则不显示指示点
                control: new SwiperControl(), //如果不填则不显示左右按钮
              ),
            ),

            // Image.network(
            //   imagePath,
            //   fit: BoxFit.contain,
            // ),
          ),
          Text(
            name ?? '',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          SizedBox(
            height: 8.h,
          ),
          Visibility(
            visible: showInfo,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (brand != null)
                  WMSText(
                    content: '品牌：${brand ?? ''}',
                    color: Colors.grey,
                  ),
                if (color != null)
                  WMSText(
                    content: '颜色：${color ?? ''}',
                    color: Colors.grey,
                  ),
                if (spuId != null)
                  WMSText(
                    content: '货号：${spuId ?? ''}',
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              WMSText(
                content: '在售数量：${total ?? 0}',
                // bold: true,
                // color: Colors.grey,
              ),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
        ],
      ),
    );
  }
}
