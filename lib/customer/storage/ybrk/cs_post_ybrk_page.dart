// 预约入库、提交页面
import 'package:image_picker/image_picker.dart';
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/commodity_cell_widget.dart';
import 'package:wms/views/commodity_table_head_cell_widget.dart';
import 'package:wms/views/commodity_sku_cell_widget.dart';
import '../../../views/common/taking_photos.dart';
import 'package:wms/models/oss_model.dart';
import 'dart:io';
import 'cs_ybrk_tab_page.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

class CSYbrkPostPage extends StatefulWidget {
  final int orderId;
  final String orderIdName;
  final Map prepareOrderInfo;
  final String status;
  final int depotId;
  final List commodityList;
  final int orderOperationalRequirements;
  final int httpType; //0 新建预约入库API 1 修改API

  const CSYbrkPostPage(
      {Key key,
      this.orderId,
      this.orderIdName,
      this.prepareOrderInfo,
      this.status,
      this.depotId,
      this.orderOperationalRequirements,
      this.commodityList,
      this.httpType})
      : super(key: key);

  @override
  _CSYbrkPostPageState createState() => _CSYbrkPostPageState();
}

class _CSYbrkPostPageState extends State<CSYbrkPostPage> {
  TextEditingController mailNo;
  TextEditingController boxTotal;
  TextEditingController remark;

  List<File> images = [];
  String imgUrl = '';
  var status = '0';
  Map depotInfo = {'received': '', 'phoneNumber': '', 'address': ''};
  List commodityList = [];
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

//获取订单数据
  void requestOrderData() async {
    var data = await HttpServices().prepareOrderDetailList(
        orderId: widget.orderId.toString(), status: status);
    if (data == false) {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: '未获取相关数据');
    }
    if (data != null) {
      print(data);

      EasyLoadingUtil.hidden();
    } else {}
  }

//获取仓库数据；
  Future<bool> requestDepotData() async {
    // 请求特定页面的数据
    var data = await HttpServices().prepareOrderDepotList();
    if (data != null) {
      print(data);
      setState(() {
        depotInfo =
            data.where((element) => element['id'] == widget.depotId).first;
        print(depotInfo);
      });

      return true;
    } else {
      return false;
    }
  }

  //获取预约入库绑定商品数据；
  Future<bool> requestCommodityData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var resCommodityList = await HttpServices().csGetSku(
      orderIdName: widget.orderIdName,
      pageNum: 0,
      pageSize: 10,
    );
    if (resCommodityList == false) {
      setState(() {
        commodityList =
            widget.commodityList != null ? widget.commodityList != null : [];
      });
    }
    if (resCommodityList != null) {
      final data = resCommodityList;
      setState(() {
        commodityList = data;
      });
      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    // requestOrderData();
    requestDepotData();
    requestCommodityData();
    mailNo = TextEditingController();
    boxTotal = TextEditingController();
    remark = TextEditingController();
  }

