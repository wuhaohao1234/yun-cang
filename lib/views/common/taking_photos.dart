//拍照页面
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:math';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
// import 'package:wms/common/baseWidgets/wms_camera_image_warp.dart';
import 'package:flashlight/flashlight.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'photo_preview.dart';

class CameraArea extends StatefulWidget {
  CameraArea({Key key}) : super(key: key);

  @override
  State<CameraArea> createState() => _CameraAreaState();
}

class _CameraAreaState extends State<CameraArea> {
  List<CameraDescription> cameras;
  CameraController controller;
  // bool tapActive = true;
  int selectedCameraID = 0;
  bool _isCameraInitialized = false;
  //focus
  bool showFocusCircle = false;
  double x = 0;
  double y = 0;
  //debounce
  ValueNotifier<bool> tapActive; // 拍照按钮可用
  Timer _timer;
  @override
  void initState() {
    initCameras();
    super.initState();

    tapActive = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void initCameras() async {
    // 初始化相机列表
    cameras = await availableCameras();
    print("初始化得到相机列表 $cameras");

    await onSelectNewCamera(cameras[selectedCameraID]);
  }

  onSelectNewCamera(CameraDescription cameraDescription) async {
    print('选择新相机 $cameraDescription');
    final previousCameraController = controller;
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh, //1080p
    );
    print("初始化得到相机controller $cameraController");

    // Replace with the new controller
    if (mounted) {
      // Dispose the previous controller
      await previousCameraController?.dispose();
      setState(() {
        print("更换controller");
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        if (controller != null) {
          _isCameraInitialized = controller.value.isInitialized;
          setState(() {});
        }
      });
    }
  }

  Future<void> _onTap(TapUpDetails details) async {
    // 改变聚焦点以后的行为
    if (controller.value.isInitialized) {
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

  Future<File> _takePicture() async {
    tapActive.value = false;

    setState(() {
      tapActive.value = false;
    });
    XFile originalFile = await controller.takePicture();
    print("原始文件路径是: ${originalFile.path}");

    // 切割图像比例
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(originalFile.path);
    var offset = ((properties.height - properties.width).abs()) / 2;
    final newSize = min(properties.width, properties.height);
    // 图片高度大于宽度，则裁剪高度；反之，裁剪裁剪宽度；
    File croppedFile = properties.height - properties.width > 0
        ? await FlutterNativeImage.cropImage(
            originalFile.path, 0, offset.round(), newSize, newSize)
        : await FlutterNativeImage.cropImage(
            originalFile.path, offset.round(), 0, newSize, newSize);

    await File(originalFile.path).delete();
    // originalFile.delete();
    File file1 = File(croppedFile.path);
    return file1;
  }

  void _switchCamera() {
    setState(() {
      _isCameraInitialized = false;
      if (selectedCameraID == 0) {
        selectedCameraID = 1;
      } else {
        selectedCameraID = 0;
      }
      onSelectNewCamera(cameras[selectedCameraID]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    print("rebuild camera area");

    return GestureDetector(
      onTapUp: (details) {
        _onTap(details);
      },
      child: Stack(
        children: [
          Center(
            child: Container(
              width: size,
              height: size,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: _isCameraInitialized
                        ? Container(
                            width: size,
                            height: size * controller.value.aspectRatio,
                            // height: size,
                            child: CameraPreview(controller))
                        : Container(
                            width: size,
                            height: size,
                            color: Colors.black,
                          ),
                  ),
                ),
              ),
            ),
          ),
          if (showFocusCircle)
            Positioned(
              top: y - 30,
              left: x - 30,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5)),
              ),
            )
        ],
      ),
    );
  }
}

class CommonTakePhotosPage extends StatefulWidget {
  final int maxLength;
  final List<File> images;

  const CommonTakePhotosPage({Key key, this.images, this.maxLength = 6})
      : super(key: key); // 最大张数

  @override
  State<CommonTakePhotosPage> createState() => _CommonTakePhotosPageState();
}

class _CommonTakePhotosPageState extends State<CommonTakePhotosPage> {
  List<CameraDescription> cameras;
  List<File> images = [];
  // bool tapActive = true;
  bool flashActive = false;
  GlobalKey<_CameraAreaState> globalCameraAreaKey = GlobalKey();
  //debounce
  ValueNotifier<bool> tapActive; // 拍照按钮可用

  @override
  void initState() {
    super.initState();
    images = widget.images;
    tapActive = ValueNotifier<bool>(true);
  }

