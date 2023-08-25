import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/baseWidgets/wm_code_input_widget.dart';
import 'package:wms/common/baseWidgets/wms_upload_image_widget.dart';
import 'package:wms/common/baseWidgets/wms_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'en_sku_table_cell.dart';
import 'package:wms/models/entrepot/en_sku_detail_model.dart';
import 'package:wms/views/entrenpot/en_rkd_top_widget.dart';
import 'package:wms/views/entrenpot/en_table_cell.dart';
import 'package:wms/common/baseWidgets/wms_info_row.dart';

Widget buildSkuWdidget(model) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: .5,
          color: Colors.grey[200],
        ),
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    color: Colors.black,
                    size: 17,
                  ),
                  Expanded(
                    child: WMSInfoRow(
                      title: 'spu：',
                      content: '${model?.spuId ?? 0}',
                      leftInset: 8,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              color: Colors.black,
              size: 17,
            ),
            Expanded(
                child: WMSInfoRow(
              title: 'sku：',
              content: '${model?.skuId ?? 0}',
              leftInset: 8,
            )),
          ],
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              color: Colors.black,
              size: 17,
            ),
            Expanded(
                child: WMSInfoRow(
              title: 'size：',
              content: '${model?.size ?? '无尺码'}',
              leftInset: 8,
            )),
          ],
        ),
        SizedBox(
          height: 4.h,
        ),
      ],
    ),
  );
}

// 商品状态
Widget buildSpztWidget(pageController) {
  return Obx(() {
    return Row(
      children: [
        WMSText(
          content: '商品状态',
        ),
        Radio(
          value: 0,
          groupValue: pageController.itemsState.value,
          activeColor: Colors.blue,
          onChanged: (value) {
            pageController.changeItemsState(value);
          },
        ),
        WMSText(
          content: '正常',
        ),
        SizedBox(
          width: 8.w,
        ),
        Radio(
          value: 1,
          groupValue: pageController.itemsState.value,
          activeColor: Colors.blue,
          onChanged: (value) {
            pageController.changeItemsState(value);
          },
        ),
        WMSText(
          content: '瑕疵',
        ),
      ],
    );
  });
}

// SN码
Widget buildSNcodeWdidget(pageController) {
  // return WMSCodeInputWidget(
  //   controller: pageController.sncodeC,
  //   callback: () => pageController.onTapScanBarcode(),
  // );
  return WMSTextField(
      title: 'SN码',
      hintText: '必填',
      keyboardType: TextInputType.number,
      controller: pageController.sncodeC,
      endWidget: GestureDetector(
        onTap: () {
          print(pageController.sncodeC.text);
        },
        child: SvgPicture.asset(
          'assets/svgs/scan.svg',
          width: 17.w,
        ),
      ));
}

// SKU码
Widget buildSKUCodeWdidget(pageController) {
  // return WMSCodeInputWidget(
  //   controller: pageController.skucodeC,
  //   callback: () => pageController.onTapScanSKUcode(),
  // );
  return WMSTextField(
      title: 'SKU码',
      hintText: '必填',
      controller: pageController.skucodeC,
      keyboardType: TextInputType.number,
      endWidget: GestureDetector(
        onTap: () {},
        child: SvgPicture.asset(
          'assets/svgs/scan.svg',
          width: 17.w,
        ),
      ));
}

// 商品照片
Widget buildItemsImage(pageController) {
  return Obx(() {
    return WMSUploadImageWidget(
      canDelete: true,
      maxLength: 6,
      images: pageController.itemsImages,
      addCallBack: () {
        print('add =======');
        pageController.onTapAddItemsImage();
      },
      delCallBack: (index) {
        pageController.onTapDelItemsImage(index);
      },
    );
  });
}

// 货号照片
Widget buildArticleNumberImage(pageController) {
  return Obx(() => WMSUploadImageWidget(
        maxLength: 6,
        images: pageController.articleNumberImage.value,
        addCallBack: () {
          print('add =======');
          pageController.onTapAddArticleNumberImage();
        },
        delCallBack: (index) {
          pageController.onTapDelArticleNumberImage(index);
        },
      ));
}

// 条形码
Widget buildBarcodeWdidget(pageController) {
  return WMSCodeInputWidget(
    controller: pageController.barcodeC,
    callback: () => pageController.onTapScanBarcode(),
  );
}

