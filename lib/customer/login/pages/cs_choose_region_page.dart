import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/configs/app_style_config.dart';

class CSChooseRegionPage extends StatefulWidget {
  final String areaCode;

  const CSChooseRegionPage({Key key, this.areaCode}) : super(key: key);
  @override
  _CSChooseRegionPageState createState() => _CSChooseRegionPageState();
}

class _CSChooseRegionPageState extends State<CSChooseRegionPage> {
  List<Map<String, String>> _regionList = [
    {'name': '中国大陆', 'code': '86'},
    {'name': '中国香港', 'code': '852'},
    {'name': '中国澳门', 'code': '853'},
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '选择国家或地区',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                Get.back(result: _regionList[index]['code']);
              },
                child: buildCellWidget(index: index));
          },
          itemCount: _regionList.length,
        ),
      ),
    );
  }

  Widget buildCellWidget({int index}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.grey[100],
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _regionList[index]['name'] ?? '',
            style: TextStyle(fontSize: 13.sp, fontWeight: widget.areaCode == _regionList[index]['code']  ? FontWeight.bold : null),
          ),
          Text(
            '+${_regionList[index]['code'] ?? ''}',
            style: TextStyle(fontSize: 13.sp, fontWeight: widget.areaCode == _regionList[index]['code'] ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}
