import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/pages/photo_view_page.dart';

class WMSCameraImageWarp extends StatelessWidget {
  final List<File> images;
  final Function(int) delCallBack;

  const WMSCameraImageWarp({Key key, this.images, this.delCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images == null || images?.length == 0) return Container();
    return Container(
      height: 80.h,
      child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemCount: images.length,
          //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
            crossAxisCount: 6,
            //纵轴间距
            mainAxisSpacing: 5.0,
            //横轴间距
            crossAxisSpacing: 5.0,
            //子组件宽高长度比例
            // childAspectRatio: imagePaths.length == 1 ? (16 / 9) : 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            //Widget Function(BuildContext context, int index)
            return GestureDetector(
                onTap: () {
                  Get.to(() => PhotoViewPage(
                        images: images, //传入图片list
                        index: index, //传入当前点击的图片的index
                        // heroTag: img,//传入当前点击的图片的hero tag （可选）
                      ));
                },
                child: buildImageWidget(
                  file: images[index],
                  index: index,
                ));
          }),
    );
  }

  Widget buildImageWidget({
    File file,
    int index,
  }) {
    return Stack(children: [
      Container(
        alignment: Alignment(0, 0),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(file), fit: BoxFit.fitWidth),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => delCallBack(index),
          child: Icon(
            Icons.cancel,
            size: 15,
            color: Colors.white,
          ),
        ),
      ),
    ]);
    // return Container(
    //   alignment: Alignment(0, 0),
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //         image: MemoryImage(file),
    //         fit: BoxFit.contain),
    //   ),
    // );
  }
}
