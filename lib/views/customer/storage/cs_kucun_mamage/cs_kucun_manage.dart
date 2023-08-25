import 'package:flutter/services.dart';
import 'package:wms/customer/common.dart';

import 'cs_kucun_manage_controller.dart';

class CSKuCunManage extends StatefulWidget {
  final model;
  final type;
  final callback;

  const CSKuCunManage({Key key, this.model, this.type, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    Get.put(CsKuCunManageController());
    return CSKuCunManageState();
  }
}

class CSKuCunManageState extends State<CSKuCunManage> with SingleTickerProviderStateMixin {
  List<String> tabTitles = ['正常', '瑕疵'];
  List<Widget> pages = [];
  TabController controller;
  CsKuCunManageController csKuCunManageController = Get.find();

  @override
  void initState() {
    controller = TabController(
      length: 2,
      vsync: this,
    );
    setState(() {
      pages = [
        ListPage(
            status: 0,
            type: widget.type,
            callback: () {
              csKuCunManageController.getDetail(
                  type: widget.type, depotId: widget.model.depotId, spuId: widget.model.spuId, status: 0);
              widget.callback();
            }),
        ListPage(
          status: 1,
          type: widget.type,
          callback: () {
            csKuCunManageController.getDetail(
                type: widget.type, depotId: widget.model.depotId, spuId: widget.model.spuId, status: 1);
            widget.callback();
          },
        )
      ];
    });
    csKuCunManageController.getDetail(
        type: widget.type, depotId: widget.model.depotId, spuId: widget.model.spuId, status: 0);

    csKuCunManageController.getDetail(
        type: widget.type, depotId: widget.model.depotId, spuId: widget.model.spuId, status: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("我的在售"),
          leading: BackButton(
            onPressed: () {
              Get.back();
            },
          )),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => PhotoViewPage(
                          images: widget.model.picturePath.split(';'),
                          //传入图片list
                          index: 0, //传入当前点击的图片的index
                        ));
                  },
                  child: Container(
                    width: 80.w,
                    height: 60.h,
                    child: Image.network(
                      widget.model?.picturePath ?? '-',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WMSText(
                        content: widget.model?.commodityName ?? '-',
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: JKOverScrollBehavior(),
                child: Container(
                  child: Column(
                    children: [
                      TabBar(
                        controller: controller,
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black54,
                        labelPadding: EdgeInsets.symmetric(horizontal: 0),
                        tabs: tabTitles
                            .map((title) => Tab(
                                    child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        title,
                                      ),
                                    ),
                                    // 列表数量角标
                                  ],
                                )))
                            .toList(),
                      ),
                      Expanded(
                          child: TabBarView(
                        children: pages,
                        controller: controller,
                      )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  final status;
  final type;
  final callback;

  const ListPage({Key key, this.status, this.callback, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CsKuCunManageController csKuCunManageController = Get.find();
    return Container(
      child: Obx(() => Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.h),
                color: Colors.grey[50],
                alignment: Alignment.centerRight,
                child: WMSText(
                  content:
                      "共${csKuCunManageController.sizeCount[status]}个规格,${csKuCunManageController.totalCount[status]}个库存",
                  size: 15,
                  color: Colors.grey[500],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        var model = csKuCunManageController.detailList[status][index];
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            margin: EdgeInsets.only(bottom: 10.h),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border(
                                    top: BorderSide(
                                      color: Colors.grey[300],
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.grey[300],
                                    ))),
                            child: Column(children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                    color: Colors.grey[300],
                                  )),
                                ),
                                child: Row(
                                  children: [
                                    WMSText(
                                      content:  model['size'],
                                      size: 15,
                                    ),
                                    Visibility(
                                      visible: model['specification'] != null,
                                      child: WMSText(
                                        content: "/${model['specification']}",
                                        size: 15,
                                      ),
                                    ),
                                    Spacer(),
                                    Visibility(
                                        visible: status == 0,
                                        child: WMSText(
                                          content: "数量x${model['skuCount']}",
                                          size: 15,
                                          bold: true,
                                        )),
                                    Visibility(
                                      visible: status == 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(() => PhotoViewPage(
                                                images: model['picturePath'].split(';'), //传入图片list
                                                index: 0, //传入当前点击的图片的index
                                              ));
                                        },
                                        child: Container(
                                          width: 40.w,
                                          height: 40.w,
                                          decoration: BoxDecoration(
                                            image: model['picturePath'] == null
                                                ? null
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                      model['picturePath'].split(';')[0],
                                                    ),
                                                    fit: BoxFit.contain,
                                                  ),
                                            border: Border.all(
                                              width: 1.w,
                                              color: Colors.grey[200],
                                            ),
                                          ),
                                          child: model['picturePath'] == null ? Text("无图片") : Container(),
                                        ),
                                      ),
                                    ),
                                    Spacer(flex: 2),
                                    Expanded(
                                        child: WMSText(
                                      content: "¥${model['salePrice']}",
                                      size: 15,
                                      bold: true,
                                    ))
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible: model['salePrice'] == null
                                      ? false
                                      : model['salePrice'] >= 5000
                                      ? true
                                      : false,
                                  child: Container(alignment: Alignment.centerRight,child: WMSText(content: "商品价格操过5000时需要承担税和邮费",color: Colors.red[400],size:12 ,),)),
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Expanded(child: Text("${model['updateTime']}")),
                                    buildButtonWidget(
                                      width: 48.w,
                                      bgColor: Colors.white,
                                      contentColor: Colors.black,
                                      buttonContent: '下架',
                                      handelClick: () async {
                                        var res = await ShowDialog(context: context, priceId: model['priceId']);
                                        if (res) {
                                          callback();
                                        }
                                      },
                                      radius: 2.0,
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    buildButtonWidget(
                                      width: 68.w,
                                      bgColor: AppConfig.themeColor,
                                      contentColor: Colors.white,
                                      buttonContent: '调整出价',
                                      handelClick: () async {
                                        var res = await ShowAdjust(context: context, model: model, status: status);
                                        if (res) {
                                          callback();
                                        }
                                      },
                                      radius: 2.0,
                                    )
                                  ]))
                            ]));
                      },
                      itemCount: csKuCunManageController.detailList[status].length)),
            ],
          )),
    );
  }

  ShowDialog({context, priceId}) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) => wvDialog(
            widget: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '下架提示',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text('您确定要下架此商品吗？',
                          style: TextStyle(
                            fontSize: 16.0,
                          ))),
                  SizedBox(height: 20.0),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    WMSButton(
                        title: '取消',
                        width: 120.w,
                        bgColor: Colors.transparent,
                        textColor: Colors.black,
                        showBorder: true,
                        callback: () {
                          Navigator.of(context).pop(false);
                        }),
                    WMSButton(
                        title: '确认',
                        width: 120.w,
                        bgColor: AppConfig.themeColor,
                        textColor: Colors.white,
                        showBorder: true,
                        callback: () async {
                          // widget.onDeleteFunc(widget.skuIndex);

                          var data = await HttpServices().csOnSaleOffSeparate(priceId: priceId, type: type);
                          if (data != false) {
                            // EasyLoadingUtil.showLoading(statusText: "...");
                            EasyLoadingUtil.showMessage(message: '已下架商品');
                            //如果1小程序 跳转index1 如果2集市 跳转0 如果3 转售 跳转2
                          }
                          Navigator.of(context).pop(true);
                        })
                  ])
                ]))));
  }

  ShowAdjust({context, model, status}) {
    var _model = model;
    TextEditingController priceController = TextEditingController();
    priceController.text = _model['salePrice'].toString();

    TextEditingController skuController = TextEditingController();
    skuController.text = _model['skuCount'].toString();

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, //允许bottomSheet高度自定义
        backgroundColor: Colors.transparent, //背景透明，保证下面的圆角矩形裁剪有效
        builder: (BuildContext c) {
          return StatefulBuilder(builder: (c,state){
           return ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
                child: IntrinsicHeight(
                  child: Container(
                      padding: EdgeInsets.all(16.w),
                      width: 375.w,
                      color: Colors.white,
                      constraints: BoxConstraints(maxHeight: 500.h),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WMSText(
                                content: _model['size'],
                              ),
                              Visibility(
                                  visible: status == 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => PhotoViewPage(
                                        images: _model['picturePath'].split(';'), //传入图片list
                                        index: 0, //传入当前点击的图片的index
                                      ));
                                    },
                                    child: Container(
                                      width: 40.w,
                                      height: 40.w,
                                      decoration: BoxDecoration(
                                        image: _model['picturePath'] == null
                                            ? null
                                            : DecorationImage(
                                          image: NetworkImage(
                                            _model['picturePath'].split(';')[0],
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                        border: Border.all(
                                          width: 1.w,
                                          color: Colors.grey[200],
                                        ),
                                      ),
                                      child: _model['picturePath'] == null ? Text("无图片") : Container(),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Divider(),
                        Visibility(
                          visible: status == 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                            child: Row(
                              children: [
                                WMSText(
                                  content: "数量",
                                ),
                                Spacer(),
                                Expanded(
                                    child: WMSText(
                                      content: "可用库存${_model['maxCount']}",
                                    )),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      if (skuController.text == '1') return;
                                      skuController.text = (int.parse(skuController.text) - 1).toString();
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      size: 14.sp,
                                    )),
                                Container(
                                  width: 50.w,
                                  height: 20.h,
                                  child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: skuController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)))),
                                ),
                                IconButton(
                                    onPressed: () {
                                      if (skuController.text == _model['maxCount'].toString()) return;
                                      skuController.text = (int.parse(skuController.text) + 1).toString();
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      size: 14.sp,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: status == 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WMSText(
                                  content: "数量",
                                ),
                                WMSText(
                                  content: "x1",
                                  bold: false,
                                  size: 14.sp,
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                          child: Row(
                            children: [
                              WMSText(
                                content: "价格",
                              ),
                              Spacer(),
                              WMSText(
                                content: "¥",
                                bold: true,
                                size: 16.sp,
                              ),
                              Container(
                                width: 100.w,
                                height: 20.h,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: priceController,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                                  ],
                                  onChanged: (e){
                                    state((){});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: priceController.text.trim().toString().length == 0
                                ? false
                                : double.parse(priceController.text.trim().toString()) >= 5000
                                ? true
                                : false,
                            child: WMSText(content: "商品价格操过5000时需要承担税和邮费",color: Colors.red[400],size:12 ,)),
                        Divider(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WMSButton(
                                  title: '取消',
                                  width: 100.w,
                                  height: 20.h,
                                  bgColor: Colors.transparent,
                                  textColor: Colors.black,
                                  showBorder: true,
                                  callback: () {
                                    Navigator.of(context).pop(false);
                                  }),
                              SizedBox(
                                width: 16.w,
                              ),
                              WMSButton(
                                  title: '调整出价',
                                  width: 100.w,
                                  height: 20.h,
                                  bgColor: AppConfig.themeColor,
                                  textColor: Colors.white,
                                  showBorder: true,
                                  callback: () async {
                                    var data = await HttpServices().csOnSaleAdjustPrice(
                                        priceId: _model['priceId'],
                                        type: type,
                                        price: priceController.text,
                                        skuCount: int.parse(skuController.text));
                                    if (data != false) {
                                      // EasyLoadingUtil.showLoading(statusText: "...");
                                      EasyLoadingUtil.showMessage(message: '已调整商品');
                                      //如果1小程序 跳转index1 如果2集市 跳转0 如果3 转售 跳转2
                                    }
                                    Navigator.of(context).pop(true);
                                  })
                            ],
                          ),
                        )
                      ])),
                ),
              ),
            );
          });
        });
  }
}
