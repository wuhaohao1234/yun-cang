//无主单详情页面
import 'package:wms/views/common/section_title_widget.dart';
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';

class ENWzdDetailPage extends StatelessWidget {
  final int id;
  final ENYbrkModel dataModel;

  const ENWzdDetailPage({Key key, this.id, this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: WMSText(
            content: '无主单详情',
            size: AppStyleConfig.navTitleSize,
          ),
        ),
        body: RefreshView(
          header: MaterialHeader(
            valueColor: AlwaysStoppedAnimation(Colors.black),
          ),
          onRefresh: () async {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SectionTitleWidget(
                  title: '基础信息',
                ),
                 Container(
                    child: Column(
                      children: [
                        WMSInfoRow(
                          title: '无主单号：',
                          content: dataModel?.orderIdName ?? '',
                        ),
                        WMSInfoRow(
                          title: '快递单号：',
                          content: dataModel?.mailNo ?? '',
                        ),
                        WMSInfoRow(
                          title: '签收时间：',
                          content: dataModel?.createTime ?? '',
                        ),
                        WMSInfoRow(
                          title: '仓库：',
                          content: dataModel?.depotName ?? '',
                        ),
                      ],
                    ),
                  ),
                SectionTitleWidget(
                  title: '照片信息',
                ),
                WMSImageWrap(
                    imagePaths: dataModel?.ownerlessImg?.split(';'),
                  ),
              ],
            ),
          ),
        ));
  }
}
