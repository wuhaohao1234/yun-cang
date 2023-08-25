import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_button.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:wms/customer/market/controllers/market_all_commodity_page_controller.dart';
import 'package:wms/models/market/chu_huo_shipment_normal_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChuHuoSheetWidget extends StatefulWidget {
  final ChuHuoShipmentNormalModel dataModel;

  ChuHuoSheetWidget({Key key, this.dataModel}) : super(key: key);

  @override
  _ChuHuoSheetWidgetState createState() => _ChuHuoSheetWidgetState();
}

class _ChuHuoSheetWidgetState extends State<ChuHuoSheetWidget> {
  MarketAllCommodityPageController pageController =
      Get.find<MarketAllCommodityPageController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(width: 1.0, color: Colors.grey[100]),
              children: buildTableChildren(),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: WMSButton(
            title: '下单',
            callback: () {
              Get.back();
              // pageController.count.value =
              //     pageController.selectsysPrepareSkuIds.length;
              // setUpWidget(context, MKPlaceOrderPage());
            },
          ),
        )
      ],
    );
  }

  List<TableRow> buildTableChildren() {
    List<TableRow> children = [];
    children.add(buildTitles());
    if (widget.dataModel.sysPrepareSkuList != null) {
      children.addAll(buildTableRows());
    }

    return children;
  }

  TableRow buildTitles() {
    List<Widget> widgets = [];
    List<String> titles = ['', 'SN码', '照片'];
    titles.forEach((element) {
      widgets.add(
        TableCell(
          child: Center(
            child: buildTableCellWidget(
              child: WMSText(
                content: element,
              ),
            ),
          ),
        ),
      );
    });
    return TableRow(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        children: widgets);
  }

  List<TableRow> buildTableRows() {
    List<TableRow> rows = [];
    widget.dataModel.sysPrepareSkuList?.forEach((element) {
      rows.add(TableRow(
        children: [
          TableCell(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: null,
              child: Container(
                  height: 44.h,
                  child: Center(
                      child: Checkbox(
                    value: element.selected,
                    activeColor: Colors.black,
                    onChanged: (bool value) {
                      setState(() {
                        element.selected = value;
                        if (value) {
                          // pageController.selectsysPrepareSkuIds.add(element.id);
                        } else {
                          // pageController.selectsysPrepareSkuIds
                          //     .remove(element.id);
                        }
                      });
                    },
                  ))),
            ),
          ),
          TableCell(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: null,
              child: Container(
                height: 44.h,
                child: Center(
                  child: Container(
                      child: Text(
                    element.barCode ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp),
                  )),
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              height: 44.h,
              child: Center(
                child: buildTableCellImage(
                  imagePaths: element.imgUrl?.split(';'),
                ),
              ),
            ),
          ),
        ],
      ));
    });
    return rows;
  }

  Widget buildTableCellWidget({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: child,
    );
  }

  Widget buildTableCellImage({List<String> imagePaths}) {
    if (imagePaths == null || imagePaths?.length == 0) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        // print(imagePaths.toString());
        // Navigator.pushNamed(context, '/PhotoViewPage');
        // Get.to(()=>()=>PhotoViewPage(
        //   images: imagePaths, //传入图片list
        //   index: 0, //传入当前点击的图片的index
        // ));
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PhotoViewPage(
            images: imagePaths, //传入图片list
            index: 0, //传入当前点击的图片的index
          );
        }));
      },
      child:
          buildImageWidget(imagePath: imagePaths[0], count: imagePaths.length),
    );
  }

  Widget buildImageWidget({
    String imagePath,
    int count,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CachedNetworkImage(
            imageUrl: imagePath,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(
              value: downloadProgress.progress,
              backgroundColor: Colors.black,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Positioned(
            child: Visibility(
              visible: count > 0,
              child: Text(
                "+$count",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
