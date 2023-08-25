import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wms/utils/easy_loading_util.dart';

typedef void ChooseStatusCallback(map);

class PayStatusWidget extends StatefulWidget {
  final changeStatusCallback;
  final List forbiddenValue;
  final ChooseStatusCallback chooseStatusCallback;
  final initialValue;

  const PayStatusWidget(
      {Key key,
      this.changeStatusCallback,
      this.chooseStatusCallback,
      this.initialValue,
      this.forbiddenValue})
      : super(key: key);

  @override
  _PayStatusWidgetState createState() => _PayStatusWidgetState();
}

class _PayStatusWidgetState extends State<PayStatusWidget> {
  var selectedValue;
  List<Map<String, dynamic>> payStatusList = [
    {
      "lable": '微信',
      "value": 1,
      "icon": SvgPicture.asset(
        'assets/svgs/微信方.svg',
        width: 24,
      ),
    },
    {
      "lable": '支付宝',
      "value": 2,
      "icon": SvgPicture.asset(
        'assets/svgs/支付宝支付.svg',
        width: 15,
      ),
    },
    {
      "lable": '店铺账户',
      "value": 4,
      "icon": SvgPicture.asset(
        'assets/svgs/店铺支付.svg',
        width: 15,
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedValue = widget.initialValue ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 49.0,
                alignment: Alignment.center,
                child: Text('请选择支付方式'),
              ),
              Positioned(
                child: IconButton(
                  onPressed: widget.changeStatusCallback,
                  // onPressed: () => switchStatus(),
                  icon: Icon(Icons.arrow_back_ios_outlined),
                ),
                left: 0,
                top: 0,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: List<Widget>.generate(
                payStatusList.length,
                (index) => Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          print(index);
                          if (widget.forbiddenValue
                              .contains(payStatusList[index]['value'])) {
                            EasyLoadingUtil.showMessage(message: '不可选择该支付方式');

                            return false;
                          }
                          setState(() {
                            selectedValue = payStatusList[index]['value'];
                          });
                          print(payStatusList[index]);
                          widget.chooseStatusCallback(payStatusList[index]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: widget.forbiddenValue
                                    .contains(payStatusList[index]['value'])
                                ? Colors.grey[200]
                                : null,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(width: 2.0, color: Colors.grey[200]),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              payStatusList[index]['icon'],
                              Text(payStatusList[index]['lable']),
                              Icon(
                                selectedValue ==
                                            payStatusList[index]['value'] &&
                                        !widget.forbiddenValue.contains(
                                            payStatusList[index]['value'])
                                    ? Icons.check_circle_outline_outlined
                                    : Icons.circle_outlined,
                                size: 18.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
