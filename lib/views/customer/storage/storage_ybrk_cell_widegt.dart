/*
* 客户端-仓储管理模块-预约入库列表页面Cell
* */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/models/storage/perpare_order_model.dart';
import 'package:wms/utils/wms_util.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wms/views/common/common_style_widget.dart';

class StorageYbrkCellWidegt extends StatelessWidget {
  final PerpareOrderModel model;
  final bool prepareType; //如果false，其他；如果true，则是待签收；
  final tapCallBack;
  final cancelCallBack;
  StorageYbrkCellWidegt(
      {Key key,
      this.model,
      this.prepareType = false,
      this.tapCallBack,
      this.cancelCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.grey[100],
      child: Column(
        children: [
          buildRowWidget(
              iconData: Icon(Icons.insert_drive_file, size: 16.w),
              title: '预约单号：',
              content: model?.orderIdName ?? ''),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRowWidget(
                  iconData: Icon(Icons.car_repair, size: 16.w),
                  title: '物流单号：',
                  content: model?.mailNo ?? ''),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => ENLogisticsPage(dataCode: model?.mailNo));
              //   },
              //   child: stateWidget(
              //     title: '查看物流',
              //     bgColor: Colors.deepOrangeAccent,
              //     contentColor: Colors.white,
              //   ),
              // )
            ],
          ),
          buildRowWidget(
              iconData: Icon(Icons.calendar_today_rounded, size: 16.w),
              title: '创建时间：',
              content: model?.createTime ?? ''),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRowWidget(
                  iconData: SvgPicture.asset(
                    'assets/svgs/物品数量.svg',
                    width: 16.w,
                  ),
                  title: '物品数量：',
                  content: model?.skusTotal?.toString() ?? ''),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRowWidget(
                  iconData: SvgPicture.asset(
                    'assets/svgs/仓库.svg',
                    width: 16.w,
                  ),
                  title: '仓库：',
                  content: model?.depotName?.toString() ?? ''),
              //增加发货按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //如果3 显示 已取消，其他都有取消功能；
                  Visibility(
                      visible: prepareType,
                      child: model?.status == '3'
                          ? stateWidget(title: '已取消', bgColor: Colors.grey)
                          : GestureDetector(
                              onTap: cancelCallBack,
                              child: stateWidget(
                                  title: '取消', bgColor: Colors.black),
                            )),
                  SizedBox(width: 12.w),
                  //如果 4，设置发货功能;
                  Visibility(
                    visible: model?.status == '4',
                    child: GestureDetector(
                      onTap: tapCallBack,
                      child: stateWidget(
                          title: '发货', bgColor: Colors.deepOrangeAccent),
                    ),
                  ),
                  Visibility(
                    visible: model?.mailNo != null && model?.status != '3',
                    child: GestureDetector(
                      // onTap: tapCallBack,
                      child: stateWidget(
                          title: WMSUtil.statusStringChange(model?.status),
                          bgColor: model?.status != null && model?.status != "0"
                              ? Colors.black
                              : Colors.deepOrangeAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
          buildRowWidget(
            iconData: SvgPicture.asset(
              'assets/svgs/入库要求.svg',
              width: 18.w,
            ),
            title: '入库要求：',
            content: WMSUtil.orderOperationalRequirementsStringChange(
                model?.orderOperationalRequirements.toString()),
          )
        ],
      ),
    );
  }
}
