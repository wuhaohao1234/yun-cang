import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wms/views/common/common_style_widget.dart';

class MarketDetailInfoWidget extends StatelessWidget {
  final model;
  const MarketDetailInfoWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          children: [
            buildDetailWidget(title: '商品名称', tips: model?.commodityName ?? ''),
            buildDetailWidget(title: '品牌', tips: model?.brandName ?? ''),
            buildDetailWidget(title: '颜色', tips: model?.color ?? ''),
            buildDetailWidget(title: '品类', tips: model?.categoryName ?? ''),
            buildDetailWidget(title: '备注', tips: model?.remark ?? ''),
            // buildDetailWidget(title: '供应商', tips: model?.vendor ?? ''),
            buildDetailWidget(title: '原产国', tips: model?.nation ?? ''),
            // buildDetailWidget(
            //     title: '跨境', tips: model?.bidAcrossBorders ? '是' : '否'),
            // buildDetailWidget(
            //     title: '状态', tips: model?.status == "0" ? '正常' : '瑕疵'),
            buildDetailWidget(title: '货号', tips: model?.articleNumber ?? ''),
            // buildDetailWidget(
            //     title: 'skuId', tips: model?.spuId.toString() ?? ''),
            buildDetailWidget(title: '海关编码', tips: model?.customsCode ?? ''),
            buildDetailWidget(title: '详情', tips: model?.detail ?? ''),
            buildDetailWidget(title: '商品大图', tips: ''),
            ListView.builder(
                shrinkWrap: true,
                physics: new NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Image.network(
                    model?.appPicturePath?.split(';')[index],
                    fit: BoxFit.contain,
                  );
                },
                itemCount: model?.appPicturePath?.split(';')?.length),
          ],
        ));
  }
}
