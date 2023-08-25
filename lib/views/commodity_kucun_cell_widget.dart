import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
//库存页面简单信息，图片+名称+货号+颜色
import 'package:wms/common/pages/photo_view_page.dart';

typedef void CellChukuCallback(model);
typedef void CellSellCallback(model);

class CommodityKuCunCellWidget extends StatelessWidget {
  final model;
  final buttonVisibility;
  final CellChukuCallback onCellChuku;
  final CellSellCallback onCellSell;
  final bool userCountShow;

  const CommodityKuCunCellWidget({
    Key key,
    this.model,
    this.buttonVisibility = false,
    this.onCellChuku,
    this.onCellSell,
    this.userCountShow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80.h,
      margin: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey[200]),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => PhotoViewPage(
                    images: model.picturePath.split(';'), //传入图片list
                    index: 0, //传入当前点击的图片的index
                  ));
            },
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    model?.picturePath ?? '',
                  ),
                  fit: BoxFit.contain,
                ),
                border: Border.all(
                  width: 1.w,
                  color: Colors.grey[200],
                ),
              ),
              child: model?.picturePath == null ? Text("无图片") : Container(),
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: WMSText(
                        content: '商品名称：${model?.commodityName ?? '暂无'}',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: WMSText(
                        content: '货号:${model?.stockCode ?? '暂无'}',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: WMSText(
                                  content: '颜色:${model?.color ?? '暂无'}',
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Visibility(
                            visible: userCountShow,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                WMSText(
                                  content:
                                      '可用库存:${(model.factCount - model.lockCount ?? 0).toString() ?? '暂无'}',
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Visibility(
                            visible: userCountShow,
                            child: Row(
                              children: [
                                WMSText(
                                  content: '可售库存:',
                                  color: Colors.grey,
                                ),
                                if (model?.bazaarInStoreCount != 0) ...[
                                  Image(
                                      image: model?.bazaarOnSaleCount > 0
                                          ? AssetImage('assets/images/集市2.png')
                                          : AssetImage('assets/images/集市.png')),
                                  SizedBox(width: 2.w),
                                  WMSText(
                                    content:
                                        '${model?.bazaarInStoreCount ?? 0}',
                                    color: Colors.grey,
                                  ),
                                ],
                                SizedBox(width: 2.w),
                                if (model?.appInStoreCount != 0) ...[
                                  SvgPicture.asset(
                                    'assets/svgs/小程序.svg',
                                    width: 16.w,
                                    color: model.appOnSaleCount > 0
                                        ? AppStyleConfig.btnColor
                                        : null,
                                  ),
                                  SizedBox(width: 2.w),
                                  WMSText(
                                    content: '${model?.appInStoreCount ?? 0}',
                                    color: Colors.grey,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: buttonVisibility,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildButtonWidget(
                              width: 48.w,
                              height: 20.h,
                              buttonContent: '出库',
                              handelClick: () {
                                onCellChuku(model);
                              },
                              radius: 2.0,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            buildButtonWidget(
                              width: 48.w,
                              height: 20.h,
                              bgColor: AppConfig.themeColor,
                              contentColor: Colors.white,
                              buttonContent: '出售',
                              handelClick: () {
                                onCellSell(model);
                              },
                              radius: 2.0,
                            ),
                          ]),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
