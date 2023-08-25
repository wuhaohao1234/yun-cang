import 'package:flutter/material.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:get/get.dart';
import 'package:wms/utils/wms_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef void OnModelChangeCallback(model, indexSelected, selected);

class DefectDataTable extends StatefulWidget {
  //设置model为初始的瑕疵商品明细列表
  final model;
  final OnModelChangeCallback onModelChangeCallback;
  final selectedMultiModel;

  DefectDataTable({Key key, this.model, this.onModelChangeCallback, this.selectedMultiModel = true}) : super(key: key);

  @override
  DefectDataTableState createState() => DefectDataTableState();
}

class DefectDataTableState extends State<DefectDataTable> {
  List selectedList;

  @override
  void initState() {
    super.initState();
    selectedList = [];

    widget.model.forEach((e) {
      selectedList.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.w),
        color: Theme.of(context).colorScheme.onPrimary,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
              child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(primary: Colors.black, onPrimary: Colors.white),
                  ),
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Color(0xfff2f2f2)),
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
                    headingTextStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                    columnSpacing: 20.0,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('尺码/规格'),
                      ),

                      DataColumn(
                        label: Text('瑕疵分类'),
                      ),
                      DataColumn(
                        label: Text('图片'),
                      ),
                      // DataColumn(
                      //   label: Text('在售'),
                      // ),
                    ],
                    rows: List<DataRow>.generate(
                      widget.model.length,
                      (index) {
                        var _data = widget.model[index];
                        widget.model.forEach((e) {
                          selectedList.add(false);
                        });
                        // selectedList = List.filled(
                        //     widget.model.length, {'selected': false});
                        return DataRow(
                          selected: selectedList[index],
                          onSelectChanged: (selected) {
                            //有问题
                            setState(() {
                              // print('第$index个的状态修改为了$selected');

                              if (!widget.selectedMultiModel) {
                                for (var i = 0; i < selectedList.length; i++) {
                                  if (i == index) {
                                    selectedList[index] = selected;
                                  } else {
                                    selectedList[i] = false;
                                  }
                                }
                              }
                              selectedList[index] = selected;
                              widget.onModelChangeCallback(widget.model, index, selected);
                            });
                          },
                          cells: <DataCell>[
                            DataCell(Text(
                                "${_data['size']}${_data['specification'] != null ? '/' + _data['specification'] : ''}")),

                            // DataCell(Text(_data['color'] ?? '')),
                            DataCell(Text(WMSUtil.getExceptionTypeString(_data['defectDegree'].toString()))),
                            DataCell(
                              Container(
                                child: _data['picturePath'] == null || _data['picturePath'] == ''
                                    ? Text("无图片")
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              print(_data);
                                              Get.to(() => PhotoViewPage(
                                                    images: _data['picturePath'].split(';'),
                                                    //传入图片list
                                                    index: 0, //传入当前点击的图片的index
                                                  ));
                                            },
                                            child: Image.network(
                                              _data['picturePath'].split(";")[0],
                                              height: 48.0,
                                              width: 48.0,
                                            ),

                                            // behavior: HitTestBehavior.translucent,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            // DataCell(Text('在售')),
                          ],
                        );
                      },
                    ),
                  )),
            )));
  }
}
