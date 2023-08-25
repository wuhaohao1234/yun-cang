import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wms/entrepot/pages/common.dart';
import 'package:wms/views/common/common_style_widget.dart';
import 'package:get/get.dart';
import 'package:wms/entrepot/pages/scan/en_scan_test_page.dart';
import 'dart:async';

class InputSearchBarWidget extends StatefulWidget {
  final submitCallback;
  final cancelCallback;
  final searchHinterText;
  final scanHinterText;
  final actionButtonContent;
  final showActionButtonDynamically;
  final allowScan;
  final submitOnChange; // this determines if we want to trigger callback everytime the content changes
  const InputSearchBarWidget({
    Key key,
    this.submitCallback,
    this.cancelCallback,
    this.searchHinterText = '请输入商品名称',
    this.scanHinterText = '扫码',
    this.actionButtonContent = '搜索',
    this.showActionButtonDynamically = false,
    this.allowScan = true,
    this.submitOnChange = true,
  }) : super(key: key);

  @override
  _InputSearchBarWidgetState createState() => _InputSearchBarWidgetState();
}

class _InputSearchBarWidgetState extends State<InputSearchBarWidget> {
  var searchContentController = TextEditingController();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    setState(() {
      //设置初始index
    });
  }

//设置debounce
  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      // do something with query
      setState(() {});
      if (widget.submitOnChange) {
        widget.submitCallback(query);
      }
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: 30.h,
      // color: Colors.red,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 16.w),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.h),
                color: Colors.grey[50],
              ),
              // height: 30.h,
              child: TextField(
                onSubmitted: (value) {
                  setState(() {});
                  // FocusScope.of(context).requestFocus(FocusNode());
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  widget.submitCallback(value);
                },
                onChanged: (value) {
                  // _onSearchChanged(value);
                },

                controller: searchContentController,
                keyboardType: TextInputType.text,
                // 控制键盘的功能键 指enter键，比如此处设置为next时，enter键
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    // contentPadding: EdgeInsets.only(top: -8.h),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18.sp,
                      color: Colors.grey,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: searchContentController.text != null &&
                              searchContentController.text != '',
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: new Icon(Icons.cancel),
                            color: Colors.grey,
                            iconSize: 18.0,
                            onPressed: () {
                              // FocusScope.of(context).requestFocus(FocusNode());
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              searchContentController.text = '';
                              widget.cancelCallback();
                            },
                          ),
                        ),
                        // if showActionButtonDynamically is set to true,
                        // the the button should only appear when there are some nonempty strings.
                        Visibility(
                            visible: !widget.showActionButtonDynamically ||
                                (searchContentController.text != null &&
                                    searchContentController.text != ''),
                            child: GestureDetector(
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                widget.submitCallback(
                                    searchContentController.text);
                              },
                              child: buildButtonWidget(
                                buttonContent: widget.actionButtonContent,
                                bgColor: AppConfig.themeColor,
                                contentColor: Colors.white,
                                borderColor: Colors.black,
                                width: 50.w,
                                height: 30.w,
                                handelClick: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  widget.submitCallback(
                                      searchContentController.text);
                                },
                              ),
                            )),
                      ],
                    ),
                    hintStyle: TextStyle(fontSize: 13.sp),
                    hintText: widget.searchHinterText,
                    border: InputBorder.none),
                // onChanged: onSearchTextChanged,
              ),
            ),
          ),
          if (widget.allowScan)
            GestureDetector(
              onTap: () {
                  Get.to(() => ENScanStandardPage(
                    title: widget.scanHinterText,
                    // leading: backLeadingIcon,
                  )).then((value) {
                    setState(() {
                      searchContentController.text = value;
                    });
                  });
              },
              child: SvgPicture.asset(
                'assets/svgs/scan.svg',
                width: 18.w,
              ),
            )
        ],
      ),
      //   ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
