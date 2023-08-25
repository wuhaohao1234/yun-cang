import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/common/baseWidgets/wv_checklist_widget.dart';
import 'package:wms/common/identify/wv_recipient_info.dart';
import 'package:wms/configs/app_style_config.dart';
import 'package:wms/customer/storage/controllers/cs_ycj_detail_page_controller.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/models/market/market_wares_model.dart';
import 'package:wms/models/select_exception_sku_send_back_model.dart';

/// Create by bigv on 21-7-19
/// Description: 异常单退回
class CsYcdOut extends StatefulWidget {
  // CsYcdOut({this.ids});
  // final List<int> ids;
  @override
  _CsYcdOutState createState() => _CsYcdOutState();
}

class _CsYcdOutState extends State<CsYcdOut> {
  final CSYcjDetailPageController logic = Get.find<CSYcjDetailPageController>();

  // final KcSelectWidgetState state = Get.find<KcSelectWidgetLogic>().state;

  @override
  Widget build(BuildContext context) {
    print(logic.selectListData.length);
    print(logic.skuIds.length);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: WMSText(
          content: '异常件退回',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: GetBuilder<CSYcjDetailPageController>(builder: (_) {
        return Column(
          children: [
            RecipientInfoWidget(
              addressInfo: logic.consigneeData,
              callBack: (AddressModel v) {
                logic.setConsignee(v);
                print('回调 ${v.toJson()}');
              },
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 15.w),
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20.w),
                    child: WMSText(
                      content: '瑕疵件清单',
                      bold: true,
                    ),
                  ),
                  ...List.generate(logic.selectExceptionSkuSendBackData.length,
                      (index) {
                    SelectExceptionSkuSendBack _skuData =
                        logic.selectExceptionSkuSendBackData[index];
                    MarketWaresModel _data = MarketWaresModel.fromJson({
                      "commodityName": _skuData.commodityName,
                      "imgUrl": _skuData.imgUrl,
                      "status": null,
                      "size": _skuData.size,
                      "color": _skuData.color,
                      "barCode": _skuData.barCode,
                      "brandNameCn": _skuData.brandNameCn
                    });
                    return ChecklistWidget(
                      data: _data,
                      type: 'ycj', //异常件
                    );
                  }).toList(),
                ],
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Get.to(()=>OutboundOrderPage());
            //   },
            //   child: Text('出库单'),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: logic.consigneeData == null
                      ? null
                      : logic.exceptionSkuSendBackAndCommit,
                  child: Text('确定'),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        );
      }),
    );
  }
}
