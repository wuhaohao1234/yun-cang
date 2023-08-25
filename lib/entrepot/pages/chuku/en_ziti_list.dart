// 分拣-自提的列表界面
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合
import 'package:wms/views/entrenpot/chuku/en_fenjian_cell.dart';
import 'package:wms/entrepot/controllers/chuku/en_fenjian_ziti_page_controller.dart';
import 'en_fenjian_detail_page.dart';

class ZitiList extends StatelessWidget {
  final String outStoreName;
  const ZitiList({Key key, this.outStoreName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ENFenJianZitiPageController pageController =
        Get.put(ENFenJianZitiPageController(outStoreName));
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
