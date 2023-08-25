import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/pages/photo_view_page.dart';

class WMSUploadImageWidget extends StatelessWidget {
  List images;
  final int maxLength;
  final Function addCallBack;
  final Function(int) delCallBack;
  final bool canDelete;

  WMSUploadImageWidget(
      {Key key,
      this.images,
      this.maxLength = 6,
      this.addCallBack,
      this.delCallBack,
      this.canDelete = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images == null) {
      images = [];
    }
    int itemCount = (images.length >= maxLength)
        ? maxLength
        : canDelete
            ? images.length + 1
            : images.length;

    return Container(
      height: itemCount <= 4 ? 80.h : 160.h,
      child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemCount,
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
            if (index >= images.length) {
              return GestureDetector(
                  onTap: addCallBack,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                    ),
                    color: Colors.grey[100],
                  ));
            }
            return GestureDetector(
                onTap: () {
                  Get.to(() => PhotoViewPage(
                        images: images, //传入图片list
                        index: index, //传入当前点击的图片的index
                        // heroTag: img,//传入当前点击的图片的hero tag （可选）
                      ));
                  // Get.to(()=>PhotoViewPage(images:imagePaths,//传入图片list
                  // index: index //传入当前点击的图片的index
                  // ),);
                },
                child: buildImageWidget(index: index));
          }),
    );
  }

  Widget buildImageWidget({int index}) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment(0, 0),
        child: (images[index] is String)
            ? Image.network(
                images[index],
                fit: BoxFit.contain,
              )
            : Image.file(
                images[index],
                fit: BoxFit.contain,
              ),
      ),
      Visibility(
        visible: canDelete,
        child: Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => delCallBack(index),
            child: Icon(
              Icons.cancel,
              size: 15,
            ),
          ),
        ),
      ),
    ]);
  }
}