// 商品尺寸
Widget buildSizeWdidget(pageController) {
  return Container(
      padding: EdgeInsets.only(bottom: 16.w),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text("尺码"),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pageController.setItemSize("s");
                    },
                    child: Text("S"),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: pageController.itemSize == "s"
                          ? MaterialStateProperty.all(Colors.black)
                          : MaterialStateProperty.all(Colors.grey),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      pageController.setItemSize("m");
                    },
                    child: Text("M"),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: pageController.itemSize == "m"
                          ? MaterialStateProperty.all(Colors.black)
                          : MaterialStateProperty.all(Colors.grey),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      pageController.setItemSize("l");
                    },
                    child: Text("L"),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: pageController.itemSize == "l"
                          ? MaterialStateProperty.all(Colors.black)
                          : MaterialStateProperty.all(Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 40.w,
          ),
        ],
      ));
}

class SkuInfoBlock extends StatefulWidget {
  final bool editable;
  final dynamic spu;
  final List titles;
  final num delKey;
  SkuInfoBlock({Key key, this.editable, this.spu, this.titles, this.delKey})
      : super(key: key);

  @override
  State<SkuInfoBlock> createState() => _SkuInfoBlockState();
}

class _SkuInfoBlockState extends State<SkuInfoBlock> {
  bool showmore = false;

  @override
  Widget build(BuildContext context) {
    print(widget.spu);
    final radius = 5.r;

    return Container(
      color: Colors.red,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey[100],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
              height: 60.h,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: 40.h,
                        width: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          color: Colors.grey[100],
                        ),
                        child: WMSText(
                          content: widget.spu['size'] ?? '无',
                          size: 11,
                          bold: true,
                        ),
                      ),
                    ),
                  ),
                  // 这里可以禁止编辑 如果 editable 为false.
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.h,
                      // width: 60,
                      child: widget.editable
                          ? TextField(
                              maxLines: 1,
                              cursorColor: Colors.black,
                              controller: TextEditingController(
                                text: widget.spu['skuId'].toString(),
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: radius),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(radius),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.1)),
                                hintText: 'SKU ID',
                                hintStyle: TextStyle(fontSize: 8.sp),
                              ),
                            )
                          : WMSText(
                              content: widget.spu['skuId'].toString(),
                              size: 11,
                              bold: true,
                            ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40.h,
                                width: 40,
                                child: Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40.h,
                                    width: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(radius),
                                      color: Colors.grey[100],
                                    ),
                                    child: WMSText(
                                      content:
                                          widget.spu['actualNumber'].toString(),
                                      size: 11,
                                      bold: true,
                                    ),
                                  ),
                                ),
                              ),
                              //保持无
                              Visibility(
                                visible:
                                    widget.spu['sysPrepareSkuList'] != null,
                                //  ??
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showmore = !showmore;
                                    });
                                  },
                                  child: Icon(
                                    showmore == true
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            // 如果点击了小三角,则展示sku的列表详情
            Visibility(
              visible: showmore,
              child: ENSkuTableCell(
                eNSkuDetailModel: ENSkuDetailModel.fromJson(
                  {'skus': widget.spu['sysPrepareSkuList']},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SKU信息
Widget buildSKuInfoWdidget({
  List list,
  bool editable: true,
}) {
  List<Widget> listWidget = [];
  for (var index = 0; index < list.length; index++) {
    listWidget.add(
      SkuInfoBlock(
        spu: list[index],
        editable: editable,
        delKey: index,
      ),
    );
  }

  return Column(
    children: listWidget,
  );
}

// 单个商品信息
class SingleShangPingCell extends StatefulWidget {
  final dynamic commodity;
  final bool editable;
  TextEditingController depotId;
  SingleShangPingCell({
    Key key,
    this.commodity,
    this.depotId,
    this.editable = false,
  }) : super(key: key);

  @override
  State<SingleShangPingCell> createState() => _SingleShangPingCellState();
}

class _SingleShangPingCellState extends State<SingleShangPingCell> {
  bool showmore = true;

  // final depotId = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ENRkdDetailTopWidget(
          picturePath: widget.commodity['picturePath'] ?? '',
          name: widget.commodity['commodityName'],
          brandName: widget.commodity['brandName'],
          stockCode: widget.commodity['stockCode'],
        ),
        WMSTextField(
          title: "绑定库位",
          keyboardType: TextInputType.text,
          controller: widget.depotId,
        ),
        buildTableHeadWdidget(['尺码/规格', '条形码(sku)', '实收数量']),
        buildSKuInfoWdidget(
          list: widget.commodity['sysPrepareOrderSpuList'],
          editable: widget.editable,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

// 更新的部分, 这里的Sku 列表可以删除

// SPU列表信息
// Widget buildSpuList({
//   List spuList,
//   bool editable: true,
// }) {
//   List<Widget> listWidget = [];
//   for (var index = 0; index < spuList.length; index++) {
//     listWidget.add(
//       SpuInfoBlock(
//         spu: spuList[index],
//         editable: editable,
//         delKey: index,
//       ),
//     );
//   }

//   return Column(
//     children: listWidget,
//   );
// }
