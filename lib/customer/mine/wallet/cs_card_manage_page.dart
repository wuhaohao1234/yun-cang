import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/views/customer/mine/card_cell_widget.dart';
import 'package:wms/models/mine/card_model.dart';
// import 'controllers/cs_address_manage_page_controller.dart';
import 'cs_add_card_page.dart';
import 'cs_withdraw_cash_page.dart';

class CSCardManagePage extends StatefulWidget {
  @override
  _CSCardManagePageState createState() => _CSCardManagePageState();
}

class _CSCardManagePageState extends State<CSCardManagePage> {
  var cardList = [];

  //获取银行卡数据数据；
  Future<bool> requestCardData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();
    var resCardList = await HttpServices().getCardList();
    print(resCardList);
    if (resCardList == false) {
      return false;
    }
    if (resCardList != null) {
      final data = resCardList["data"];
      if (resCardList["total"] == 0) {
        EasyLoadingUtil.showMessage(message: '未获取到数据，假数据');
        setState(() {
          cardList = [];
        });
      } else {
        setState(() {
          cardList = resCardList["data"];
        });
      }

      EasyLoadingUtil.hidden();
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    requestCardData();
  }

  @override
  Widget build(BuildContext context) {
    // CSAddressManagePageController pageController =
    //     Get.put(CSAddressManagePageController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '银行卡管理',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            Get.to(() => CSWithdrawCashPage());
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: Column(
            children: [
              Expanded(
                  child: RefreshView(
                header: MaterialHeader(
                  valueColor: AlwaysStoppedAnimation(AppStyleConfig.themColor),
                ),
                child: cardList.length != 0
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          return CardCellWidget(
                            model: cardList[index],
                            select: () {
                              // Get.back(result: pageController.dataSource[index]);
                            },
                            callback: () {
                              print('huidiao');
                              // pageContr oller.toEditPage(index);
                              Get.to(() => CSAddCardPage(
                                  model: cardList[index], type: 1));
                            },
                          );
                        },
                        // itemCount: pageController.dataSource.length,
                        itemCount: cardList.length,
                      )
                    : Center(child: Text('暂无数据～')),
              )),
              Container(
                padding: EdgeInsets.only(bottom: 20.h),
                child: buildButtonWidget(
                  width: 343.0,
                  height: 36.0,
                  buttonContent: '增加银行卡',
                  bgColor: AppConfig.themeColor,
                  contentColor: Colors.white,
                  handelClick: () {
                    Get.to(() => CSAddCardPage(type: 0, model: CardModel()));
                  },
                  radius: 2.0,
                ),
              ),
              // buildAddButtonWidget(pageController),
            ],
          ),
        ),
      ),
    );
  }
}
