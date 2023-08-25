// 理货单 Cell
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/models/entrepot/ruku/en_rkd_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wms/utils/wms_util.dart';

class DaiLiHuoCell extends StatelessWidget {
  final VoidCallback callback;
  final ENRkdModel model;
  final bool imgshow;
  final int index; //for debugging purpose

  const DaiLiHuoCell(
      {Key key, this.callback, this.model, this.imgshow, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = 4.h;
    var decoration;
    if (model.instoreOrderImg != null) {
      decoration = model.instoreOrderImg.split(";")[0] != ''
          ? BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(model.instoreOrderImg.split(";")[0]),
                fit: BoxFit.contain,
              ),
              border: Border.all(
                width: 3.w,
                color: Colors.grey[200],
              ),
            )
          : BoxDecoration(
              border: Border.all(
                width: 3.w,
                color: Colors.grey[200],
              ),
            );
    } else {
      decoration = null;
    }
  // print("model+++${ENRkdModel model}");
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: .5,
            color: Colors.grey[200],
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // debugging
          // Text(
          //   '(DEBUG) ID:$index, prepareOrderId：${model?.prepareOrderId ?? 0}',
          //   style: TextStyle(
          //     fontSize: 10,
          //     color: Colors.redAccent,
          //   ),
          // ),
          Row(
            children: [
              if (imgshow)
                // 如有图片,允许用户点击以放大图片
                GestureDetector(
                  onTap: model.instoreOrderImg == ""
                      ? null
                      : () {
                          Get.to(() => PhotoViewPage(
                                images:
                                    model.instoreOrderImg.split(';'), //传入图片list
                                index: 0, //传入当前点击的图片的index
                              ));
                          // Get.to(() => SimpleImageFullScreenPreview(
                          //       imageUrl: model.instoreOrderImg.split(";")[0],
                          //     ));
                          // 放大图片
                        },
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: decoration,
                    child: Container(
                      child: model.instoreOrderImg == ""
                          ? Center(
                              child: Text("暂无照片"),
                            )
                          : Container(),
                    ),
                  ),
                ),
              Expanded(
                child: GestureDetector(
                  onTap: callback,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    // color: Colors.red,
                    margin: EdgeInsets.only(left: imgshow ? 8.sp : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  // Icon(
                                  //   Icons.insert_drive_file,
                                  //   color: Colors.black,
                                  //   size: 17,
                                  // ),
                                  Expanded(
                                    child: WMSInfoRow(
                                      title: '入仓单号: ',
                                      content: model?.instoreOrderCode ?? '',
                                      leftInset: 8,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: padding,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: WMSInfoRow(
                                      title: '物流单号: ',
                                      content: model?.mailNo ?? '',
                                      leftInset: 8,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: padding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: WMSInfoRow(
                                  title: '客户代码: ',
                                  content: model?.userCode == null
                                      ? ""
                                      : model?.userCode,
                                  leftInset: 8,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: padding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: WMSInfoRow(
                              title: '签到箱数: ',
                              content: model?.boxTotalFact == null
                                  ? "0"
                                  : model?.boxTotalFact.toString(),
                              leftInset: 8,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: padding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: WMSInfoRow(
                              title: '预约总数: ',
                              content: model?.skusTotal == null
                                  ? '0'
                                  : model?.skusTotal.toString(),
                              leftInset: 8,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: padding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: WMSInfoRow(
                              title: '实收总数: ',
                              content: model?.skusTotalFact == null
                                  ? "0"
                                  : model?.skusTotalFact.toString(),
                              leftInset: 8,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: padding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: WMSInfoRow(
                              title: '已理货数: ',
                              content: model?.skusTotalFact == null
                                  ? "0"
                                  : model?.skusTotalFact.toString(),
                              leftInset: 8,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: padding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: WMSInfoRow(
                              title: '入库要求: ',
                              content: WMSUtil
                                  .orderOperationalRequirementsStringChange(
                                      model?.orderOperationalRequirements
                                          .toString()),
                              leftInset: 8,
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

// 照片预览

class SimpleImageFullScreenPreview extends StatelessWidget {
  final imageUrl;
  const SimpleImageFullScreenPreview({Key key, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          color: Colors.red,
          // child: Image.network(imageUrl),
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}
