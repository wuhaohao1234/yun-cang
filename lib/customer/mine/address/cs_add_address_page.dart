import 'package:wms/customer/common.dart'; //页面通用依赖集合
import 'package:flutter/cupertino.dart';
import 'package:wms/customer/mine/controllers/cs_add_address_page_controller.dart';
import 'package:wms/models/address/address_model.dart';

class CSAddAddressPage extends StatefulWidget {
  final bool isAdd; // true 新增  false 编辑
  final AddressModel addressModel;
  const CSAddAddressPage({Key key, this.isAdd = true, this.addressModel})
      : super(key: key); //

  @override
  _CSAddAddressPageState createState() => _CSAddAddressPageState();
}

class _CSAddAddressPageState extends State<CSAddAddressPage> {
  CSAddAddressPageController pageController;

  @override
  void initState() {
    pageController = Get.put(CSAddAddressPageController(widget.addressModel));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (!isAdd) {
    //   pageController.setAddressModel(addressModel);
    // }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: WMSText(
          content: widget.isAdd ? '添加新地址' : '编辑地址',
          size: AppStyleConfig.navTitleSize,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    WMSTextField(
                      title: '姓名',
                      hintText: '输入真实姓名',
                      keyboardType: TextInputType.text,
                      controller: pageController.nameController,
                    ),
                    WMSTextField(
                      title: '身份证号',
                      hintText: '输入身份证号',
                      keyboardType: TextInputType.emailAddress,
                      controller: pageController.idController,
                    ),
                    WMSTextField(
                      title: '手机号',
                      hintText: '输入手机号',
                      controller: pageController.phoneController,
                    ),
                    buildAreaWidget(pageController, context),
                    WMSTextField(
                      title: '详细地址',
                      hintText: '',
                      keyboardType: TextInputType.text,
                      controller: pageController.addressController,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      alignment: Alignment.centerLeft,
                      child: WMSText(
                        content: '上传身份证',
                        bold: true,
                      ),
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  pageController.onTapAddImagBtnHandel(
                                      context, 1);
                                },
                                child: Container(
                                  width: 100.w,
                                  height: 100.w,
                                  decoration: BoxDecoration(
                                    image: pageController.image1.value != ''
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                pageController.image1.value),
                                            fit: BoxFit.contain,
                                          )
                                        : null,
                                    border: Border.all(
                                      width: 1.w,
                                      color: Colors.grey[100],
                                    ),
                                  ),
                                  child: pageController.image1.value == ''
                                      ? Icon(
                                          Icons.camera_alt,
                                          size: 60.w,
                                        )
                                      : Container(),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              WMSText(
                                content: '正面',
                                color: Colors.grey,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Obx(
                          () => Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  pageController.onTapAddImagBtnHandel(
                                      context, 2);
                                },
                                child: Container(
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: BoxDecoration(
                                      image: pageController.image2.value != ''
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  pageController.image2.value),
                                              fit: BoxFit.contain,
                                            )
                                          : null,
                                      border: Border.all(
                                        width: 1.w,
                                        color: Colors.grey[100],
                                      ),
                                    ),
                                    child: pageController.image2.value == ''
                                        ? Icon(
                                            Icons.camera_alt,
                                            size: 60.w,
                                          )
                                        : Container()),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              WMSText(
                                content: '反面',
                                color: Colors.grey,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    buildDefaultWidget(pageController),
                  ],
                ),
              ),

              // SizedBox(
              //   height: 80.h,
              // ),

              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20.h),
                child: WMSButton(
                  bgColor: AppConfig.themeColor,
                  title: '保存',
                  callback: () => pageController.onTapSaveHandle(widget.isAdd),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAreaWidget(
      CSAddAddressPageController pageController, BuildContext context) {
    return GestureDetector(
      onTap: () {
        pageController.onTapSelectAddressHandle(context);
      },
      child: Container(
        margin: EdgeInsets.only(top: 16.h),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
          ),
        ),
        child: Row(
          children: [
            WMSText(
              content: '地区',
              bold: true,
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Container(
                child: Obx(
                  () => WMSText(
                    content: pageController.province.value +
                        pageController.city.value +
                        pageController.area.value,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Widget buildDefaultWidget(CSAddAddressPageController pageController) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WMSText(
            content: '设为默认地址',
          ),
          Obx(
            () => CupertinoSwitch(
              value: pageController.isDefalut.value,
              activeColor: Colors.black,
              onChanged: (value) {
                pageController.onTapSwitchHandle(value);
              },
            ),
          )
        ],
      ),
    );
  }
}
