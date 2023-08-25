// 上架-绑定库位
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/entrepot/controllers/ruku/en_rkd_detail_page_controller.dart';
// import 'package:wms/views/entrenpot/en_table_cell.dart';
import 'package:wms/entrepot/controllers/old/en_sjd_page_controller.dart.old';
import 'package:wms/views/entrenpot/en_rkd_top_widget.dart';
import 'package:wms/entrepot/pages/ruku/lihuo/en_spu.dart';
import '../en_RuKuTabs.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';

class ENShangJiaDetailsPage extends StatefulWidget {
  final num instoreOrderId;
  final num prepareOrderId;
  final String resDepotPosition;
  final String userCode;

  ENShangJiaDetailsPage(
      {Key key,
      @required this.instoreOrderId,
      this.prepareOrderId,
      this.resDepotPosition,
      this.userCode})
      : super(key: key);

  @override
  State<ENShangJiaDetailsPage> createState() => _ENShangJiaDetailsPageState();
}

class _ENShangJiaDetailsPageState extends State<ENShangJiaDetailsPage> {
  ENRkdDetailPageController detailController;
  TextEditingController customerCode;
  TextEditingController batchKuCunCode = TextEditingController(text: '');
  List<TextEditingController> depotPositions = [];
  final hs = HttpServices();
  void initState() {
    super.initState();
    print("_ENShangJiaDetailsPageState init");
    detailController = Get.put(
      ENRkdDetailPageController(
        widget.instoreOrderId,
        widget.prepareOrderId,
        afterSuccess: () {
          setState(() {
            // customerCode.text = detailController.dataInfo.userCode;
            print(detailController.dataInfo.userCode);
            if (detailController.dataInfo.userCode != null) {
              customerCode = TextEditingController(
                  text: widget.userCode ??
                      detailController.dataInfo.userCode ??
                      WMSUser.getInstance().userInfoModel.userCode);
            }
            for (var index = 0;
                index < detailController.commodityList.length;
                index++) {
              print("创建");
              depotPositions.add(TextEditingController(text: ""));
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> constructShangpingList() {
      final radius = 5.h;
      final iconSize = 20.w;
      List<Widget> list = [];
      for (var index = 0; index < depotPositions.length; index++) {
        list.add(
          Column(
            children: [
              // 这里的单位是单个商品
              // 单个商品的库位绑定做到这里,后面可能要调整到下面
              Container(
                // color: Colors.red,
                // height: 50.h,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: depotPositions[index],
                        maxLines: 1,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: radius),
                          hintText: '为商品绑定库位,可使用,分割多个库位',
                          hintStyle: TextStyle(fontSize: 12.sp),
                        ),
                        onSubmitted: (value) async {
                          print("试图绑定库位到$value");
                        },
                      ),
                    ),
                    IconButton(
                      constraints: BoxConstraints(maxHeight: 30.w),
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Get.to(() => ENScanStandardPage(
                              title: "扫库位码",
                              // leading: backLeadingIcon,
                            )).then((value) {
                          setState(() {
                            depotPositions[index].text =
                                (depotPositions[index].text + ',' + value)
                                    .substring(1);
                          });
                        });
                      },
                      icon: SvgPicture.asset(
                        'assets/svgs/scan.svg',
                        width: iconSize,
                      ),
                    )
                  ],
                ),
              ),
              ENRkdDetailTopWidget(
                picturePath: detailController.commodityList[index]
                        ['picturePath'] ??
                    null,
                name: detailController.commodityList[index]['commodityName'],
                brandName: detailController.commodityList[index]['brandName'],
                stockCode: detailController.commodityList[index]['stockCode'],
              ),
              // 这里是SPU的列表
              buildSpuList(
                spuList: detailController.commodityList[index]
                    ['sysPrepareOrderSpuList'],
                editable: false,
                afterEdit: () {
                  // 在更新以后重新获取数据
                  detailController.requestData();
                },
                actualNumberEditable:
                    detailController.dataInfo.orderOperationalRequirements ==
                        1, // 1为仅理货点数,仅理货点数是可以修改的.
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }
      return list;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '上架',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            Get.delete<ENSjdPageController>();
            Get.offAll(() => ENRkdShPage(defaultIndex: 2));
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ScrollConfiguration(
            behavior: JKOverScrollBehavior(),
            // onRefresh: detailController.onRefresh,

            child: Column(
              children: [
                // Text("${detailController.prepareOrderId}"),
                Expanded(
                  child: ListView(
                    children: [
                      WMSTextField(
                        title: '客户代码',
                        hintText: '必填',
                        keyboardType: TextInputType.text,
                        controller: customerCode,
                      ),
                      WMSTextField(
                        title: '推荐库位',
                        redOnly: true,
                        keyboardType: TextInputType.text,
                        hintText: detailController.dataInfo.depotPosition ??
                            widget.resDepotPosition,
                      ),
                      WMSTextField(
                          title: '批量绑定库存代码',
                          hintText: '选填，可使用,分割多个库位',
                          keyboardType: TextInputType.text,
                          controller: batchKuCunCode,
                          endWidget: IconButton(
                            constraints: BoxConstraints(maxHeight: 30.w),
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Get.to(() => ENScanStandardPage(
                                    title: "扫库位码",
                                    // leading: backLeadingIcon,
                                  )).then((value) {
                                setState(() {
                                  batchKuCunCode.text =
                                      (batchKuCunCode.text + ',' + value)
                                          .substring(1);
                                });
                              });
                            },
                            icon: SvgPicture.asset(
                              'assets/svgs/scan.svg',
                              width: 20.w,
                            ),
                          )),
                      SizedBox(height: 20.h),
                      // 商品列表
                      ...constructShangpingList(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: buildButtonWidget(
                    width: 343.w,
                    height: 34.h,
                    radius: 2.0,
                    contentColor: Colors.white,
                    bgColor: AppConfig.themeColor,
                    buttonContent: '确定绑定库位',
                    handelClick: () async {
                      var available;

                      if (customerCode.text.length == 0) {
                        EasyLoadingUtil.showMessage(message: "请填写客户代码");
                        return;
                      }
                      EasyLoadingUtil.showLoading(statusText: "检查库位可用性...");
                      if (batchKuCunCode.text.length == 0) {
                        for (var index = 0;
                            index < detailController.commodityList.length;
                            index++) {
                          if (depotPositions[index].text.length == 0) {
                            EasyLoadingUtil.hidden();
                            EasyLoadingUtil.showMessage(
                                message: "批量绑定库位和具体商品库位不可全部为空");
                            return;
                          } else {
                            available = await HttpServices().locationIsExist(
                                customerCode: customerCode.text,
                                depotPosition: depotPositions[index].text);
                            print(available['result']);
                            if (available['result'] != true) {
                              EasyLoadingUtil.hidden();
                              EasyLoadingUtil.showMessage(
                                  message:
                                      "库位${depotPositions[index].text}不可用");
                              return;
                            }
                          }
                        }
                      } else {
                        available = await hs.locationIsExist(
                            customerCode: customerCode.text,
                            depotPosition: batchKuCunCode.text);
                        print(available['result']);
                        if (!available['result']) {
                          EasyLoadingUtil.hidden();
                          EasyLoadingUtil.showMessage(
                              message:
                                  "库位${batchKuCunCode.text}不可用,${available['info']==false?available['msg']:available['info']}");
                          return;
                        }
                        EasyLoadingUtil.hidden();
                        EasyLoadingUtil.showLoading(statusText: "库位可用, 上架中...");
                      }
                      print(customerCode.text);
                      print(batchKuCunCode.text);
                      List<Map<String, dynamic>> depotIds = [];
                      for (var index = 0;
                          index < detailController.commodityList.length;
                          index++) {
                        depotIds.add({
                          "depotPosition": depotPositions[index].text,
                          "stockCode": detailController.commodityList[index]
                              ["stockCode"],
                          "spuId": detailController.commodityList[index]
                              ["spuId"],
                        });
                        print(depotPositions[index].text);
                      }
                      // tallyShelf
                      bool succeed = await hs.tallyShelf(
                          prepareOrderId: widget.prepareOrderId,
                          customerCode: customerCode.text,
                          batchDepotId: batchKuCunCode.text,
                          depotIds: depotIds);
                      print("上架结果为 $succeed");
                      if (succeed == true) {
                        EasyLoadingUtil.showMessage(message: "上架成功");
                        Get.delete<ENSjdPageController>();
                        Get.back();
                      } else {
                        EasyLoadingUtil.showMessage(message: "上架失败");
                        return;
                        // Get.back();
                      }
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