  void deletePhoto(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final bgColor = Colors.grey[900];

    final bgColor = Colors.black45;
    var noImages = images == null || images.length == 0;
    print("rebuild");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: noImages
                ? Icon(Icons.remove_circle_outline_sharp)
                : Icon(Icons.check),
            color: noImages ? Colors.grey : Colors.green,
            onPressed: noImages
                ? () {}
                : () {
                    Get.back(result: images);
                  },
          )
        ],
      ),
      body: Container(
        color: bgColor,
        child: SafeArea(
          child: Column(
            children: [
              CameraArea(key: globalCameraAreaKey),
              // 显示照片
              Container(
                color: bgColor,
                height: 100.h,
                padding: EdgeInsets.all(10.h),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    images.length,
                    (int index) {
                      imageCache.clear();
                      imageCache.clearLiveImages();
                      print("初始化第 $index 张照片 ${images[index].path}");
                      final r = 20.0;
                      final rSize = 80.h;
                      return new Stack(
                        alignment: Alignment.topRight,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => CommonPhotoPreviewEditPage(
                                  images: images,
                                  index: index,
                                ),
                              ).then((value) => {setState(() {})});
                            },
                            child: Container(
                              padding: EdgeInsets.all(5.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(r),
                                color: bgColor,
                              ),
                              width: rSize,
                              height: rSize,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(r), // Image border
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(r), // Image radius
                                  child: Image.file(
                                    images[index],
                                    key: UniqueKey(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // print("Container clicked");
                              deletePhoto(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.h),
                                color: Colors.white,
                              ),
                              width: 20.h,
                              height: 20.h,
                              child: Icon(Icons.close),
                              // child: IconButton(
                              //   icon: Icon(Icons.favorite, size: 10.h),
                              // ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Spacer(),
              // 控制器
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                        ),
                        onPressed: () {
                          print("switch camera");
                          globalCameraAreaKey.currentState._switchCamera();
                          // setState(() {});
                        },
                        child: Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: tapActive,
                      builder: (context, isEnabled, child) => GestureDetector(
                        onTap: () async {
                          if (tapActive.value) {
                            final photo = await globalCameraAreaKey.currentState
                                ._takePicture();
                            setState(() {
                              images.add(photo);
                            });
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
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                        ),
                        onPressed: () {
                          setState(() {
                            flashActive = !flashActive;
                            print("改变flashActive 到 $flashActive");
                            if (flashActive) {
                              Flashlight.lightOn();
                            } else {
                              Flashlight.lightOff();
                            }
                          });
                        },
                        child: flashActive
                            ? Icon(
                                Icons.flash_on,
                                color: Colors.white,
                                size: 30.0,
                              )
                            : Icon(
                                Icons.flash_off,
                                color: Colors.white,
                                size: 30.0,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void onTaptakePicture() async {
  //   print("take shot");

  // tapActive.value = false;

  // setState(() {
  //   tapActive.value = false;
  // });
  // XFile originalFile = await controller.takePicture();
  // print("原始文件路径是: ${originalFile.path}");

  // // 切割图像比例
  // ImageProperties properties =
  //     await FlutterNativeImage.getImageProperties(originalFile.path);
  // var offset = ((properties.height - properties.width).abs()) / 2;
  // final newSize = min(properties.width, properties.height);
  // // 图片高度大于宽度，则裁剪高度；反之，裁剪裁剪宽度；
  // File croppedFile = properties.height - properties.width > 0
  //     ? await FlutterNativeImage.cropImage(
  //         originalFile.path, 0, offset.round(), newSize, newSize)
  //     : await FlutterNativeImage.cropImage(
  //         originalFile.path, offset.round(), 0, newSize, newSize);

  // await File(originalFile.path).delete();
  // // originalFile.delete();
  // File file1 = File(croppedFile.path);
  // print("裁切后文件路径是: ${file1.path}");

  // setState(() {
  //   images.add(file1);
  //   //设置debounce
  //   _timer =
  //       Timer(Duration(milliseconds: 5000), () => tapActive.value = true);
  //   tapActive.value = true;
  //   print("共有 ${images.length} 张图片");

  //   Get.to(
  //     () => CommonPhotoPreviewEditPage(
  //       images: images,
  //       index: images.length - 1,
  //     ),
  //   ).then((value) => {setState(() {})});
  // });
  // if (images.length == widget.maxLength) {
  //   Get.back(result: images);
  // }
  // }
}
