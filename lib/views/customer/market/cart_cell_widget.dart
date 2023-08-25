import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_size_tag_widget.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/models/shopping_cart_model.dart';

class CartCellWidget extends StatelessWidget {
  final VoidCallback addCallback;
  final VoidCallback subCallback;
  final ShoppingCartModel dataModel;

  const CartCellWidget(
      {Key key, this.addCallback, this.subCallback, this.dataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      color: Colors.white,
      padding: EdgeInsets.only(top: 8.h, right: 16.w, bottom: 8.h),
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.check_box_outline_blank_sharp),
              onPressed: () {}),
          Container(
            width: 80.w,
            height: 80.w,
            child: Image.network(
              'https://img.alicdn.com/bao/uploaded/i1/2090329805/O1CN01L0s73C2MIk0ccbWkH_!!0-item_pic.jpg_468x468q75.jpg_.webp',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Container(
              height: 80.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WMSText(
                    content: 'NIKE LOGO短袖',
                    bold: true,
                  ),
                  WMSText(
                    content: '货号：RSSSJ133322 ',
                    color: Colors.grey,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            WMSSizeTagWidget(
                              title: 'M',
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            WMSSizeTagWidget(
                              title: '白色',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            WMSText(
                              content: '¥456',
                              bold: true,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            GestureDetector(
                              onTap: subCallback,
                              child: Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                width: 30.w,
                                height: 24.w,
                                child: WMSText(
                                  content: '-',
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              width: 30.w,
                              height: 24.w,
                              child: WMSText(
                                content: dataModel?.count.toString(),
                              ),
                            ),
                            GestureDetector(
                              onTap: addCallback,
                              child: Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                width: 30.w,
                                height: 24.w,
                                child: WMSText(
                                  content: '+',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
