import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/models/forSaleDetialList_model.dart';
import 'package:wms/models/market/market_all_detail_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:wms/utils/toast_util.dart';

class MarketSelectWidgetPage extends StatefulWidget {
  final Function callBack;
  final List<SizeModel> data;
  final Map<int, Map<int, List<ForSaleDetialListModel>>> selectDataList;
  final Map<int, int> dataLength;

  const MarketSelectWidgetPage(
      {Key key, this.data, this.selectDataList, this.dataLength, this.callBack})
      : super(key: key);

  @override
  _MarketSelectWidgetPageState createState() => _MarketSelectWidgetPageState();
}

class _MarketSelectWidgetPageState extends State<MarketSelectWidgetPage> {
  // 尺码id
  // int skuId;

  List<SizeModel> _data;
  Map<int, Map<int, List<ForSaleDetialListModel>>> _selectDataList;
  Map<int, int> _dataLength;
  int length = 0;

  /// 获取数据长度
  int getLength() {
    _selectDataList.forEach((key, value) {
      length += value.length;
    });
    return length;
  }

  /// 获取 skuId、ids
  Map<String, List<int>> getParams() {
    Map<String, List<int>> params = {"skuId": [], "id": []};
    _selectDataList.forEach((key, value) {
      if (value.length == _dataLength[key]) {
        params['skuId'].add(key);
      } else {
        value.forEach((key, value) {
          params['id'].add(key);
        });
      }
    });

    // 删除空数据
    if (params['skuId'].isEmpty) {
      params.remove('skuId');
    }
    if (params['id'].isEmpty) {
      params.remove('id');
    }
    print('params $params');

    return params;
  }

  ///（单品在售我的）下架商品提交
  void commitForSaleSku() {
    print('commitForSaleSku');
    EasyLoadingUtil.showLoading();
    HttpServices.commitForSaleSku(
      params: getParams(),
      success: (data, total) {
        Navigator.pop(context);
        widget.callBack();
        EasyLoadingUtil.hidden();
      },
      error: (error) {
        EasyLoadingUtil.hidden();
        ToastUtil.showMessage(message: error.message);
      },
    );
  }

  @override
  void initState() {
    _data = widget.data;
    _selectDataList = widget.selectDataList;
    _dataLength = widget.dataLength;
    length = getLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 49.0,
                alignment: Alignment.center,
                child: Text('选择下架商品'),
              ),
              Positioned(
                child: CloseButton(),
                right: 0,
                top: 0,
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('选择尺码'),
                SizedBox(height: 10.w),
                Column(
                  children: [
                    Row(
                      children: List.generate(
                        _data?.length ?? 0,
                        (index) {
                          SizeModel item = _data[index];
                          return Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: Stack(
                              overflow: Overflow.visible,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50.w,
                                  height: 50.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xfff2f2f2),
                                    // border: item.skuId == skuId ? Border.all(width: 2.0, color: Colors.black) : null,
                                  ),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      print('sdfsdfsd');
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${item.size}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          '${item.qty}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Visibility(
                                    visible:
                                        (_selectDataList[item.skuId]?.length ??
                                                0) >
                                            0,
                                    child: Container(
                                      width: 20.w,
                                      height: 20.w,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${_selectDataList[item.skuId]?.length ?? 0}',
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color(0xff5cc9ca),
                                          borderRadius:
                                              BorderRadius.circular(15.w)),
                                    ),
                                  ),
                                  top: -10.w,
                                  right: -10.w,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('下架总数'),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Text(
                    '$length',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                /*Container(
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {},
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            color: Color(0xfff2f2f2),
                            child: Icon(Icons.remove, color: Colors.black54),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 40.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            alignment: Alignment.center,
                            color: Color(0xfff2f2f2),
                            child: Text('1'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {},
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            color: Color(0xfff2f2f2),
                            child: Icon(Icons.add, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                )*/
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: length == 0 ? null : commitForSaleSku,
                child: Text('提交'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
