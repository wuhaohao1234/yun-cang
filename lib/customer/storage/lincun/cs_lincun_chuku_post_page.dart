//临存手动出库页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'cs_lincun_tab_page.dart';
import 'package:wms/views/customer/storage/storage_lincun_cell_widget.dart';

// import '../en_logistics_page.dart';
import 'package:wms/common/identify/wv_recipient_info.dart';

class CSLinCunChuKuPostPage extends StatefulWidget {
  final num orderId;
  final model;

  const CSLinCunChuKuPostPage({
    Key key,
    @required this.orderId,
    this.model,
  }) : super(key: key);

  @override
  _CSLinCunChuKuPostPageState createState() => _CSLinCunChuKuPostPageState();
}

class _CSLinCunChuKuPostPageState extends State<CSLinCunChuKuPostPage> {
  var consigneeData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: WMSText(
            content: '临存出库详情',
            size: AppStyleConfig.navTitleSize,
          ),
          leading: BackButton(
            onPressed: () {
              Get.off(() => CSLinCunTabPage(defaultIndex: 0));
            },
          ),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: ScrollConfiguration(
              behavior: JKOverScrollBehavior(),
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          StorageLinCunCellWidget(
                            model: widget.model,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WMSText(content: '配送方式'),
                              WMSText(content: '快递'),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          RecipientInfoWidget(
                            addressInfo: consigneeData,
                            callBack: (v) {
                              setState(() {
                                consigneeData = v;
                              });
                              consigneeData = v;
                              print('回调 ${v.toJson()}');
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size(90.w, 34.w),
                          fixedSize: Size(343.w, 34.w),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          // ),
                        ),
                        onPressed: consigneeData == null
                            ? null
                            : () async {
                                FocusScope.of(context).requestFocus(FocusNode());

                                var data = await HttpServices().csAddOutStore(
                                    //快递
                                    distributionId: 5,
                                    prepareOrderId: widget.orderId,
                                    consigneeName: consigneeData.userName,
                                    consigneePhone: consigneeData.userPhone,
                                    consigneeDistrict: consigneeData.area,
                                    consigneeProvince: consigneeData.province,
                                    consigneeCity: consigneeData.city,
                                    consigneeAddress: consigneeData.userAddress);
                                if (data.runtimeType == ErrorEntity) {
                                  EasyLoadingUtil.showMessage(message: data.message);
                                  return false;
                                }
                                if (data != null) {
                                  EasyLoadingUtil.showMessage(message: "已成功出库");
                                  Future.delayed(Duration(milliseconds: 200), () {
                                    Get.back();
                                  });

                                  return true;
                                } else {
                                  return false;
                                }
                              },
                        child: Text(
                          '确定出库',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
