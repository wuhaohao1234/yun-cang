import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wms/common/pages/photo_view_page.dart';
import 'package:wms/models/market/market_wares_model.dart';
import 'package:wms/views/common/tag_widget.dart';

class MarketCellWidget extends StatefulWidget {
  final MarketWaresModel model;
  final int type; // 1:库存
  final bool selected; // 多选框状态
  final Function(MarketWaresModel) selectCallBack; // 手动选择回调
  final Function(dynamic) onChangedAllCheckbox;

  const MarketCellWidget(
      {Key key,
      this.model,
      this.type,
      this.selected = false,
      this.selectCallBack,
      this.onChangedAllCheckbox})
      : super(key: key);

  @override
  _MarketCellWidgetState createState() => _MarketCellWidgetState();
}

class _MarketCellWidgetState extends State<MarketCellWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      color: Colors.white,
      margin: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Visibility(
            visible: widget.type == 1,
            child: Stack(
              children: [
                Checkbox(
                  value: widget.selected,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  tristate: true,
                  onChanged: widget.onChangedAllCheckbox,
                ),
                Opacity(
                  // 为了渲染顶部内容 不可以删掉 与Checkbox 同时存在
                  opacity: 0,
                  child: Text('${widget.selected}'),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Get.to(() => PhotoViewPage(
                      images: widget.model.picturePath.split(';'), //传入图片list
                      index: 0, //传入当前点击的图片的index
                    ));
              },
              child: Image.network(
                '${widget.model.picturePath}',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.model.commodityName ?? ''}',
                  maxLines: widget.type == 1 ? 1 : 3,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Visibility(
                  visible: widget.type == 1,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black38, fontSize: 12.sp),
                      children: [
                        TextSpan(
                          text: '货号:',
                        ),
                        TextSpan(
                          text: widget.model?.stockCode.toString(),
                        ),
                        WidgetSpan(child: SizedBox(width: 7.w)),
                        TextSpan(
                          text: '颜色:',
                        ),
                        TextSpan(
                          text: widget.model?.color,
                        )
                      ],
                    ),
                  ),
                ),
                buildSizeList(),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  '在售库存：${widget.model.qty ?? 0}',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.type == 1,
            child: Expanded(
              flex: 2,
              child: Align(
                child: OutlinedButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: TextStyle(fontSize: 11.sp),
                    minimumSize: Size(30.w, 24.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 3.w, horizontal: 10.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                  onPressed: () => widget.selectCallBack(widget.model),
                  child: Text('手动选择'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSizeList() {
    List<Widget> widgets = [];
    widget.model.sizeList?.forEach((element) {
      widgets.add(sizeTagWidget(content: element));
    });

    return Wrap(
      children: widgets,
    );
  }
}
