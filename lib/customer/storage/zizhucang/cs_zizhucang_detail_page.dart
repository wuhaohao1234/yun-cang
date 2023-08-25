/*
* 客户端入-仓储管理模块- 自主单详情页面
* */

import 'package:wms/customer/common.dart'; //页面通用依赖集合

class CSZiZhuCangDetailPage extends StatelessWidget {
  final int id;
  final Map model;

  const CSZiZhuCangDetailPage({Key key, this.id, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '自主仓详情',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: ListView(
            children: [
              SectionTitleWidget(title: '基础信息'),
              infoItemWidget(
                  title: '商品货号：', content: model['stockCode'] ?? '-'),
              infoItemWidget(
                  title: '标签条码：', content: model['labelBarCode'] ?? '-'),
              infoItemWidget(title: '规格/尺码：', content: model['size'] ?? ''),
              infoItemWidget(
                  title: '数量：', content: model['skuCount'].toString() ?? ''),
              infoItemWidget(
                title: '商品照片：',
              ),
              WMSImageWrap(
                imagePaths: model['picturePath']?.split(';'),
              ),
              infoItemWidget(
                title: '备注：',
              ),
              SizedBox(height: 8.h),
              TextField(
                enabled: false,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 13.sp, color: Colors.black),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: model['remark'],
                  // border: InputBorder.none,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Colors.grey[200], width: 0.1)),
                  hintStyle: TextStyle(fontSize: 13.sp, color: Colors.black),
                ),
              ),
              SectionTitleWidget(title: '审核信息'),
              infoItemWidget(
                  title: '商品审核状态：',
                  content:
                      WMSUtil.orderReviewStringChange(model['orderReview'])),
              infoItemWidget(
                title: '审核说明：',
              ),
              SizedBox(height: 8.h),
              TextField(
                enabled: false,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 13.sp, color: Colors.black),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: model['auditProposal'],
                  // border: InputBorder.none,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Colors.grey[200], width: 0.1)),
                  hintStyle: TextStyle(fontSize: 13.sp, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
