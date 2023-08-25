import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:wms/configs/wms_user.dart';

class CSAddWechatPage extends StatefulWidget {
  @override
  _CSAddWechatPageState createState() => _CSAddWechatPageState();
}

class _CSAddWechatPageState extends State<CSAddWechatPage> {
  TextEditingController _controller = TextEditingController();
  // 请求数据
  void requestData() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();

    var res = await HttpServices().getWeChatAccount();

    if (res['result']) {
      print(res['data']);
      EasyLoadingUtil.hidden();
      _controller.text = res['data'];
    } else {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: res['data']);
    }
  }

  void submitWeChat() async {
    // 请求特定页面的数据
    EasyLoadingUtil.showLoading();

    var res = await HttpServices().getBindWeChat(account: _controller.text);

    if (res['result']) {
      print(res['data']);
      EasyLoadingUtil.hidden();

      EasyLoadingUtil.hidden();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      ToastUtil.showMessage(message: '设置成功！');
      WMSUser.getInstance().weChatAccount = _controller.text;
      SPUtils.saveWeChatAccount(WMSUser.getInstance().weChatAccount);
    } else {
      EasyLoadingUtil.hidden();
      EasyLoadingUtil.showMessage(message: res['data']);
    }
  }

  @override
  void initState() {
    super.initState();
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '添加微信号',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildInputWidget(),
            // buildAddButtonWidget(),
            Container(
              margin: EdgeInsets.only(bottom: 20.h),
              child: buildButtonWidget(
                bgColor: AppConfig.themeColor,
                contentColor: Colors.white,
                buttonContent: '添加',
                handelClick: submitWeChat,
                radius: 2.0,
                width: 343.0,
                height: 34.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputWidget() {
    return Container(
      child: Center(
        child: Container(
          width: 300.w,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50.w,
                child: Text(
                  '微信号',
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: TextField(
                  cursorColor: Colors.black,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: '请输入微信号',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
