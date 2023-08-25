import 'package:wms/customer/common.dart'; //页面通用依赖集合
// import 'package:wms/common/baseWidgets/wms_bottom_sheet.dart';
import 'cs_card_manage_page.dart';
import 'cs_wallet_account_page.dart';

class CSWithdrawCashPage extends StatefulWidget {
  const CSWithdrawCashPage({Key key}) : super(key: key);

  @override
  _CSWithdrawCashPageState createState() => _CSWithdrawCashPageState();
}

class _CSWithdrawCashPageState extends State<CSWithdrawCashPage> {
  /*
    GlobalKey：整个应用程序中唯一的键
    ScaffoldState：Scaffold框架的状态
    解释：_scaffoldKey的值是Scaffold框架状态的唯一键
   */
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var cardList = [];
  var cardIndex;
  TextEditingController setWithdrawMoney;

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
        EasyLoadingUtil.showMessage(message: '未获取到数据');
        setState(() {
          cardList = [];
        });
      } else {
        setState(() {
          cardList = resCardList["data"];
        });
      }

      setState(() {
        cardIndex = 0;
      });
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
    setWithdrawMoney = TextEditingController();
  }

  void submit() {
    EasyLoadingUtil.showLoading();
  }

  Future<bool> postData() async {
    // 单品出售
    // EasyLoadingUtil.showLoading(statusText: '提现中……');
    var res = await HttpServices().withdrawal(
      id: cardList[cardIndex].id,
      money: double.parse(setWithdrawMoney.text),
    );
    if (res['result'] == false) {
      EasyLoadingUtil.showMessage(message: res['data'] ?? '提现操作失败');
      return false;
    }
    if (res != null) {
      print(res);
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: '提现操作成功');
      Get.back();
      return true;
    } else {
      EasyLoadingUtil.showMessage(message: '提现操作失败');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '账户提现',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            Get.to(() => CSWalletAccountPage());
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.to(() => CSCardManagePage()),
            child: WMSText(
              content: '银行卡',
              size: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext c) {
    print("cardList${cardList.length}");
    return Container(
      width: double.maxFinite,
      color: Color(0xffffffff),
      child: Column(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                setUpWidget(context, buildBottomSheetWidget(context));
                // showModalBottomSheet(
                //     context: context,

                //     builder: (BuildContext context) {
                //       //构建弹框中的内容
                //       return buildBottomSheetWidget(context);
                //     });
              },
              child: cardList == [] || cardIndex == null
                  ? Text('ddd')
                  : itemSectionWidget(
                      title: '到账银行',
                      child: Text(cardList.length != 0
                          ? '${cardList[cardIndex].accountType == '0' ? '境内银行卡' : '境外银行卡' ?? '--'} ${cardList[cardIndex].identificationCode ?? '-'}'
                          : "未绑定银行卡"))),

          buildWithdrawWidget(),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: buildButtonWidget(
              width: 343.0,
              height: 36.0,
              buttonContent: '提现',
              bgColor: AppConfig.themeColor,
              contentColor: Colors.white,
              handelClick: setWithdrawMoney.text == null
                  ? null
                  : () {
                      postData();
                    },
              radius: 2.0,
            ),
          ),
          // Container(
          //   color: Colors.white,
          //   padding: EdgeInsets.only(bottom: 20.h),
          //   child: ElevatedButton(
          //     style: TextButton.styleFrom(
          //       minimumSize: Size(90.w, 34.h),
          //       fixedSize: Size(343.w, 34.h),
          //       // shape: RoundedRectangleBorder(
          //       //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
          //       // ),
          //     ),
          //     onPressed: false
          //         ? null
          //         : () async {
          //             FocusScope.of(context).requestFocus(FocusNode());

          //             if (true) {
          //               final value = await HttpServices().addPrepareOrder();
          //               if (value == false) {
          //                 EasyLoadingUtil.hidden();
          //                 EasyLoadingUtil.showMessage(message: '未成功提交预约数据');
          //                 return false;
          //               }
          //               if (value == null) {
          //                 EasyLoadingUtil.showMessage(message: '已提交预约入库数据');
          //               }
          //               // EasyLoadingUtil.showLoading(statusText: "...");

          //               EasyLoadingUtil.hidden();
          //             } else {
          //               var data = await HttpServices().updataPrepareOrder();
          //               if (data != false) {
          //                 // EasyLoadingUtil.showLoading(statusText: "...");
          //                 EasyLoadingUtil.showMessage(message: '已提交预约入库数据');
          //               }
          //             }
          //           },
          //     child: Text(
          //       '提现',
          //       style: TextStyle(fontSize: 12.sp),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildWithdrawWidget() {
    return Container(
        // height: 180.h,
        width: 343.w,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        margin: EdgeInsets.symmetric(
          vertical: 16.h,
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Column(children: [
          SectionTitleWidget(
            title: '提现金额',
          ),
          TextField(
            controller: setWithdrawMoney,
            onChanged: (value) {
              setState(() {});
            },
            autofocus: true,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: WMSText(
                content: '¥',
                color: Colors.grey,
                size: 36,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              WMSText(content: '可提现余额{}元 ', color: Colors.grey),
              GestureDetector(onTap: () {}, child: WMSText(content: '全部提现 ', color: Colors.blue, bold: true))
            ],
          ),
        ]));
  }

//底部选择银行卡弹窗
  Widget buildBottomSheetWidget(BuildContext context) {
    //弹框中内容  310 的调试
    //  Navigator.of(context).pop();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        // height: 155.sp,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WMSText(
              content: '选择到账银行卡',
              bold: true,
              size: 16,
            ),
            SizedBox(height: 8.h),
            WMSText(content: '请留意各银行到账时间'),
            SizedBox(height: 8.h),
            Column(
                children: List.generate(cardList.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    cardIndex = index;
                    print(cardList[cardIndex].id);
                  });
                  Navigator.of(context).pop();
                },
                child: itemSectionWidget(
                  // title: '',
                  prefixChild: Row(children: [
                    Icon(
                      Icons.credit_card_outlined,
                      color: Colors.black,
                    ),
                    Text(
                      '${cardList[index].accountType == '0' ? '境内银行卡' : '境外银行卡'} ${cardList[index].identificationCode}',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                      color: cardList[index].adoptType == '0' ? Colors.lightBlueAccent[100] : Colors.grey[200],
                      child: WMSText(
                        content: cardList[index].adoptType == '0' ? '已开通' : '未开通',
                        color: Colors.blue,
                        size: 12,
                      ),
                    )
                  ]),
                  child: cardIndex == index ? Icon(Icons.check_circle_outline_outlined) : null,
                  showIcon: false,
                ),
              );
            })),
            // buildButtonWidget(
            //   width: 343.0,
            //   height: 36.0,
            //   buttonContent: '确定',
            //   bgColor: Colors.black,
            //   contentColor: Colors.white,
            //   handelClick: cardIndex != null
            //       ? null
            //       : () {
            //           Navigator.of(context).pop();
            //         },
            //   radius: 2.0,
            // ),
          ],
        ),
      ),
    );
  }
}
