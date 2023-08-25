import 'package:wms/customer/common.dart';

class ChuKuChengGong extends StatelessWidget {
  final String expressNumber;

  const ChuKuChengGong({Key key, this.expressNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: '下单完成',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color: Colors.grey[50],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 20.h),
          child: Column(
            children: [ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.6,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.grey[100], blurRadius: 2, spreadRadius: 0, offset: Offset(0, 2))
                ]),
                child: Column(
                  children: [
                    ClipPath(
                      clipper: __MyPathClipper(MediaQuery.of(context).size.width * 0.9, 140),
                      child: Container(
                        height: 140,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20.w),
                        color: Colors.red,
                        child: Text(
                          "下单完成！",
                          style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                        child: WMSText(
                          size: 20.sp,
                          bold: true,
                          content: "运单号 ${expressNumber??''}",
                        )),
                    SvgPicture.asset(
                      'assets/svgs/快递盒.svg',
                      width: 160.w,
                      // color: Colors.white,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                        child: WMSText(
                          size: 20.sp,
                          bold: true,
                          content: "请把[运单]按照上图指示贴余快件上",
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                        child: WMSText(
                          size: 16.sp,
                          bold: true,
                          content: "快递公司人员完成收件后，您可以通过扫描二维码追踪快件位置。如果需收派员上门取件，请直接预约快递公司收派员上门取件。",
                        ))
                  ],
                ),
              ),
            ),Spacer()],
          ),
        ),
      ),
    );
  }
}

class __MyPathClipper extends CustomClipper<Path> {
  double width;
  double height;

  __MyPathClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width, height / 3);
    path.lineTo(0, height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
