// 照片预览和标注
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as imgx;

import 'dart:async';
import 'dart:typed_data';

class CommonPhotoPreviewEditPage extends StatefulWidget {
  final List<File> images;
  final int index;
  const CommonPhotoPreviewEditPage(
      {Key key, @required this.images, @required this.index})
      : super(key: key);

  @override
  _CommonPhotoPreviewEditPageState createState() =>
      _CommonPhotoPreviewEditPageState();
}

class _CommonPhotoPreviewEditPageState
    extends State<CommonPhotoPreviewEditPage> {
  ui.Image image;
  bool isImageloaded = false;
  bool imageEdited = false;
  GlobalKey _myCanvasKey = new GlobalKey();

  ImageEditor editor;
  ui.PictureRecorder recorder;
  Canvas canvas;

  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    // 从本地文件中读取照片
    final dat = await _readFileByte(widget.images[widget.index].path);
    image = await loadImage(dat);
    setState(() {
      isImageloaded = true;
      editor = ImageEditor(image: image);
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
    });
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    print("重新绘制 build");
    final size = MediaQuery.of(context).size.width;

    // setState(() {
    //   editor = ImageEditor(image: image);
    //   recorder = ui.PictureRecorder();
    //   canvas = Canvas(recorder);
    // });

    Widget _buildImage() {
      if (this.isImageloaded) {
        final pt = GestureDetector(
          onPanStart: (detailData) {
            editor.addLine(detailData.localPosition);
            // _myCanvasKey.currentContext.findRenderObject().markNeedsPaint();
            print("新增一条线");
            editor.paint(
                canvas, Size(image.width.toDouble(), image.height.toDouble()));
          },
          onPanUpdate: (detailData) {
            imageEdited = true;
            editor.updateLine(detailData.localPosition);
            _myCanvasKey.currentContext.findRenderObject().markNeedsPaint();
          },
          child: CustomPaint(
            key: _myCanvasKey,
            painter: editor,
          ),
        );
        return Center(
          child: Container(
            width: size,
            height: size,
            child: FittedBox(
              child: SizedBox(
                width: image.width.toDouble(),
                height: image.height.toDouble(),
                child: ClipRect(
                  child: pt,
                ),
              ),
            ),
          ),
        );
      } else {
        return Center(child: Text('loading'));
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              // Navigator.pop(context, images);
              print("取消编辑");
              editor.clearAll();
              // _myCanvasKey.currentContext.findRenderObject().markNeedsPaint();
              editor.paint(canvas,
                  Size(image.width.toDouble(), image.height.toDouble()));
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              if (imageEdited) {
                EasyLoadingUtil.showLoading(statusText: "保存改动中...");
                final t0 = DateTime.now().millisecondsSinceEpoch;
                editor.paint(canvas,
                    Size(image.width.toDouble(), image.height.toDouble()));

                final ui.Picture picture = recorder.endRecording();
                final t1 = DateTime.now().millisecondsSinceEpoch;
                print("停止录制 ${t1 - t0}");
                // until this step we have the edited image
                final img = await picture.toImage(
                  image.width.toInt(),
                  image.height.toInt(),
                );

                // try to convert the image to jepg format.

                final t2 = DateTime.now().millisecondsSinceEpoch;
                print("${t2 - t1}");
                final ByteData savedData =
                    await img.toByteData(format: ui.ImageByteFormat.png);

                final t3 = DateTime.now().millisecondsSinceEpoch;
                print("this takes so long: ${t3 - t2}");

                final buffer = savedData.buffer;
                final Uint8List list = buffer.asUint8List(
                    savedData.offsetInBytes, savedData.lengthInBytes);

                final t4 = DateTime.now().millisecondsSinceEpoch;
                print("${t4 - t3}");
                // final tmpImg = imgx.decodePng(list);
                // final jpgImg = imgx.encodeJpg(tmpImg);
                // 实际上直接存储png图片,但是采用.jpg 的后缀. 不影响结果.
                final jpgImg = list;
                final t5 = DateTime.now().millisecondsSinceEpoch;
                print("image conversion: ${t5 - t4}");

                File image2Modify = File(widget.images[widget.index].path);
                print("保存到: ${image2Modify.path}");
                image2Modify.writeAsBytesSync(jpgImg);

                final t6 = DateTime.now().millisecondsSinceEpoch;
                print("${t6 - t5}");
                EasyLoadingUtil.hidden();

                setState(() {});
                img.dispose();
              }

              Get.back(result: 'success');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Container(
            child: _buildImage(),
          ),
        ),
      ),
    );
  }
}

class ImageEditor extends CustomPainter {
  ImageEditor({
    this.image,
  });

  ui.Image image;
  List<List<Offset>> lines = [];

  final Paint painter = new Paint()
    ..color = Colors.red[400]
    ..strokeWidth = 10;

  void updateLine(Offset offset) {
    lines[lines.length - 1].add(offset);
  }

  void addLine(Offset offset) {
    lines.add([offset]);
  }

  void clearAll() {
    lines = [];
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset(0.0, 0.0), Paint());
    if (lines.length > 0) {
      for (int i = 0; i < lines.length; i++) {
        List<Offset> points = lines[i];
        if (points.length > 1) {
          for (var i = 0; i < points.length - 1; i++) {
            canvas.drawLine(points[i], points[i + 1], painter);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Future<Uint8List> _readFileByte(String filePath) async {
  Uri myUri = Uri.parse(filePath);
  File audioFile = new File.fromUri(myUri);
  Uint8List bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    print('reading of bytes is completed');
  }).catchError((onError) {
    print(
        'Exception Error while reading audio from path:' + onError.toString());
  });
  return bytes;
}
