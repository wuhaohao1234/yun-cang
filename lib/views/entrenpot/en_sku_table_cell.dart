import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:wms/models/entrepot/en_sku_detail_model.dart';

class ENSkuTableCell extends StatelessWidget {
  final ENSkuDetailModel eNSkuDetailModel;
  final Function(int) callback;
  final List titles;

  ENSkuTableCell(
      {Key key,
      this.eNSkuDetailModel,
      this.callback,
      this.titles = const ['SN码', '照片', '状态']})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('${eNSkuDetailModel.skus?.length}' + '记得看啦就是');
    return Container(
      child: Table(
          border: TableBorder.all(width: 1.0, color: Colors.grey[100]),
          children: buildTableChildren()),
    );
  }

  List<TableRow> buildTableChildren() {
    List<TableRow> children = [];
    children.add(buildTitles());
    if (eNSkuDetailModel != null && eNSkuDetailModel.skus != null) {
      children.addAll(buildTableRows());
    }

    return children;
  }

  TableRow buildTitles() {
    List<Widget> widgets = [];

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
    eNSkuDetailModel?.skus?.forEach((element) {
      rows.add(TableRow(
        children: [
          TableCell(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => callback(element.id),
              child: Container(
                height: 50.h,
                child: Center(
                    child: Text(
                  element.barCode ?? element.warehousingOrderCode ?? '',
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
                child: titles[1] == '照片'
                    ? buildTableCellImage(
                        imagePaths: element.imgUrl?.split(';'),
                      )
                    : Text(
                        element.snCode ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.sp),
                      ),
              ),
            ),
          ),
          TableCell(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => callback(element.id),
              child: Container(
                height: 50.h,
                child: Center(
                  child: titles[2] == "状态"
                      ? WMSText(
                          content: element.status == '0' ? '正常' : '瑕疵',
                          color:
                              element.status == '0' ? Colors.black : Colors.red,
                        )
                      : Text(
                          element.sortingSkuNumber.toString() ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.sp),
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
