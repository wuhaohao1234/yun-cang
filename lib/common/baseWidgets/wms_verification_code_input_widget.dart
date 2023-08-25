import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:wms/customer/login/controllers/cs_register_page_controller.dart';

class WMSVerificationCodeInputWidget extends StatelessWidget {
  final VoidCallback callback;
  final String btnText;
  final TextEditingController controller;
  final bool showLeadding;

  const WMSVerificationCodeInputWidget(
      {Key key,
      this.callback,
      this.btnText,
      this.controller,
      this.showLeadding = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CSRegisterPageController pageController =
        Get.put(CSRegisterPageController());

    return Container(
      child: Center(
        child: Container(
          width: 300.w,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
            ),
          ),
          child: Container(
            width: 50.w,
            child: Row(
              children: [
                Visibility(
                  visible: showLeadding,
                  child: Container(
                    width: 50.w,
                    child: Text(
                      '验证码',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: '请输验证码',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: pageController.btnText.value == '获取验证码'
                        ? callback
                        : null,
                    child: Obx(
                      () => Text(
                        pageController.btnText.value,
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
