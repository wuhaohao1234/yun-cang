// 自主仓、新增自主仓库存
// import 'dart:html';

import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'cs_zizhucang_search_commodity_page.dart';
import 'cs_zizhucang_add_commodity_page.dart';
import 'package:wms/views/commodity_cell_widget.dart';
import 'package:wms/views/commodity_ybrk_choose_size_cell.dart';
import '../../../views/common/common_search_bar.dart';
import 'dart:io';
import 'package:wms/models/oss_model.dart';
import '../../../views/common/taking_photos.dart';
import '../kucun/cs_kucun_page.dart';

class CSZiZhuCangAddOrderPage extends StatefulWidget {
  final List commodityList;

  const CSZiZhuCangAddOrderPage({Key key, this.commodityList}) : super(key: key);

  @override
  _CSZiZhuCangAddOrderPageState createState() => _CSZiZhuCangAddOrderPageState();
}

class _CSZiZhuCangAddOrderPageState extends State<CSZiZhuCangAddOrderPage> {
  TextEditingController searchContent;
  TextEditingController remark;
  List<File> images = [];

  // List<String> flawLevels = ["99新", "95新", "90新"]; //对应的index为传入值
  List flawLevels = [
    {"text": "缺配件", "selected": false, "value": 0},
    {"text": "划痕磨损", "selected": false, "value": 1},
    {"text": "污渍", "selected": false, "value": 2},
    {"text": "做工", "selected": false, "value": 3}
  ]; //
  String flawLevelSelected = ""; // 默认瑕疵等级为N
  // int defectDegree = 0; //瑕疵情况0:99新，1:95新，2:90新
  int sourcePlace = 0; //商品所在地0 国现，1境外
  int spuFlaw = 0; //0 正常  1 瑕疵
  List skuList = [];
  String imgUrl = '';
  List customComodityList = [];
  List tempCommodityList = []; //临时商品列表

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

