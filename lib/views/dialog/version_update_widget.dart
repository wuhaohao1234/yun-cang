import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ota_update/ota_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'package:wms/customer/common.dart';
import 'package:wms/models/version_model.dart';
import 'package:wms/utils/aot_utils.dart';
import 'package:wms/utils/toast_util.dart';

class VersionUpdateWidget extends StatelessWidget {
  final VersionModel model;

  const VersionUpdateWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (model.isUpdate == 1) {
          return false;
        }
        return true;
      },
      child: Container(
        height: 307.h,
        width: 262.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.transparent),
        child: Visibility(
          visible: true,
          child: Stack(
            children: [
              SvgPicture.asset(
                'assets/svgs/version_bg.svg',
                width: 262.w,
                height: 119.h,
              ),
              Visibility(
                  visible: model.isUpdate == 0,
                  child: Positioned(
                      top: 10,
                      right: 0,
                      child: SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: IconButton(
                          icon:
                              Icon(Icons.clear, color: Colors.white, size: 30),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ))),
              Visibility(
                  visible: model.isUpdate == 0,
                  child: Positioned(
                      top: 10,
                      right: 0,
                      child: SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: IconButton(
                          icon:
                              Icon(Icons.clear, color: Colors.white, size: 30),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ))),
              Positioned(
                  top: 108.h,
                  child: Container(
                    height: 187.h,
                    width: 262.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.r),
                        bottomRight: Radius.circular(15.r),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        WMSText(
                          content: model?.title ?? '',
                          bold: true,
                        ),
                        WMSText(
                          content: model?.details ?? '',
                          size: 13,
                        ),
                        UpdateBtn(
                          downloadUrl: model.path,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateBtn extends StatefulWidget {
  final String downloadUrl;

  const UpdateBtn({Key key, this.downloadUrl}) : super(key: key);

  @override
  _UpdateBtnState createState() => _UpdateBtnState();
}

class _UpdateBtnState extends State<UpdateBtn> {
  CancelToken _cancelToken;
  bool _downloading = false;

  double total = 0;
  double width = 190;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _downloading = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _updateHandle();
      },
      child: Stack(
        children: [
          Container(
            width: 190.w,
            height: 34.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34.r),
              color: Color(0xFFDCE1F4),
              gradient: _downloading
                  ? null
                  : LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, 1],
                      colors: [
                        Color(0xFF009FFA),
                        Color(0xFF0066F3),
                      ],
                    ),
            ),
          ),
          Positioned(
            left: 0,
            child: Opacity(
              opacity: 1,
              child: Container(
                width: 190.w * total,
                height: 34.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: (total > 0.95)
                      ? BorderRadius.circular(34.r)
                      : BorderRadius.only(
                          topLeft: Radius.circular(34.r),
                          bottomLeft: Radius.circular(34.r),
                        ),
                  gradient: _downloading
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.0, 1],
                          colors: [
                            Color(0xFF009FFA),
                            Color(0xFF0066F3),
                          ],
                        )
                      : null,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: Opacity(
              opacity: 1,
              child: Container(
                width: 190.w,
                height: 34.h,
                alignment: Alignment.center,
                child: WMSText(
                  content:
                      total == 0 ? '立即更新' : '正在更新(${(total * 100).toInt()}%)',
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _updateHandle() async {
    if (Platform.isIOS) {
      _launchURL(widget.downloadUrl);
      return;
    }

    if (!await Permission.storage.request().isGranted) {
      return;
    }
    if (mounted)
      setState(() {
        _downloading = true;
      });

    print('开始下载～～～${widget.downloadUrl}');

    OTAUtils.startOTA(widget.downloadUrl, (event) {
      if (event.status == OtaStatus.DOWNLOADING) {
        print(widget.downloadUrl + '下载');
        var progress = int.parse(event.value).toDouble();
        print(progress.toString());
        _downloading = true;
        total = progress / 100;
        if (total < 0.1) {
          total = 0.1;
        } else if (total > 0.9) {
          total = 1.0;
        }
        if (mounted) setState(() {});
      } else if (event.status == OtaStatus.DOWNLOAD_ERROR) {
        print(widget.downloadUrl + '下载错误====DOWNLOAD_ERROR');

        if (mounted)
          setState(() {
            _downloading = false;
            ToastUtil.showMessage(message: "更新失败");
          });
      } else if (event.status == OtaStatus.INTERNAL_ERROR) {
        ToastUtil.showMessage(message: "未知失败");
      } else if (event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
        print(widget.downloadUrl + '申请权限====PERMISSION_NOT_GRANTED_ERROR');
        ToastUtil.showMessage(message: "请打开权限");
      } else if (event.status == OtaStatus.INSTALLING) {
        print(widget.downloadUrl + '正在安装====INSTALLING');
        ToastUtil.showMessage(message: "正在安装");
      }
      setState(() {});
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    print('version dispose');
    _cancelToken.cancel();
    _cancelToken = null;
  }
}
