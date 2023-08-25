// 照片预览和标注
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as imgx;

import 'dart:async';
import 'dart:typed_data';

class ShangpingPhotoPreviewEditPage extends StatefulWidget {
  final List<File> images;
  final int index;
  const ShangpingPhotoPreviewEditPage(
      {Key key, @required this.images, @required this.index})
      : super(key: key);

  @override
  _ShangpingPhotoPreviewEditPageState createState() =>
      _ShangpingPhotoPreviewEditPageState();
}

class _ShangpingPhotoPreviewEditPageState
    extends State<ShangpingPhotoPreviewEditPage> {
  ui.Image image;
  bool isImageloaded = false;
  GlobalKey _myCanvasKey = new GlobalKey();

  ImageEditor editor;
  ui.PictureRecorder recorder;
  Canvas canvas;

  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    final dat = await _readFileByte(widget.images[widget.index].path);
    image = await loadImage(dat);
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    print("重新绘制 build");
    final size = MediaQuery.of(context).size.width;

    setState(() {
      editor = ImageEditor(image: image);
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
    });

    Widget _buildImage() {
      if (this.isImageloaded) {
        final pt = GestureDetector(
          onPanDown: (detailData) {
            editor.addLine(detailData.localPosition);
            // _myCanvasKey.currentContext.findRenderObject().markNeedsPaint();
            print("新增一条线");
            editor.paint(
                canvas, Size(image.width.toDouble(), image.height.toDouble()));
          },
          onPanUpdate: (detailData) {
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
              editor.paint(canvas,
                  Size(image.width.toDouble(), image.height.toDouble()));

              final ui.Picture picture = recorder.endRecording();
              print("停止录制");
              final img = await picture.toImage(
                image.width.toInt(),
                image.height.toInt(),
              );
              final ByteData savedData =
                  await img.toByteData(format: ui.ImageByteFormat.png);

              final buffer = savedData.buffer;
              final Uint8List list = buffer.asUint8List(
                  savedData.offsetInBytes, savedData.lengthInBytes);

              final tmpImg = imgx.decodePng(list);
              final jpgImg = imgx.encodeJpg(tmpImg);

              File image2Modify = File(widget.images[widget.index].path);
              print("保存到: ${image2Modify.path}");
              image2Modify.writeAsBytesSync(jpgImg);

              setState(() {});
              img.dispose();

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