  // 上传入库单图片
  uploadQianShouImages() async {
    EasyLoadingUtil.showLoading(statusText: "检查并上传照片中...");
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

  Future<bool> addVirtualOrder() async {
    // 提交自主仓商品
    EasyLoadingUtil.showLoading();
    print('提交自主仓订单信息');

    var postList = [];

    for (var i = 0; i < skuList.length; i++) {
      if (skuList[i]['skuQty'] != 0) {
        // skuList.removeAt(i);
        postList.add(skuList[i]);
      }
    }
    print(postList);
    var data = await HttpServices().addVirtualOrder(
      defectDegree: spuFlaw == 0 ? null : flawLevelSelected,
      skuList: postList,
      sourcePlace: sourcePlace,
      status: spuFlaw,
    );
    if (data == false) {
      EasyLoadingUtil.hidden();
      return false;
    }
    if (data != false) {
      print(data);
      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

  Future<void> submitPostInfo() async {
    if (tempCommodityList.length > 1 && spuFlaw == 1) {
      EasyLoadingUtil.showMessage(message: "每次只能提交一件瑕疵商品，请删除其他商品");
      return false;
    }
    final imagePaths = spuFlaw == 1 ? await uploadQianShouImages() : null;
    // final imagePaths = spuFlaw == 1 ? 'dsdsdd' : null;

    // 上传图片URL到服务器 并且签收
    setState(() {
      if (spuFlaw == 1) {
        //瑕疵商品
        if ((imagePaths.length == 0 || imagePaths == null) && spuFlaw == 1) {
          EasyLoadingUtil.showMessage(message: "请添加瑕疵商品的照片");
          return false;
        }
        EasyLoadingUtil.showLoading(statusText: "确认添加照片...");
        var itemIndex = skuList.indexWhere((each) => each['skuQty'] >= 1);
        skuList[itemIndex]['imgUrl'] = imagePaths;
      }

      if (spuFlaw == 0) {
        //正常商品
        skuList = skuList;
      }
      print(skuList);
      //删除多余的为0的sku
      for (var i = 0; i < skuList.length; i++) {
        if (spuFlaw == 1) {
          if (skuList[i]['skuQty'] >= 1) {
            skuList[i]['skuQty'] = 1;
          }
        }
        if (skuList[i]['skuQty'] == 0) {
          skuList.removeAt(i);
        }
      }
    });

    final value = await addVirtualOrder();
    print(value);
    if (value == false) {
      EasyLoadingUtil.showMessage(message: "未成功提交");
      return false;
    } else {}
    setState(() {
      for (var index = 0; index < images.length; index++) {
        images[index].deleteSync();
      }
      images = [];
    });

    // EasyLoadingUtil.hidden();
    EasyLoadingUtil.showMessage(message: "已成功提交");

    Get.offAll(() => KuCunPage());
    // 跳到下一个扫码
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '新增自主仓库存',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => KuCunPage());
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionTitleWidget(
                          title: '商品信息',
                        ),
                        WMSButton(
                            height: 20.h,
                            width: 70.w,
                            fontSize: 12.sp,
                            bgColor: Colors.transparent,
                            textColor: Colors.black,
                            showBorder: true,
                            title: '申请新品',
                            callback: () async {
                              var commoditydata = await Get.to(() => CSZiZhuCangAddCommodityPage());
                              if (commoditydata != null) {
                                setState(() {
                                  // tempCommodityList.add(commoditydata);
                                  customComodityList.add(commoditydata);
                                  EasyLoadingUtil.hidden();
                                  return true;
                                });
                              }
                              // Get.to(() => CSZiZhuCangAddCommodityPage());
                            }),
                      ],
                    ),
                    Container(
                      child: CommonSearchBar(
                          placeHolder: '添加预约商品',
                          width: 300.w,
                          showScanIcon: false,
                          searchCallBack: () async {
                            print("cool");

                            //获取其他页面搜索数据
                            var commoditydata = await Get.to(
                                () => CSZiZhuCangSearchCommodityPage(postCommodityList: tempCommodityList));
                            print("back");
                            print(commoditydata);
                            if (commoditydata != null) {
                              setState(() {
                                tempCommodityList.addAll(commoditydata);

                                print(tempCommodityList);
                                //初始化加入sku List；
                                for (var i = 0; i < tempCommodityList.length; i++) {
                                  for (var j = 0; j < tempCommodityList[i]['skuDataList'].length; j++) {
                                    skuList.add({
                                      'skuQty': 0,
                                      'skuId': tempCommodityList[i]['skuDataList'][j]['skuId'],
                                      'imgUrl': null
                                    });
                                  }
                                }
                                EasyLoadingUtil.hidden();
                                return true;
                              });
                            }
                          }
                          // requestCommodityData(value);
                          ),
                    ),
                    // if (tempCommodityList.length == 0)
                    //   Container(
                    //     padding: EdgeInsets.symmetric(vertical: 40),
                    //     alignment: Alignment.center,
                    //     child: WMSText(content: '请添加商品'),
                    //   )
                    if (tempCommodityList.length != 0)
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: buildList(tempCommodityList, "search"),
                            // child: Text("good")
                          ),
                        ],
                      ),

                    Visibility(
                      visible: tempCommodityList.length != 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("商品所在地"), // Huzi@04/25: 这里可能要多加hinttext, 可能要多行
                          ),
                          SizedBox(width: 20.w),
                          Radio(
                            value: '0',
                            groupValue: sourcePlace.toString(),
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                print(value);
                                sourcePlace = int.parse(value);
                              });
                            },
                          ),
                          WMSText(content: '国现', color: sourcePlace == 0 ? Colors.black : Colors.grey),
                          SizedBox(
                            width: 8.w,
                          ),
                          Radio(
                            value: '1',
                            groupValue: sourcePlace.toString(),
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                print(value);
                                sourcePlace = int.parse(value);
                              });
                            },
                          ),
                          WMSText(content: '境外', color: sourcePlace == 1 ? Colors.black : Colors.grey),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: tempCommodityList.length != 0,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("商品状态"), // Huzi@04/25: 这里可能要多加hinttext, 可能要多行
                          ),
                          SizedBox(width: 20.w),
                          //
                          Row(
                            children: [
                              Radio(
                                value: '0',
                                groupValue: spuFlaw.toString(),
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    spuFlaw = int.parse(value);
                                  });
                                },
                              ),
                              WMSText(content: '正常', color: spuFlaw == 0 ? Colors.black : Colors.grey),
                              SizedBox(
                                width: 8.w,
                              ),
                              Radio(
                                value: '1',
                                groupValue: spuFlaw.toString(),
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    spuFlaw = int.parse(value);
                                    EasyLoadingUtil.showMessage(message: '请点击尺码进行选择');
                                  });
                                },
                              ),
                              WMSText(content: '瑕疵', color: spuFlaw == 1 ? Colors.black : Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: spuFlaw == 1 && tempCommodityList.length != 0,
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("瑕疵等级"), // Huzi@04/25: 这里可能要多加hinttext, 可能要多行
                            ),
                            SizedBox(width: 20.w),
                            // flawLevels
                            Expanded(
                              child: Container(
                                child: Wrap(
                                  children: [
                                    for (int i = 0; i < flawLevels.length; i++)
                                      Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                                child: Checkbox(
                                              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                              shape: CircleBorder(),
                                              side: BorderSide(width: 2, color: Colors.black54),
                                              activeColor: AppConfig.themeColor,
                                              checkColor: Colors.white,
                                              value: flawLevels[i]['selected'],
                                              // 选中当前
                                              onChanged: (v) {
                                                setState(() {
                                                  flawLevels[i]['selected'] = v;
                                                  var tempFlawList = [];
                                                  for (var i = 0; i < flawLevels.length; i++) {
                                                    if (flawLevels[i]['selected']) {
                                                      tempFlawList.add(flawLevels[i]['value']);
                                                    }
                                                  }
                                                  flawLevelSelected = tempFlawList.join(',');
                                                  print(flawLevelSelected);
                                                });
                                              },
                                            )),
                                            Text(
                                              flawLevels[i]['text'],
                                              style: TextStyle(
                                                  color:
                                                      flawLevelSelected == flawLevels[i] ? Colors.black : Colors.grey),
                                            )
                                          ],
                                        ),
                                        padding: EdgeInsets.only(right: 10.h),
                                      )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    Visibility(
                      visible: spuFlaw == 1,
                      child: SectionTitleWidget(
                        title: '商品照片(必填)',
                      ),
                    ),
                    Visibility(
                      visible: spuFlaw == 1,
                      child: WMSUploadImageWidget(
                        images: images,
                        addCallBack: () {
                          Get.to(() => CommonTakePhotosPage(
                                images: images,
                              )).then((value) {
                            print("得到结果 $value");
                            setState(() {});
                          });
                        },
                        delCallBack: (index) {
                          if (images.length > 0) {
                            images.removeAt(index);
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    // Visibility(
                    //     visible: spuFlaw == 1,
                    //     child: buildItemsImage(pageController)),
                    SizedBox(
                      height: 20.h,
                    ),
                    Visibility(
                      visible: spuFlaw == 1,
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.multiline,
                        controller: remark,
                        style: TextStyle(fontSize: 13.sp),
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: '请描述商品状态，如包装破损、缺配件，五金磨损、皮质划痕、缺吊牌等',
                          // border: InputBorder.none,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey[200], width: 0.1)),
                          hintStyle: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        if (customComodityList.length != 0) ...[
                          SectionTitleWidget(
                            title: '自主仓新品商品信息',
                          ),
                          Column(
                            children: [
                              Container(
                                color: Colors.white,
                                child: buildList(customComodityList, "custome"),
                                // child: Text("goodx"),
                              ),
                            ],
                          )
                        ],
                        SizedBox(
                          height: 20.h,
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
                padding: EdgeInsets.only(bottom: 20.h),
                color: Colors.white,
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(90.w, 34.w)),
                    fixedSize: MaterialStateProperty.all(Size(343.w, 34.w)),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => !(tempCommodityList.length == 0 ||
                            skuList.length == 0 ||
                            skuList.fold(0, (previousValue, element) => previousValue + element['skuQty']) == 0)
                        ? AppStyleConfig.btnColor
                        : null),
                  ),
                  onPressed: tempCommodityList.length == 0 ||
                          skuList.length == 0 ||
                          skuList.fold(0, (previousValue, element) => previousValue + element['skuQty']) == 0
                      ? null
                      : () {
                          //设置按钮状态；
                          print("skuList = ${skuList.length}");
                          var total_quantity =
                              skuList.fold(0, (previousValue, element) => previousValue + element['skuQty']);
                          if (spuFlaw == 1) {
                            var counts = skuList.where((element) => element['skuQty'] >= 1).length;
                            print("counts = $counts");
                            if (counts > 1) {
                              ToastUtil.showMessage(message: "只能选中一个瑕疵商品尺寸");
                              return;
                            }
                          } else if (spuFlaw == 1 && total_quantity == 0) {
                            ToastUtil.showMessage(message: "请选择尺码");
                            return;
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                          submitPostInfo();
                        },
                  child: Text(
                    '新增自主仓库存',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildBarcodeWdidget(
  //     CSZiZhuCangAddCommodityPageController pageController) {
  //   return WMSCodeInputWidget(
  //     controller: pageController.labelBarCode,
  //     callback: () => pageController.onTapScanBarcode(),
  //   );
  // }

// 商品清单
  Widget buildList(comodityList, listType) {
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
              Stack(
                children: [
                  CommodityCellWidget(
                    picturePath: comodityList[index]['picturePath'] ?? '',
                    name: comodityList[index]['commodityName'],
                    brandName: comodityList[index]['brandName'],
                    stockCode: comodityList[index]['stockCode'] ?? '',
                  ),
                  Visibility(
                    //如果正常搜索商品，显示”移除按钮“
                    visible: listType == "search",
                    child: Positioned(
                        child: IconButton(
                          icon: new Icon(Icons.cancel),
                          color: Colors.grey,
                          iconSize: 18.0,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) => AlertDialog(
                                      title: Text("删除提示"),
                                      content: Text("确认删除此商品?"),
                                      actions: <Widget>[
                                        buildButtonWidget(
                                          width: 120.w,
                                          height: 34.h,
                                          buttonContent: '取消',
                                          handelClick: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          radius: 2.0,
                                        ),
                                        buildButtonWidget(
                                          width: 120.w,
                                          height: 34.h,
                                          buttonContent: '确认',
                                          bgColor: AppConfig.themeColor,
                                          contentColor: Colors.white,
                                          handelClick: () {
                                            // widget.onDeleteFunc(widget.skuIndex);
                                            print(comodityList[index]['skuDataList']);
                                            comodityList[index]['skuDataList'].forEach((element) {
                                              var itemIndex =
                                                  skuList.indexWhere((each) => each['skuId'] == element['skuId']);
                                              print("itemIndex$itemIndex}");
                                              if (itemIndex != -1) {
                                                setState(() {
                                                  skuList.removeAt(itemIndex);
                                                });
                                              }
                                            });

                                            Navigator.of(context).pop(true);

                                            setState(() {
                                              comodityList.removeAt(index);
                                            });
                                            EasyLoadingUtil.showMessage(message: '已删除此数据');
                                          },
                                          radius: 2.0,
                                        ),
                                      ],
                                    ));
                          },
                        ),
                        top: 5,
                        right: 5),
                  )
                ],
              ),
              //设置正常商品数量

              if (listType == "search")
                if (spuFlaw == 0)
                  Container(
                      child: buildCommoditySizeList(
                    comodityList[index]['skuDataList'],
                    false,
                  ))
                else
                  buildSizeListWidget(
                    comodityList[index]['skuDataList'],
                  )
              else
                Container(
                    child: CommodityChooseSizeWidget(
                        size: comodityList[0]['skuDataList'][0]['size'],
                        specification: comodityList[0]['skuDataList'][0]['specification'],
                        checkValue: true,
                        checkButtonshow: false,
                        editButtonShow: false,
                        initNumber: int.parse(comodityList[0]['skuDataList'][0]['commodityNumber'])))
            ],
          ),
        );
      },
      itemCount: comodityList.length ?? 0,
    );
  }

  // 在售尺寸
  Widget buildSizeListWidget(skuSizeList) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text("尺码"),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: buildSizeList(skuSizeList),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildSizeList(list) {
    List<Widget> widgets = [];
    list?.forEach((element) {
      widgets.add(buildSizeItemWidget(element));
    });

    return widgets;
  }

  Widget buildSizeItemWidget(element) {
    var _index = skuList.indexWhere((each) => each['skuId'] == element['skuId']);
    return Container(
      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          // pageController.setSkuIdData(model);
          setState(() {
            var itemIndex = skuList.indexWhere((each) => each['skuId'] == element['skuId']);

            skuList[itemIndex]['skuQty'] = skuList[itemIndex]['skuQty'] >= 1 ? 0 : 1;
            // var oldItemIndex =
            //     skuList.indexWhere((each) => each['skuQty'] == 1);
            // print("oldItemIndex$oldItemIndex");
            // if (itemIndex != oldItemIndex && oldItemIndex != -1) {
            //   //清除旧的item数量
            //   EasyLoadingUtil.showMessage(message: '只能选中一个瑕疵商品尺寸');
            //   skuList[oldItemIndex]['skuQty'] = 0;
            // }
            // if (skuList.fold(
            //         0,
            //         (previousValue, element) =>
            //             previousValue + element['skuQty']) ==
            //     1) {
            //   skuList[itemIndex]['skuQty'] = 0;
            // } else {
            //   skuList[itemIndex]['skuQty'] = 1;
            // }
          });
          print(skuList);
        },
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.r)),
            border: _index == -1
                ? null
                : (skuList[_index]['skuQty'] >= 1 ? Border.all(width: 2.0, color: Colors.black) : null),
            color: Colors.grey[200],
          ),
          child: Column(
            children: [
              WMSText(
                content:  '${element['size'] ?? '无尺码'}${element['specification']!= null ? "/" + element['specification']: ""}',
                size: 14,
                bold: true,
              ),
              SizedBox(
                height: 4.h,
              ),
              WMSText(
                content: '1件',
                size: 13,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCommoditySizeList(skuSizeList, itemCheckValue) {
    if (skuSizeList.length != 0) {
      return ListView.builder(
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CommodityChooseSizeWidget(
              size: skuSizeList[index]['size'],
              specification: skuSizeList[index]['specification'],
              initNumber: skuList[skuList.indexWhere((each) => each['skuId'] == skuSizeList[index]['skuId']) == -1
                  ? 0
                  : skuList.indexWhere((each) => each['skuId'] == skuSizeList[index]['skuId'])]['skuQty'],
              checkValue: true,
              checkButtonshow: false,
              onChangeCallback: (value) {
                setState(() {
                  var itemIndex = skuList.indexWhere((element) => element['skuId'] == skuSizeList[index]['skuId']);
                  skuList[itemIndex]['skuQty'] = value;
                  // skuList[itemIndex]['imgUrl'] = imgUrl;
                  //正常商品暂时不用添加imgUrl
                  print("$itemIndex 的商品数量修改为了 $value");
                  print(skuList);
                });
              });
        },
        itemCount: skuSizeList.length ?? 0,
      );
    }
  }
}
