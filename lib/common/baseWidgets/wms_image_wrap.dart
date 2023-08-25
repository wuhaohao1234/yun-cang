import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../pages/photo_view_page.dart';

class WMSImageWrap extends StatelessWidget {
  final List<String> imagePaths;
  final EdgeInsetsGeometry padding;

  const WMSImageWrap({
    Key key,
    this.imagePaths,
    this.padding = const EdgeInsets.only(left: 16.0, top: 8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePaths == null || imagePaths?.length == 0) return Container();
    print(imagePaths.toString());
    return Container(
      height: 80.h,
      padding: padding,
      child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: imagePaths.length >= 4 ? 4 : imagePaths.length,
          //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
            crossAxisCount: 4,
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
                      images: imagePaths, //传入图片list
                      index: index, //传入当前点击的图片的index
                      // heroTag: img,//传入当前点击的图片的hero tag （可选）
                    ));
                // Get.to(()=>PhotoViewPage(images:imagePaths,//传入图片list
                // index: index //传入当前点击的图片的index
                // ),);
              },
              child: buildImageWidget(
                  imagePath: imagePaths[index],
                  count: index < 3 ? 0 : imagePaths.length - 4),
            );
          }),
    );
  }

  Widget buildImageWidget({
    String imagePath,
    int count,
  }) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CachedNetworkImage(
            imageUrl: imagePath,
            fit: BoxFit.contain,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(
              value: downloadProgress.progress,
              backgroundColor: Colors.black,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Positioned(
            child: Visibility(
              visible: count > 0,
              child: Text(
                "+$count",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );

    // return Container(
    //   alignment: Alignment(0, 0),
    //   decoration: BoxDecoration(
    //     image: CachedNetworkImage(
    //       imageUrl: "http://via.placeholder.com/350x150",
    //       progressIndicatorBuilder: (context, url, downloadProgress) =>
    //           CircularProgressIndicator(value: downloadProgress.progress),
    //       errorWidget: (context, url, error) => Icon(Icons.error),
    //     ),,
    //   ),
    //
    //
    //   child: Visibility(
    //     visible: count > 0,
    //     child: Text(
    //       "+$count",
    //       style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 24.sp,
    //           fontWeight: FontWeight.bold),
    //     ),
    //   ),
    // );
  }
}
