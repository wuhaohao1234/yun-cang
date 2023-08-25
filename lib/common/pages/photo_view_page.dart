import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wms/utils/jk_over_scroll_behavior.dart';

// 仅支持 网络图片 String +  本地图片 File
class PhotoViewPage extends StatefulWidget {
  List images = [];
  int index = 0;
  String heroTag;
  PageController controller;

  PhotoViewPage(
      {Key key,
      @required this.images,
      this.index,
      this.controller,
      this.heroTag = ""})
      : super(key: key) {
    controller = PageController(initialPage: index);
  }

  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                  child: ScrollConfiguration(
                behavior: JKOverScrollBehavior(),
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions.customChild(
                      child: (widget.images[index] is String)
                          ? Image.network(
                              widget.images[index],
                            )
                          : Image.file(
                              widget.images[index],
                            ),
                      heroAttributes: widget.heroTag.isNotEmpty
                          ? PhotoViewHeroAttributes(tag: widget.heroTag)
                          : null,
                      maxScale: 5.0,
                      minScale: 0.8,
                    );
                  },
                  itemCount: widget.images.length,
                  backgroundDecoration: null,
                  pageController: widget.controller,
                  enableRotation: true,
                  customSize: Size(375.w, 667.h),
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              )),
            ),
            Positioned(
              //图片index显示
              top: MediaQuery.of(context).padding.top + 15,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text("${currentIndex + 1}/${widget.images.length}",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            Positioned(
              //右上角关闭按钮
              right: 10,
              top: MediaQuery.of(context).padding.top,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
