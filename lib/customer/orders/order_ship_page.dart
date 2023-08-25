// 订单配发弹窗页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import '../../views/common/taking_photos.dart';
import 'package:wms/models/oss_model.dart';
import 'dart:io';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';
// import 'package:wms/customer/mine/controllers/cs_add_address_page_controller.dart';
// import 'package:wms/models/address/address_model.dart';

typedef void OrderShipCallback(dynamic);

class CSOrderShipPage extends StatefulWidget {
  final int orderId;
  final OrderShipCallback orderShipCallback;

  const CSOrderShipPage({Key key, this.orderId, this.orderShipCallback})
      : super(key: key);

  @override
  _CSOrderShipPageState createState() => _CSOrderShipPageState();
}

class _CSOrderShipPageState extends State<CSOrderShipPage> {
  TextEditingController mailNo;

  List<File> images = [];
  String imgUrl = '';

  Future getOssObj() async {
    Completer completer = new Completer();
    HttpServices.requestOss(
        dir: AppGlobalConfig.imageType3,
        success: (data) {
          completer.complete(data);
        });
    return completer.future;
  }

  Future uploadImageAsync(OssModel model, File image) async {
    Completer completer = new Completer();
    HttpServices.upLoadImage(
        file: image,
        model: model,
        success: (imgUrl) {
          completer.complete(imgUrl);
        },
        error: (data) {
          completer.completeError(data);
        });
    return completer.future;
  }

  // 上传图片
  uploadQianShouImages() async {
    if (images.length == 0 || images.length == null) {
      return false;
    }
    EasyLoadingUtil.showLoading(statusText: "上传照片中...");
    String imagePaths = '';
    final ossObj = await getOssObj();
    for (int i = 0; i < images.length; i++) {
      String imgUrl = await uploadImageAsync(ossObj, images[i]);
      print("第 $i 张照片上传成功");
      imagePaths += imgUrl;
      if (i < images.length - 1) {
        imagePaths += ";";
      }
    }
    EasyLoadingUtil.hidden();
    return imagePaths;
  }

  @override
  void initState() {
    super.initState();

    mailNo = TextEditingController();
    mailNo.addListener(checkInput);
  }

//如何确保动态更新；
  bool checkInput() {
    if (mailNo.text.length == 0) {
      ToastUtil.showMessage(message: '请确认是否有物流单号');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionTitleWidget(
            title: '添加发货商品照片（选填）',
          ),
          // buildItemsImage(pageController),
          WMSUploadImageWidget(
            images: images,
            addCallBack: () {
              Get.to(() => CommonTakePhotosPage(
                    images: images,
                  )).then((value) {
                print("得到结果 $value");
                setState(() {});
              });
            },
            delCallBack: (index) {},
          ),
          WMSTextField(
            title: '快递单号',
            hintText: '请输入（必填）',
            keyboardType: TextInputType.text,
            controller: mailNo,
            onSubmittedCallback: (value) {
              setState(() {
                print(value);
                mailNo.text = value;
              });
            },
            onChangedCallback: (value) {
              setState(() {
                print(value);
                mailNo.text = value;
              });
            },
            endWidget: GestureDetector(
              onTap: () {
                Get.to(() => ENScanStandardPage(
                      title: "扫快递码",
                      // leading: backLeadingIcon,
                    )).then((value) {
                  setState(() {
                    mailNo.text = value;
                    setState(() {});
                  });
                });
              },
              child: SvgPicture.asset(
                'assets/svgs/scan.svg',
                width: 15.w,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WMSButton(
                title: '取消',
                width: 120.w,
                bgColor: Colors.transparent,
                textColor: Colors.black,
                showBorder: true,
                callback: () {
                  Navigator.of(context).pop(false);
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(120.w, 34.w)),
                  backgroundColor: MaterialStateProperty.resolveWith((states) =>
                      checkInput() == false ? null : AppStyleConfig.btnColor),
                ),
                onPressed: checkInput() == false
                    ? null
                    : () async {
                        var imagePaths = '';
                        if (images.length == 0 && images.length != null) {
                        } else {
                          EasyLoadingUtil.showLoading(statusText: "...");
                          imagePaths = await uploadQianShouImages();
                        }
                        widget.orderShipCallback({
                          "orderId": widget.orderId,
                          "picturePath": imagePaths,
                          "logisticsNum": mailNo.text,
                        });
                        Navigator.of(context).pop(true);
                      },
                child: Text('确认提交'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
