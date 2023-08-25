// 分拣列表
import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

class ENUNPage extends StatefulWidget {
  const ENUNPage({Key key}) : super(key: key);
  @override
  _ENUNPageState createState() => _ENUNPageState();
}

class _ENUNPageState extends State<ENUNPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17.h),
              // color: Colors.grey[200],
            ),
            child: Center(
              child: Column(children: [
                SizedBox(height: 100.h),
                SvgPicture.asset(
                  'assets/svgs/nofound.svg',
                  width: 150.w,
                ),
                SizedBox(height: 20.h),
                Text("暂未设计，请等待")
              ]),
            ),
          ),
        )
      ]),
    );
  }
}
