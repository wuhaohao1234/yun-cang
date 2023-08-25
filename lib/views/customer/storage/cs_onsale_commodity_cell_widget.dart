import 'package:fluwx/fluwx.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

import 'package:wms/common/baseWidgets/wms_size_tag_widget.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:fluwx/fluwx.dart' as Fluwx;
import 'package:wms/views/customer/controllers/on_sale_controller.dart';
import 'package:wms/views/customer/storage/cs_kucun_mamage/cs_kucun_manage.dart';

class CSOnSaleCommodityWidget extends StatelessWidget {
  final model;
  final callback;
  final int type;
  final int index;

  const CSOnSaleCommodityWidget({Key key, this.model, this.callback, this.type, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: type != 3
          ? () {
              Get.to(new CSKuCunManage(
                model: model,
                type: type,
                callback: () {
                  Get.find<OnSaleController>().requestData(type: type, index: index);
                },
              ));
            }
          : null,
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        // color: Colors.grey[200],
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.grey[200],
            ),
          ),
        ),
        // height: 140.h,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => PhotoViewPage(
                          images: model.picturePath.split(';'), //传入图片list
                          index: 0, //传入当前点击的图片的index
                        ));
                  },
                  child: Container(
                    width: 80.w,
                    height: 60.h,
                    child: Image.network(
                      model?.picturePath ?? '-',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WMSText(
                        content: model?.commodityName ?? '-',
                        bold: true,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: model?.brandNameCn != null,
                            child: Expanded(
                              child: WMSText(
                                content: '品牌：${model?.brandNameCn}',
                                color: Colors.grey,
                                size: 13,
                              ),
                            ),
                          ),
                          WMSText(
                            content: '颜色：${model?.color ?? '-'}',
                            color: Colors.grey,
                            size: 13,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Wrap(
                        children: List<WMSSizeTagWidget>.generate(model?.size?.split(',')?.length ?? 1, (int index) {
                          print("model${model.toJson()}");
                          var sizeItem = model?.size != null ? model?.size?.split(',')[index] : '无尺码';
                          var specificationItem =
                              model?.specification != null ? "/" + model?.specification?.split(',')[index] : '';
                          return WMSSizeTagWidget(title: '${sizeItem.toString()}${specificationItem}', fontSize: 11);
                        }),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      WMSText(
                        content: '${model?.depotName}',
                        color: Colors.grey,
                        size: 13,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WMSText(
                            content: '在售库存：${model?.saleCount.toString()}',
                            bold: true,
                            size: 13,
                          ),
                          Visibility(
                            visible: type == 3 && model.resalePrice != null,
                            child: WMSText(
                              content: '利润： ${model?.resalePrice}',
                              bold: true,
                              size: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WMSText(
                  content: '上架时间：${model?.updateTime ?? ''}',
                  color: Colors.grey,
                  size: 13,
                ),
                Spacer(
                  flex: 8,
                ),
                Visibility(
                    visible: type != 2,
                    child: buildButtonWidget(
                      width: 48.w,
                      bgColor: AppConfig.themeColor,
                      contentColor: Colors.white,
                      buttonContent: '分享',
                      handelClick: () async {
                        var res = await SPUtils.getShopCode();

                        final apiReg = await Fluwx.registerWxApi(
                          appId: AppConfig.wechatAppId,
                          universalLink: AppConfig.universalLink == "" ? null : AppConfig.universalLink,
                        );

                        print("apiReg 注册结果: $apiReg");
                        var wxModel = Fluwx.WeChatShareMiniProgramModel(
                            thumbnail: WeChatImage.network(model.picturePath.split(';')[0]),
                            userName: AppConfig.wechatOriginalId,
                            webPageUrl: "https://unipay.topyuncang.com",
                            title: model.commodityName,
                            miniProgramType: WXMiniProgramType.RELEASE,
                            path:
                                "pages/commodity/commodityDetail/commodityDetail?currentMain=0&shopCode=$res&spuId=${model.spuId}");
                        var result = await Fluwx.isWeChatInstalled;

                        if (result != true) {
                          ToastUtil.showMessage(message: "请安装微信后重试!");
                        } else {
                          Fluwx.shareToWeChat(wxModel);
                        }
                        print("分享");
                        // final List<ShareOpt> list = [
                        //   ShareOpt(title: "test",img:"https://s0.2mdn.net/simgad/17328341983555754854",shareType: '',doAction: (shareType,shareInfo) async {
                        //     if(shareInfo ==null) return;
                        //     var model =
                        //   })
                        // ];
                      },
                      radius: 2.0,
                    )),
                Spacer(
                  flex: 1,
                ),
                Visibility(
                    visible: type == 3,
                    child: buildButtonWidget(
                      width: 48.w,
                      bgColor: AppConfig.themeColor,
                      contentColor: Colors.white,
                      buttonContent: '下架',
                      handelClick: callback,
                      radius: 2.0,
                    )),
                Visibility(
                    visible: type != 3,
                    child: buildButtonWidget(
                      width: 68.w,
                      bgColor: AppConfig.themeColor,
                      contentColor: Colors.white,
                      buttonContent: '库存管理',
                      handelClick: () {
                        Get.to(new CSKuCunManage(
                          model: model,
                          type: type,
                          callback: () {
                            Get.find<OnSaleController>().requestData(type: type, index: index);
                          },
                        ));
                      },
                      radius: 2.0,
                    )),
                // ElevatedButton(
                //   style: TextButton.styleFrom(
                //     minimumSize: Size(60.w, 24.w),
                //     // shape: RoundedRectangleBorder(
                //     //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
                //     // ),
                //   ),
                //   onPressed: callback,
                //   child: Text(
                //     '下架',
                //     style: TextStyle(fontSize: 12.sp),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
