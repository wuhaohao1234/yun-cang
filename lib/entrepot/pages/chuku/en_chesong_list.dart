// 分拣-车送的列表界面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/views/entrenpot/chuku/en_fenjian_cell.dart';
import 'package:wms/entrepot/controllers/chuku/en_fenjian_chesong_page_controller.dart';
import 'en_fenjian_detail_page.dart';

class CheSongList extends StatelessWidget {
  final String outStoreName;
  const CheSongList({Key key, this.outStoreName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ENFenJianCheSongPageController pageController =
        Get.put(ENFenJianCheSongPageController(outStoreName));
    return Container(
      child: Obx(
        () {
          return RefreshView(
            header: MaterialHeader(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ),
            onRefresh: pageController.onRefresh,
            onLoad: pageController.canMore.value ? pageController.onLoad : null,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ENFenJianCell(
                  index: index,
                  model: pageController.dataSource[index],
                  callback: () {
                    Get.to(() => ENFenJianDetailPage(
                        outOrderId: pageController.dataSource[index].outOrderId,
                        outStoreName:
                            pageController.dataSource[index].outStoreName,
                        tenantUserCode:
                            pageController.dataSource[index].tenantUserCode,
                        dataModel: pageController.dataSource[index]));
                  },
                );
              },
              itemCount: pageController.dataSource.length,
            ),
          );
        },
      ),
    );
  }
}
