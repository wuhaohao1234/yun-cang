import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_camera_image_warp.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/customer/common.dart';

class WMSCameraPage extends StatefulWidget {
  final int maxLength;

  const WMSCameraPage({Key key, this.maxLength = 6}) : super(key: key); // 最大张数

  @override
  _WMSCameraPageState createState() => _WMSCameraPageState();
}

class _WMSCameraPageState extends State<WMSCameraPage>
    with TickerProviderStateMixin {
  List<CameraDescription> cameras;
  CameraController controller;
  List<File> images = [];
  bool activation = true; // 拍照按钮可用

  //focus
  bool showFocusCircle = false;
  double x = 0;
  double y = 0;

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    test();
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 100));
    animationController.addListener(() {
      if (animation.status == AnimationStatus.completed &&
          animation.value == 1.2) {
        animationController.reverse();
      }
    });
    animation = Tween(begin: 1.0, end: 1.2).animate(animationController);
  }

  test() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      animationController.forward();
      // Future.delayed(Duration(milliseconds: 100),(){animationController.reverse();});
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);
      print("point : $point");
      if (point != null &&
          (point.dx < 0 || point.dx > 1 || point.dy < 0 || point.dy > 1)) {
        throw ArgumentError(
            'The values of point should be anywhere between (0,0) and (1,1).');
      }

      // Manually focus
      await controller.setFocusPoint(point);
  print("aaaaa");
      // Manually set light exposure
      //controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller?.value?.isInitialized == null) {
      return Container();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTapUp: (details) {
              _onTap(details);
            },
            child: Stack(
              children: [
                AspectRatio(
                    aspectRatio: 375.w / 667.h,
                    child: Stack(
                      children: [
                        Center(child: CameraPreview(controller)),
                        if (showFocusCircle)
                          Positioned(
                              top: y - 30, left: x - 30, child: focusWidget())
                      ],
                    )),
              ],
            ),
          ),
          Positioned(
            top: 20.h,
            left: 0,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  print('adasdas');
                  Get.back();
                }),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 375.w,
              height: 200.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  WMSCameraImageWarp(
                    images: images,
                    delCallBack: (index) {
                      images.removeAt(index);
                      setState(() {});
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // IconButton(
                      //     icon: Icon(
                      //       Icons.camera_alt,
                      //       color: Colors.white,
                      //     ),
                      //     onPressed: () {}),
                      Expanded(flex: 1, child: Container()),
                      GestureDetector(
                        onTap: () {
                          if (activation) {
                            onTaptakePicture();
                          }
                        },
                        child: Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Center(
                            child: Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black26),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.back(result: images);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.yellow),
                              child: WMSText(
                                content: '确定(${images.length})',
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // IconButton(
                      //     icon: Icon(
                      //       Icons.carpenter_rounded,
                      //       color: Colors.white,
                      //     ),
                      //     onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget focusWidget() {
    return ScaleTransition(
        scale: animation,
        child: Container(
          height: 80,
          width: 80,
          child: Image.asset("assets/images/focus.png"),
        ));
  }

  void onTaptakePicture() async {
    setState(() {
      activation = false;
    });
    XFile file = await controller.takePicture();

    File file1 = File(file.path);

    setState(() {
      images.add(file1);
      activation = true;
    });
    if (images.length == widget.maxLength) {
      Get.back(result: images);
    }

    // file.readAsBytes().then((value){
    //   setState(() {
    //     images.add(value);
    //     activation = true;
    //   });
    //   if(images.length == widget.maxLength){
    //     Get.back(result: images);
    //   }
    // });
  }

  @override
  void dispose() {
    controller?.dispose();
    animationController.dispose();
    super.dispose();
  }
}
