//出库页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/models/storage/cs_dck_model.dart';
import 'package:wms/common/identify/wv_recipient_info.dart';
import 'package:wms/views/commodity_ybrk_choose_size_cell.dart';
import 'package:wms/views/commodity_kucun_chuku_cell_widget.dart';
import 'cs_kucun_chuku_succ_page.dart';

class CSKuCunChuKuPostPage extends StatefulWidget {
  final num orderId;
  final model;
  final depotId;
  final String status;

  const CSKuCunChuKuPostPage(
      {Key key, this.orderId, this.model, this.depotId, this.status = "0"})
      : super(key: key);

  @override
  _CSKuCunChuKuPostPageState createState() => _CSKuCunChuKuPostPageState();
}

class _CSKuCunChuKuPostPageState extends State<CSKuCunChuKuPostPage> {
  var consigneeData;
  var dataModel = CsChuKuModel();
  var addressId;

  void initState() {
    super.initState();
    print(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: WMSText(
            content: '出库确认',
            size: AppStyleConfig.navTitleSize,
          ),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: ScrollConfiguration(
              behavior: JKOverScrollBehavior(),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        RecipientInfoWidget(
                          addressInfo: consigneeData,
                          callBack: (v) {
                            consigneeData = v;
                            print('回调 ${v.toJson()}');
                            setState(() {
                              addressId = v.id;
                              print(addressId);
                            });
                          },
                        ),
                        buildRowOrderInfo(
                          title: '配送方式',
                          content: '快递',
                          horizontalPadding: 0.0,
                        ),
                        SectionTitleWidget(title: '出仓物品清单'),
                        if (widget.model != null)
                          Column(
                            children: [
                              Container(
                                color: Colors.white,
                                child: buildListCommodity(widget.model),
                                // child: Text("good")
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
                    child: WMSButton(
                        title: '确定出库',
                        fontSize: 16,
                        bgColor: consigneeData != null
                            ? AppConfig.themeColor
                            : Colors.grey,
                        callback: () async {
                          if (consigneeData == null) {
                            EasyLoadingUtil.showMessage(message: "请添加收件人信息");
                          }
                          if (consigneeData != null) {
                            print(widget.model);
                            EasyLoadingUtil.showMessage(
                                message: "提交时将自动清除数量为0的商品");

                            var skuOrderList = [];
                            // 设置提交的出库数据
                            for (var i = 0; i < widget.model.length; i++) {
                              print(widget.model[0]);
                              for (var j = 0;
                                  j < widget.model[i].wmsSkuList.length;
                                  j++) {
                                if (widget.model[i].wmsSkuList[j]['count'] !=
                                    0) {
                                  skuOrderList
                                      .add(widget.model[i].wmsSkuList[j]);
                                } else {
                                  EasyLoadingUtil.showMessage(
                                      message: '已清除数量为0的出库商品');
                                }
                              }
                            }

                            print(skuOrderList);

                            var res = await HttpServices().csPostOutStore(
                              //快递
                              distributionId: 5,
                              logisticsName: '快递',
                              depotId: widget.depotId,
                              skuOrderList: skuOrderList,
                              addressId: addressId,
                            );
                            print(res);
                            if (res['result'] == false) {
                              EasyLoadingUtil.showMessage(message: res['data']);
                            } else {
                              if (res != null) {
                                print(res);
                                EasyLoadingUtil.showMessage(
                                    message: "该商品已加入出库单");
                                Get.to(() => CSkuCunChuKuSuccessPage());

                                return true;
                              } else {
                                return false;
                              }
                            }
                          }
                        }),
                  ),
                ],
              ),
            )));
  }

  Widget buildListCommodity(list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              CommodityKuCunChuKuCellWidget(
                  model: widget.model[index], status: widget.status),
              if (list[index].wmsSkuList != null &&
                  list[index].wmsSkuList.length != 0)
                Column(
                  children: [
                    Container(
                        child: buildCommoditySizeList(
                            context, list[index].wmsSkuList, true)),
                  ],
                ),
            ],
          ),
        );
      },
      itemCount: list.length ?? 0,
    );
  }

  //设置正常件出库尺寸页面
  Widget buildCommoditySizeList(
      BuildContext context, skuSizeList, itemCheckValue) {
    return skuSizeList != null
        ? Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: new NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var maxCount = skuSizeList[index]['maxCount'];
                return CommodityChooseSizeWidget(
                  initNumber: skuSizeList[index]['count'],
                  size: skuSizeList[index]['size'],
                  hintText: '库存${maxCount.toString()}',
                  compareStatus: true,
                  compareNumber: maxCount,
                  onChangeCallback: (value) {
                    setState(() {
                      print(value);
                      skuSizeList[index]['count'] = value;
                      print(skuSizeList);
                    });
                  },
                );
              },
              itemCount: skuSizeList.length ?? 0,
            ),
          )
        : Center(child: Text('无尺码数据'));
  }
}
