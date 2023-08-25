import 'package:wms/customer/common.dart'; //页面通用依赖集合

import 'package:wms/models/market/market_all_detail_model.dart';

// 上架页面
class MKShelvesPage extends StatelessWidget {
  final int type; // 0 得物   1 APP
  final MarketAllDetailModel dataModel;

  const MKShelvesPage({Key key, this.type, this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MKShelvesPageController pageController = Get.put(MKShelvesPageController(1));

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: type == 0 ? '上架得物' : '上架APP',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Column(
              children: [
                buildTopWidget(),
                buildSizeListWidget(),
                buildShelvesCount(),
                buildPrice(),
                buildAutomaticPrice(),
              ],
            ),
            Positioned(
                bottom: 20.h,
                child: Row(
                  children: [
                    WMSButton(
                      title: '下架',
                      width: 160.w,
                      bgColor: Colors.white,
                      textColor: Colors.black,
                      showBorder: true,
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    WMSButton(
                      title: '上架',
                      width: 160.w,
                      bgColor: AppConfig.themeColor,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  // 商品信息
  Widget buildTopWidget() {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.network(
              'https://img.alicdn.com/bao/uploaded/i4/279491572/O1CN01gJIAtI1NU1CW9blRy_!!279491572.jpg_468x468q75.jpg_.webp',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dataModel?.commodityName ?? ''}',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  '${dataModel?.stockCode ?? ''}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 在售尺寸
  Widget buildSizeListWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: WMSText(
              content: '选择尺码',
              size: 14,
              bold: true,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              children: buildSizeList(dataModel?.childrenList),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildSizeList(List<SizeModel> list) {
    List<Widget> widgets = [];
    list?.forEach((element) {
      widgets.add(buildSizeItemWidget(element));
    });

    return widgets;
  }

  Widget buildSizeItemWidget(SizeModel model) {
    return Container(
      width: 60.w,
      height: 60.w,
      color: Colors.black,
      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WMSText(
            content: '${model.size}',
            size: 14,
            bold: true,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  // 上架数量
  Widget buildShelvesCount() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WMSText(
            content: '上架数量',
            bold: true,
          ),
          Row(
            children: [
              Container(
                width: 100.w,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.r),
                  ),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  // controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '输入数量',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              WMSText(
                content: '件',
                bold: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 出价
  Widget buildPrice() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WMSText(
            content: '出价',
            bold: true,
          ),
          Row(
            children: [
              Container(
                width: 100.w,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.r),
                  ),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  // controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '输入价格',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              WMSText(
                content: '元',
                bold: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 自动跟随最低价
  Widget buildAutomaticPrice() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WMSText(
            content: type == 0 ? '自动跟随最低价' : '可议价',
            bold: true,
          ),
          IconButton(
              icon: Icon(Icons.radio_button_unchecked), onPressed: () {}),
        ],
      ),
    );
  }
}
