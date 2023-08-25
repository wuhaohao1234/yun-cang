// 银行卡信息页面
import 'package:wms/customer/common.dart'; //页面通用依赖集合
// import 'package:wms/common/baseWidgets/wm_code_input_widget.dart';
import 'cs_card_manage_page.dart';
import 'package:wms/configs/wms_user.dart';

class CSAddCardPage extends StatefulWidget {
  final model;
  final int type; //0 新增 1修改

  const CSAddCardPage({Key key, this.model, this.type}) : super(key: key);

  @override
  _CSAddCardPageState createState() => _CSAddCardPageState();
}

class _CSAddCardPageState extends State<CSAddCardPage> {
  int selectedCountryId;
  TextEditingController enterpriseName;
  TextEditingController countryId;
  TextEditingController currency;
  TextEditingController receiverAddress;
  TextEditingController accountName;
  TextEditingController cardNumber;
  TextEditingController identificationCode;
  TextEditingController bankName;
  TextEditingController userCode;
  TextEditingController accountType;
  TextEditingController adoptType;
  var countryList = [];
  int selectedCountryIndex;
  void requestCountry() {
    HttpServices.getCountryList(success: (data, total) {
      countryList = data;
      setState(() {
        if (widget.model == null || widget.model.countryId == null) {
          return false;
        }
        selectedCountryIndex = countryList.indexWhere(
          (element) => element.id == widget.model.countryId,
        );
        countryId.text =
            countryList[selectedCountryIndex == -1 ? 0 : selectedCountryIndex]
                .countryName;
        selectedCountryId = countryList[selectedCountryIndex].id;
      });
    }, error: (error) {
      ToastUtil.showMessage(message: error.message);
    });
  }

  @override
  void initState() {
    super.initState();
    requestCountry();
    enterpriseName = TextEditingController(text: widget.model.enterpriseName);
    countryId = TextEditingController(text: widget.model.countryId.toString());
    currency = TextEditingController(text: widget.model.currency);
    receiverAddress = TextEditingController(text: widget.model.receiverAddress);
    accountName = TextEditingController(text: widget.model.accountName);
    cardNumber = TextEditingController(text: widget.model.cardNumber);
    identificationCode =
        TextEditingController(text: widget.model.identificationCode);
    bankName = TextEditingController(text: widget.model.bankName);
    userCode = TextEditingController(text: widget.model.userCode??WMSUser.getInstance().userInfoModel.userCode);
    accountType = TextEditingController(text: widget.model.accountType);
    adoptType = TextEditingController(text: widget.model.adoptType);

    EventBusUtil.getInstance().on<SelectedArea>().listen((event) {
      if (event.area != null) {
        print('更新用户数据');
        setState(() {
          countryId.text = event.area['country'];
          selectedCountryId = int.parse(event.area['countryId']);
          selectedCountryIndex = countryList.indexWhere(
            (element) => element.id == selectedCountryId,
          );
          accountType.text = countryList[selectedCountryIndex].belongTo;
        });
      }
    });
  }

  Future<bool> postData() async {
    // 单品出售
    // EasyLoadingUtil.showLoading(statusText: '提交银行卡……');
    var postCardInfo = {
      "id": widget.model.id ?? null,
      "enterpriseName": enterpriseName.text,
      "countryId": selectedCountryId,
      "currency": currency.text,
      "receiverAddress": receiverAddress.text,
      "accountName": accountName.text,
      "cardNumber": cardNumber.text,
      "identificationCode": identificationCode.text,
      "bankName": bankName.text,
      "userCode": userCode.text,
      "accountType": accountType.text,
      "adoptType": adoptType.text
    };
    var res = await widget.type == 1
        ? HttpServices().editCard(postCardInfo: postCardInfo)
        : HttpServices().addCard(postCardInfo: postCardInfo);
    if (res == false) {
      EasyLoadingUtil.showMessage(message: '提交银行卡失败');
      return false;
    }
    if (res != null) {
      print(res);
      EasyLoadingUtil.showMessage(message: '提交银行卡操作成功');
      print("cooo");
      Get.offAll(() => CSCardManagePage());
      return true;
    } else {
      EasyLoadingUtil.showMessage(message: '提交银行卡失败');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // CSAddCardPageController pageController =
    //     Get.put(CSAddCardPageController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: WMSText(
          content: '编辑银行卡',
          size: AppStyleConfig.navTitleSize,
        ),
        leading: BackButton(
          onPressed: () {
            // pageController.onClose();
            // Get.delete<CSAddCardPageController>();
            // Get.offAll(() => CSZiZhuCangAddOrderPage());
            Get.back();
          },
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            child: ScrollConfiguration(
              behavior: JKOverScrollBehavior(),
              child: ListView(
                children: [
                  WMSTextField(
                    title: '企业名称',
                    hintText: '请输入',
                    keyboardType: TextInputType.text,
                    controller: enterpriseName,
                  ),
                  WMSTextField(
                      title: '收款国家/区域',
                      hintText: '请输入，必填',
                      keyboardType: TextInputType.text,
                      controller: countryId,
                      endWidget: GestureDetector(
                          onTap: () {
                            WMSBottomSheet.showAreaSheet(context,
                                countryStatus: true);
                          },
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.black,
                          ))),
                  // buildBarcodeWdidget(pageController),
                  WMSTextField(
                    title: '收款币种',
                    hintText: '请输入',
                    keyboardType: TextInputType.text,
                    controller: currency,
                  ),

                  WMSTextField(
                      title: '收款人地址',
                      hintText: '请输入，必填',
                      keyboardType: TextInputType.text,
                      controller: receiverAddress),
                  WMSTextField(
                    title: '账户名称',
                    hintText: '请输入，必填',
                    keyboardType: TextInputType.text,
                    controller: accountName,
                  ),
                  WMSTextField(
                      title: '收款银行识别码',
                      hintText: '请输入',
                      keyboardType: TextInputType.text,
                      controller: identificationCode),
                  WMSTextField(
                      title: '收款人账号',
                      hintText: '请输入，必填',
                      keyboardType: TextInputType.text,
                      controller: cardNumber),
                  WMSTextField(
                      title: '收款人银行名称',
                      hintText: '请输入，必填',
                      keyboardType: TextInputType.text,
                      controller: bankName),

                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(90.w, 34.w),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        // ),
                      ),
                      onPressed:
                          // pageController.checkInput() == false
                          //     ? null
                          //     :
                          () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        // pageController.onTapCommitHandle();
                        postData();
                      },
                      child: Text(
                        '保存 ',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