//如何确保动态更新；
  bool checkInput() {
    // if (mailNo.text.length == 0) {
    //   ToastUtil.showMessage(message: '请确认是否有物流单号');
    //   return false;
    // }
    // if (boxTotal.text.length == 0) {
    //   ToastUtil.showMessage(message: '请输入快递箱数');
    //   return false;
    // }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '预约入库',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: TextButton(
          child: WMSText(
            content: '返回',
            color: Colors.grey,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ScrollConfiguration(
            behavior: JKOverScrollBehavior(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SectionTitleWidget(
                        title: '收货方信息',
                      ),
                      WMSText(
                        content: '收件人：${depotInfo['received']}',
                      ),
                      WMSText(
                        content: '收件人手机号：${depotInfo['phoneNumber']}',
                      ),
                      WMSText(
                        content: '收货地址：${depotInfo['address']}（${WMSUser.getInstance().userInfoModel.userCode}）',
                      ),


                      // WMSText(
                      //   content:
                      //       '跨境信息：${depotInfo['crossBorder'] == 0 ? '国现' : '跨境'}',
                      // ),
                      SectionTitleWidget(
                        title: '发货信息',
                      ),
                      WMSText(
                        content: '入仓单号：${widget.orderIdName}',
                      ),
                      WMSText(
                        content: '入仓方式：${null ?? '快递'}',
                      ),
                      WMSTextField(
                        title: '快递单号',
                        hintText: '请输入',
                        keyboardType: TextInputType.text,
                        controller: mailNo,
                        onSubmittedCallback: (value) {
                          setState(() {});
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
                      WMSTextField(
                          title: '快递箱数',
                          hintText: '请输入',
                          keyboardType: TextInputType.number,
                          controller: boxTotal,
                          onSubmittedCallback: (value) {
                            setState(() {});
                          }),
                      SectionTitleWidget(
                        title: '添加照片（货单/截图/货品图)选填',
                      ),
                      // buildItemsImage(pageController),
                      WMSUploadImageWidget(
                        images: images,
                        addCallBack: () async{
                          var _picker = ImagePicker();
                          await showModalBottomSheet(
                              context: Get.context,
                              builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text("相机"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.to(() => CommonTakePhotosPage(
                                      images: images,
                                    )).then((value) {
                                      print("得到结果 $value");
                                      setState(() {});
                                    });
                                  },
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text("相册"),
                                  onTap: () async {
                                    PickedFile image =
                                    await _picker.getImage(source: ImageSource.gallery);
                                    images.add(File(image.path));
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  leading: const Icon(Icons.close),
                                  title: const Text("取消"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });



                          // Get.to(() => CommonTakePhotosPage(
                          //       images: images,
                          //     )).then((value) {
                          //   print("得到结果 $value");
                          //   setState(() {});
                          // });
                        },
                        delCallBack: (index) {
                          if (images.length > 0) {
                            images.removeAt(index);
                          }
                          setState(() {});
                        },
                      ),
                      TextField(
                        // onChanged: (value) {
                        //   remark123 = value;
                        // },
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.multiline,
                        controller: remark,
                        style: TextStyle(fontSize: 13.sp),
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: '添加备注',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.1)),
                          hintStyle: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                      SectionTitleWidget(
                        title: '预约入库商品信息',
                      ),
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: buildCommodityList(commodityList),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(90.w, 34.h),
                      fixedSize: Size(343.w, 34.h),
                      backgroundColor: AppStyleConfig.btnColor
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      // ),
                    ),
                    onPressed: checkInput() == false
                        ? null
                        : () async {
                            FocusScope.of(context).requestFocus(FocusNode());

                            var imagePaths = '';
                            if (images.length == 0 && images.length != null) {
                            } else {
                              EasyLoadingUtil.showLoading(statusText: "...");
                              imagePaths = await uploadQianShouImages();
                            }

                            if (widget.httpType == 0) {
                              final value =
                                  await HttpServices().addPrepareOrder(
                                depotId: widget.depotId,
                                orderIdName: widget.orderIdName,
                                prepareImgUrl: imagePaths,
                                orderOperationalRequirements:
                                    widget.orderOperationalRequirements,
                                logisticsMode: "快递",
                                hairPhoneNumber: WMSUser.getInstance()
                                    .userInfoModel
                                    .phoneNum,
                                mailNo: mailNo.text ?? '',
                                boxTotal: boxTotal.text.replaceAll(" ", "").length==0?0:int.parse(boxTotal.text),
                                remark: remark.text ?? '',
                                status: '0',
                              );

                              if (value['result']) {
                                EasyLoadingUtil.hidden();
                                EasyLoadingUtil.showMessage(
                                    message: '已提交预约入库数据');
                                Get.to(() => CSYbrkTabPage(defaultIndex: 0));
                              }
                              // EasyLoadingUtil.showLoading(statusText: "...");
                              if (value['result'] == false) {
                                EasyLoadingUtil.hidden();
                                EasyLoadingUtil.showMessage(
                                    message: value['data']);
                                return false;
                              }
                            } else {
                              print(mailNo.text);

                              var data =
                                  await HttpServices().updataPrepareOrder(
                                orderId: widget.orderId,
                                mailNo: mailNo.text ?? '',
                                status: '0',
                                logisticsMode: "快递",
                                boxTotal: boxTotal.text.replaceAll(" ", "").length==0?0:int.parse(boxTotal.text),
                                remark: remark.text,
                                prepareImgUrl: imagePaths ?? '',
                              );
                              if (data != false) {
                                // EasyLoadingUtil.showLoading(statusText: "...");
                                EasyLoadingUtil.showMessage(
                                    message: '已提交预约入库数据');
                                Get.to(() => CSYbrkTabPage(defaultIndex: 0));
                              }
                            }
                          },
                    child: Text(
                      '确认并发货',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildCommodityList(list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.h,
                color: Colors.grey[200],
              ),
            ),
          ),
          child: Column(
            children: [
              CommodityCellWidget(
                picturePath: list[index]['picturePath'] ?? '',
                name: list[index]['commodityName'],
                brandName: list[index]['brandName'],
                stockCode: list[index]['stockCode'] ?? '',
              ),
              Visibility(
                  visible: list[index]['skuDataList'].length != 0,
                  child: buildTableHeadWdidget(['尺码/规格', '条形码(sku)', '入库数量'])),
              buildSKuInfoWdidget(
                editable: false,
                skuCodeShow: true,
                removeButton: false,
                list: list[index]['skuDataList'],
              ),
            ],
          ),
        );
      },
      itemCount: list.length ?? 0,
    );
  }
}
