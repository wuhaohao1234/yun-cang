import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:wms/models/entrepot/en_sku_detail_model.dart';

class WMSShippingTable extends StatelessWidget {
  final ENSkuDetailModel eNSkuDetailModel;
  final Function(int) callback;

  const WMSShippingTable({Key key, this.eNSkuDetailModel, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
          border: TableBorder.all(width: 1.0, color: Colors.grey[100]),
          children: buildTableChildren()),
    );
  }

  List<TableRow> buildTableChildren() {
    List<TableRow> children = [];
    children.add(buildTitles());
    children.addAll(buildTableRows());

    return children;
  }

  TableRow buildTitles() {
    List<Widget> widgets = [];
    List<String> titles = ['序号', '尺码', '状态', '照片', 'APP', '毒'];
    widgets.add(
      TableCell(
        child: Center(
          child: buildTableCellWidget(
              child: Icon(Icons.check_box_outline_blank_sharp)),
        ),
      ),
    );

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
    [1, 2, 3].forEach((element) {
      rows.add(TableRow(
        children: [
          TableCell(
            child: Container(
              height: 50.h,
              child: Center(
                child: buildTableCellWidget(
                    child: Icon(Icons.check_box_outline_blank_sharp)),
              ),
            ),
          ),
          TableCell(
            child: Container(
              height: 50.h,
              child: Center(
                child: Container(
                    child: Text(
                  element.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp),
                )),
              ),
            ),
          ),
          TableCell(
            child: Container(
              height: 50.h,
              child: Center(
                  child: Text(
                "M",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp),
              )),
            ),
          ),
          TableCell(
            child: Container(
              height: 50.h,
              child: Center(
                child: buildTableCellImage(
                  imagePaths:
                      'https://lupic.cdn.bcebos.com/20200412/3033368780_14_748_534.jpg;https://lupic.cdn.bcebos.com/20200412/3033368780_14_748_534.jpg;https://lupic.cdn.bcebos.com/20200412/3033368780_14_748_534.jpg'
                          ?.split(';'),
                ),
              ),
            ),
          ),
          TableCell(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 50.h,
                child: Center(
                  child: WMSText(
                    content: '瑕疵',
                  ),
                ),
              ),
            ),
          ),
          TableCell(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 50.h,
                child: Center(
                  child: WMSText(
                    content: '出价',
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          TableCell(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 50.h,
                child: Center(
                  child: WMSText(
                    content: '--',
                    color: Colors.grey,
                  ),
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
        Get.to(() => PhotoViewPage(
              images: imagePaths, //传入图片list
              index: 0, //传入当前点击的图片的index
            ));
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
