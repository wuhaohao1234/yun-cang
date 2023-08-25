import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:wms/utils/easy_loading_util.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:wms/models/ConfirmOut_model.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/models/mine/agent_model.dart';
import 'package:wms/models/address/area_model.dart';
import 'package:wms/models/market/chu_huo_shipment_normal_model.dart';
import 'package:wms/models/market/chu_huo_shipment_defect_model.dart';
import 'package:wms/models/address/city_model.dart';
import 'package:wms/models/storage/onsale_commodity_model.dart';
import 'package:wms/models/storage/cs_dck_model.dart';
import 'package:wms/models/cs_god_detail_model.dart';
import 'package:wms/models/storage/chuku_model.dart';
import 'package:wms/models/entrepot/ruku/en_rkd_detail_model.dart';
import 'package:wms/models/entrepot/sku/en_shangpin_model.dart';
import 'package:wms/models/entrepot/ruku/en_rkd_model.dart';
import 'package:wms/models/entrepot/en_wares_model.dart';
import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';
import 'package:wms/models/entrepot/ruku/en_ycd_detail_model.dart';
import 'package:wms/models/entrepot/ruku/en_ycd_model.dart';
import 'package:wms/models/storage/exception_list_detail_model.dart';
import 'package:wms/models/forSaleDetialList_model.dart';
import 'package:wms/models/getJiShiPrice_model.dart';
import 'package:wms/models/inventory_categorys_model.dart';
import 'package:wms/models/logistics_model.dart';
import 'package:wms/models/market/market_detail_model.dart';
import 'package:wms/models/market/market_wares_model.dart';
import 'package:wms/models/mine/mine_info_model.dart';
import 'package:wms/models/mine/card_model.dart';
import 'package:wms/models/mine/moneys_log_model.dart';
import 'package:wms/models/order/order_model.dart';
import 'package:wms/models/order/order_detail_model.dart';
import 'package:wms/models/oss_model.dart';
import 'package:wms/models/storage/perpare_order_model.dart';
import 'package:wms/models/address/country_model.dart';
import 'package:wms/models/address/province_model.dart';
import 'package:wms/models/select_exception_sku_send_back_model.dart';
import 'package:wms/models/size_qty_model.dart';
import 'package:wms/models/mine/user_info_model.dart';
import 'package:wms/models/entrepot/chuku/en_fenjian_model.dart';
import 'package:wms/models/version_model.dart';
import 'package:wms/models/mine/wallet_account_model.dart';
import 'package:wms/models/ware_house_model.dart';
import 'package:wms/models/storage/wzd_model.dart';
import 'package:wms/models/storage/ycj_model.dart';
import 'package:wms/network/error_entity.dart';
import 'package:wms/network/http_apis.dart';
import 'package:wms/network/http_manager.dart';
import 'package:wms/utils/image_util.dart';
import 'package:wms/configs/app_config.dart';
import 'package:wms/utils/toast_util.dart';

class HttpServices {
  // OSS签名
  static void requestOss(
      {String dir, Function(OssModel) success, Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'dir': dir,
    };
    HttpManager().request<OssModel>(HttpApis.oss,
        params: params, method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 图片上传
  static void upLoadImage(
      {OssModel model,
      File file,
      Function(String) success,
      Function(ErrorEntity) error}) async {
    file = await ImageUtil.compression(file);
    Dio dio = Dio();
    //dio的请求配置
    dio.options.responseType = ResponseType.json;
    dio.options.contentType = "multipart/form-data";
    //文件名
    String path = file.path;
    String chuo = DateTime.now().millisecondsSinceEpoch.toString() +
        path.substring(path.lastIndexOf('.'));
    String fileName = path.lastIndexOf('/') > -1
        ? path.substring(path.lastIndexOf('/') + 1)
        : path;
    //创建一个FormData，作为dio的参数
    FormData formData = FormData.fromMap({
      'chunk': '0',
      'OSSAccessKeyId': model.accessid,
      'policy': model.policy,
      'Signature': model.signature,
      'Expires': model.expire,
      'key': model.dir + chuo,
      'success_action_status': '200',
      'Access-Control-Allow-Origin': '*',
      'file': await MultipartFile.fromFile(path,
          filename: fileName, contentType: MediaType.parse('image/jpeg'))
    });

    print(formData);
    try {
      Response response = await dio.post(model.host, data: formData);
      print('response :' + response.toString());
      if (response.statusCode == 200) {
        String imgUrl = model.host + '/' + model.dir + chuo;
        success(imgUrl);
      } else {
        error(ErrorEntity(
            message: response.statusMessage, code: response.statusCode));
      }
    } on DioError catch (e) {
      error(ErrorEntity(
          message: e.response.statusMessage ?? '',
          code: e.response.statusCode));
      print("get uploadImage error: $e");
    }
  }

  // 图片上传
  static Future<String> asyncUpLoadImage({
    OssModel model,
    File file,
  }) async {
    file = await ImageUtil.compression(file);
    Dio dio = Dio();
    //dio的请求配置
    dio.options.responseType = ResponseType.json;
    dio.options.contentType = "multipart/form-data";
    //文件名
    String path = file.path;
    String chuo = DateTime.now().millisecondsSinceEpoch.toString() +
        path.substring(path.lastIndexOf('.'));
    String fileName = path.lastIndexOf('/') > -1
        ? path.substring(path.lastIndexOf('/') + 1)
        : path;
    //创建一个FormData，作为dio的参数
    FormData formData = FormData.fromMap({
      'chunk': '0',
      'OSSAccessKeyId': model.accessid,
      'policy': model.policy,
      'Signature': model.signature,
      'Expires': model.expire,
      'key': model.dir + chuo,
      'success_action_status': '200',
      'Access-Control-Allow-Origin': '*',
      'file': await MultipartFile.fromFile(path,
          filename: fileName, contentType: MediaType.parse('image/jpeg'))
    });

    print('formData = ' + formData.toString());
    try {
      Response response = await dio.post(model.host, data: formData);

      print('response 766 :' + response.toString());
      if (response.statusCode == 200) {
        String imgUrl = model.host + '/' + model.dir + chuo;
        return imgUrl;
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.message);
      return null;
    }
  }

  // 发送验证码
  /* type 1注册 2登陆 3重置密码 */
  static void requestSendVerificationCode(
      {String type,
      String mobile,
      Function() success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'type': type,
      'mobile': mobile,
    };
    print('start request send verification code');
    print(params.toString());
    HttpManager().request(HttpApis.sendVerificationCode,
        params: params, method: NWMethod.POST, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 异步获取验证码
  /* type 1注册 2登陆 3重置密码 */
  Future requestSendVerificationCodeAsync({
    String type,
    String mobile,
    Function() success,
  }) async {
    Completer completer = new Completer();

    Map<String, dynamic> params = {
      'type': type,
      'mobile': mobile,
    };
    print('start request send verification code');
    print(params.toString());
    HttpManager().request(HttpApis.sendVerificationCode,
        params: params, method: NWMethod.POST, success: (data) {
      print(data.toString());
      completer.complete(data);
    }, error: (e) {
      // error(e);
      completer.complete(e);
    });

    // Map<String, dynamic> params = {
    //   'uuid': uuid,
    //   'orderIdName': orderIdName,
    //   'commodityNumber': commodityNumber,
    // };
    // HttpManager().request(HttpApis.csUpdataCommodityNumber,
    //     params: params, method: NWMethod.POST, success: (data) {
    //   print('结果为${data.toString()}');
    //   completer.complete(data);
    // }, error: (e) {
    //   // error(e);
    //   print("$e");
    //   completer.complete(false);
    // });
    return completer.future;
  }

  // 查询验证码是否正确
  static void requestCheckVerificationCode(
      {String mobile,
      String code,
      Function() success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'mobile': mobile,
      'code': code,
    };
    HttpManager().request(HttpApis.checkVerificationCode,
        params: params, method: NWMethod.POST, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 修改用户信息接口
  static void modifyUserInfo(
      {Map<String, dynamic> params,
      String code,
      Function() success,
      Function(ErrorEntity) error}) {
    HttpManager().request(HttpApis.modifyUserInfo,
        params: params, method: NWMethod.PUT, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 重置密码
  static void resetPwd(
      {Map<String, dynamic> params,
      String code,
      Function() success,
      Function(ErrorEntity) error}) {
    HttpManager().request(HttpApis.resetPwd,
        params: params, method: NWMethod.POST, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 注册接口
  static void requestRegister(
      {num userType,
      String phoneNum,
      String password,
      String agentCode,
      String code,
      Function() success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'userType': userType,
      'phoneNum': phoneNum,
      'password': password,
      'agentCode': agentCode,
    };
    HttpManager().request(HttpApis.register,
        params: params, method: NWMethod.POST, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 登录接口
  /// loginType 登陆方式 1,手机号密码登陆 2,验证码登陆
  static void requestLogin(
      {String password,
      String phoneNum,
      int loginType,
      Function(Map<String, dynamic> data) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'password': password,
      'phoneNum': phoneNum,
      'loginType': loginType
    };
    HttpManager().request(HttpApis.login, params: params, method: NWMethod.POST,
        success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 获取用户信息
  static void requestGetUserInfo(
      {Function(UserInfoModel userInfoModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<UserInfoModel>(HttpApis.getUserInfo,
        method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 获取微信账号
  Future getWeChatAccount() async {
    Completer completer = new Completer();

    HttpManager().request(HttpApis.getWeChatAccount, method: NWMethod.GET,
        success: (data) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "result": true});
    }, error: (e) {
      print("$e");
      completer.complete({"data": e.message, "result": false});
    });
    return completer.future;
  }

  // 绑定微信账号
  Future getBindWeChat({
    String account,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'account': account,
    };
    HttpManager().request(HttpApis.getBindWeChat,
        params: params, method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "result": true});
    }, error: (e) {
      print("$e");
      completer.complete({"data": e.message, "result": false});
    });
    return completer.future;
  }

  // 预入库单详情

  Future prepareOrderDetailList({
    String orderId,
    String status,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'status': status,
    };
    HttpManager().request<PerpareOrderModel>(
        '${HttpApis.prepareOrderDetailList}/$orderId',
        params: params,
        method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 修改预约数量
  Future csUpdataCommodityNumber({
    String uuid,
    String orderIdName,
    int commodityNumber,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'uuid': uuid,
      'orderIdName': orderIdName,
      'commodityNumber': commodityNumber,
    };
    HttpManager().request(HttpApis.csUpdataCommodityNumber,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 客户端删除sku信息
  Future csDeleSku({
    String uuid,
    String orderIdName,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'uuid': uuid,
      'orderIdName': orderIdName,
    };
    HttpManager().request(HttpApis.csDeleSku,
        params: params, method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 查询店铺流水
  Future shopMoneysLog({
    num pageNum,
    num pageSize,
    String dateTime,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'date': dateTime,
    };
    HttpManager().requestList<MoneysLogModel>(HttpApis.shopMoneysLog,
        method: NWMethod.GET, params: params, success: (data, total) {
      print(data);
      print(total);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 查询账户余额
  static void walletAccount(
      {Function(WalletAccountModel) success, Function(ErrorEntity) error}) {
    HttpManager().request<WalletAccountModel>(HttpApis.walletAccount,
        method: NWMethod.GET, success: (data) {
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 查询仓储流水
  static void warehouseMoneysLog(
      {num pageNum,
      String pageSize,
      Function(List<MoneysLogModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': 10,
    };
    HttpManager().requestList<MoneysLogModel>(HttpApis.warehouseMoneysLog,
        params: params, method: NWMethod.GET, success: (data, total) {
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 提现
  Future withdrawal({
    int id,
    num money,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'id': id,
      'money': money,
    };
    HttpManager().request(HttpApis.withdrawal,
        method: NWMethod.POST, params: params, success: (data) {
      print(data);

      completer.complete(data);
    }, error: (e) {
      completer.complete({'result': false, 'data': e.message});
    });
    return completer.future;
  }

  // 客户端发布预约入库
  // static void releaseYbrk(
  //     {String mailNo,
  //     String skusTotal,
  //     String prepareImgUrl,
  //     String remark,
  //     String boxTotal,
  //     Function() success,
  //     Function(ErrorEntity) error}) {
  //   Map<String, dynamic> params = {
  //     'mailNo': mailNo,
  //     'skusTotal': skusTotal,
  //     'prepareImgUrl': prepareImgUrl,
  //     'remark': remark,
  //     'boxTotal': boxTotal,
  //   };
  //   HttpManager().request(HttpApis.addPrepareOrder,
  //       method: NWMethod.POST, params: params, success: (data) {
  //     print(data.toString());
  //     success();
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

  // 仓库端生成预约入库单
  static void enAddOrepareOrder(
      {String mailNo,
      String skusTotal,
      String prepareImgUrl,
      String remark,
      String customerCode,
      String boxTotal,
      Function() success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'mailNo': mailNo,
      'skusTotal': skusTotal,
      'prepareImgUrl': prepareImgUrl,
      'customerCode': customerCode,
      'remark': remark,
      'boxTotal': boxTotal,
    };
    HttpManager().request(HttpApis.enAddOrepareOrder,
        method: NWMethod.POST, params: params, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 新增收货地址
  /*
  * userName      收件人名称
  * userphone     收件人电话
  * province      省名称
  * city          市名称
  * area          区县名称
  * useraddress   详细地址
  * isdefault     是否默认地址 0：否 1：是
  * dataflag      有效状态 0：无效 1：有效
  * */

  static void addAddress(
      {String userName,
      String userPhone,
      String province,
      String city,
      String area,
      String userAddress,
      String cardJust,
      String cardBack,
      num isdefault,
      num dataflag,
      String cardNum,
      Function() success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'userName': userName,
      'userPhone': userPhone,
      'province': province,
      'city': city,
      'area': area,
      'userAddress': userAddress,
      'isdefault': isdefault,
      'dataflag': dataflag,
      'cardNum': cardNum,
      'cardJust': cardJust,
      'cardBack': cardBack,
    };
    HttpManager().request(HttpApis.addAddress,
        method: NWMethod.POST, params: params, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 修改地址
  static void editAddress(
      {num id,
      String userName,
      String userPhone,
      String province,
      String city,
      String area,
      String userAddress,
      num isdefault,
      num dataflag,
      String cardNum,
      String cardJust,
      String cardBack,
      Function() success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'id': id,
      'userName': userName,
      'userPhone': userPhone,
      'province': province,
      'city': city,
      'area': area,
      'userAddress': userAddress,
      'isdefault': isdefault,
      'dataflag': dataflag,
      'cardNum': cardNum,
      'cardJust': cardJust,
      'cardBack': cardBack,
    };
    HttpManager().request(HttpApis.editAddress,
        method: NWMethod.POST, params: params, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 获取收货地址列表

  static void getAddressList(
      {String pageNum,
      String pageSize,
      Function(List<AddressModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    HttpManager().requestList<AddressModel>(HttpApis.getAddressList,
        method: NWMethod.GET, params: params, success: (data, total) {
      print('datas = ' + data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 删除地址

  Future deleteAddress(
      {int id,
      Function(List<AddressModel>, num) success,
      Function(ErrorEntity) error}) {
    Completer completer = new Completer();
    HttpManager().request("${HttpApis.deleteAddress}/$id",
        method: NWMethod.DELETE, success: (data) {
      completer.complete(true);
    }, error: (e) {
      completer.complete(e);
    });
    return completer.future;
  }

  // 获取国家
  static void getProvinceList(
      {Function(List<ProvinceModel>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<ProvinceModel>(HttpApis.provinceList,
        method: NWMethod.POST, success: (data, total) {
      print('datas = ' + data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 获取省
  static void getCountryList(
      {Function(List<CountryModel>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<CountryModel>(HttpApis.countryList,
        method: NWMethod.GET, success: (data, total) {
      print('datas = ' + data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 获取市
  static void getCityList(
      {String provinceId,
      Function(List<CityModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'provinceId': provinceId,
    };
    HttpManager().requestList<CityModel>(HttpApis.cityList,
        method: NWMethod.POST, params: params, success: (data, total) {
      print('datas = ' + data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 获取区
  static void getAreaList(
      {String cityId,
      Function(List<AreaModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'cityId': cityId,
    };
    HttpManager().requestList<AreaModel>(HttpApis.areaList,
        method: NWMethod.POST, params: params, success: (data, total) {
      print('datas = ' + data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 仓库端开始

  /* ###################### 通用 ################################*/

  //仓库端订单数量completed
  Future enOrderCount() async {
    Completer completer = new Completer();
    HttpManager().request(HttpApis.enOrderCount, method: NWMethod.GET,
        success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

//查询待理货详情
  static void getTallyDetail(
      {num sysPrepareOrderId,
      Function(Map<String, dynamic>) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'sysPrepareOrderId': sysPrepareOrderId,
    };
    HttpManager().request(HttpApis.getTallyDetail,
        params: params, method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      print(data["wmsCommodityInfoVOList"].length);
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  /* ###################### 待收货 ################################*/

// 仓管APP人员签收有预约订单 completed
  static void enSignOrder(
      {num orderId,
      String boxTotalFact,
      String instoreOrderImg,
      Function(Map<String, dynamic>) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'orderId': orderId,
      'boxTotalFact': boxTotalFact,
      'instoreOrderImg': instoreOrderImg
    };
    HttpManager().request(HttpApis.enSignOrder,
        params: params, method: NWMethod.PUT, success: (data) {
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 仓管APP人员签收无预约订单
  static void enSignNoForecastOrder(
      {String mailNo,
      String customerCode,
      String boxTotalFact,
      String instoreOrderImg,
      int orderOperationalRequirements,
      Function(String results) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'mailNo': mailNo,
      'customerCode': customerCode,
      'boxTotalFact': boxTotalFact,
      'instoreOrderImg': instoreOrderImg,
      'orderOperationalRequirements': orderOperationalRequirements,
    };
    HttpManager().request(HttpApis.enSignNoForecastOrder,
        params: params, method: NWMethod.PUT, success: (data) {
      print('结果为${data.toString()}');
      // return data;
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  /* ###################### 待理货 ################################*/

  // 仓库端根据货号查询商品详情
  static void enSearchSkuList({
    String stockCode,
    num prepareOrderId,
    num pageNum = 1,
    Function(List<dynamic>, num) success,
    Function(ErrorEntity) error,
    pageSize = 1000,
  }) {
    Map<String, dynamic> params = {
      'stockCode': stockCode,
      'prepareOrderId': prepareOrderId,
      'pageSize': pageSize,
      'pageNum': pageNum
    };

    HttpManager().requestList(HttpApis.enSearchSkuByCode,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('搜索商品,参数: $params, 结果为${data.toString()}');
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

//仓库端扫码查询商品详情
  static void enSearchSkuByScan(
      {String skuCode,
      num prepareOrderId,
      Function(ENShangPingModel) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'skuCode': skuCode,
      'prepareOrderId': prepareOrderId,
    };

    HttpManager().request<ENShangPingModel>(HttpApis.enSearchSkuByScan,
        params: params, method: NWMethod.GET, success: (data) {
      // print('搜索商品,参数: $params, 结果为${data.toString()}');
      success(data);
    }, error: (e) {
      error(e);
    });
  }

// 仓库端查询商品详情
  static void getSPuDetail(
      {num spuId,
      num prepareOrderId,
      Function(Map<String, dynamic>) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'spuId': spuId,
      'prepareOrderId': prepareOrderId,
    };

    HttpManager().request(HttpApis.getSPuDetail,
        params: params, method: NWMethod.GET, success: (data) {
      // print('查询商品,参数: $params, 结果为${data.toString()}');
      success(data);
    }, error: (e) {
      error(e);
    });
  }

//理货中心sku中的sn信息

  static void getTallySpuDetails(
      {num skuId,
      String skuCode,
      Function(Map<String, dynamic>) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'skuId': skuId,
      'skuCode': skuCode,
    };

    HttpManager().request(HttpApis.getTallySpuDetails,
        params: params, method: NWMethod.GET, success: (data) {
      // print('查询商品,参数: $params, 结果为${data.toString()}');
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 仓管人员提交需要质检理货信息
  static void inspectionComplete(
      {num sysPrepareOrderId,
      List sysPrepareOrderSpuList,
      Function(Map<String, dynamic>) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'sysPrepareOrderId': sysPrepareOrderId,
      'sysPrepareOrderSpuList': sysPrepareOrderSpuList,
    };
    HttpManager().request(HttpApis.inspectionComplete,
        method: NWMethod.POST, params: params, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 仓管人员提交不需要质检理货信息
  static void noInspectionComplete(
      {num sysPrepareOrderId,
      List sysPrepareOrderSpuList,
      Function(Map<String, dynamic>) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'sysPrepareOrderId': sysPrepareOrderId,
      'sysPrepareOrderSpuList': sysPrepareOrderSpuList,
    };
    HttpManager().request(HttpApis.noInspectionComplete,
        method: NWMethod.POST, params: params, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  //理货完成
  static void tallysubmisssion(
      {Map<String, dynamic> params,
      Function(Map<String, dynamic>) success,
      Function(ErrorEntity) error}) {
    HttpManager().request(HttpApis.tallysubmisssion,
        params: params, method: NWMethod.POST, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 修改理货单的条形码和实际收货数量信息
  Future updateSpuInfo({
    Map<String, dynamic> params,
  }) async {
    Completer completer = new Completer();
    HttpManager().request(HttpApis.updateSpuInfo,
        method: NWMethod.POST, params: params, success: (data) {
      completer.complete(true);
    }, error: (e) {
      // 如果错误的话, 返回错误信息
      completer.complete(e);
    });
    return completer.future;
  }

  //删除Sku
  Future deleteSkuInfo({
    Map<String, dynamic> params,
  }) async {
    Completer completer = new Completer();
    HttpManager().request(HttpApis.deleteSkuInfo,
        method: NWMethod.POST, params: params, success: (data) {
      completer.complete(true);
    }, error: (e) {
      completer.complete(e);
    });
    return completer.future;
  }

  // 删除SN
  Future deleteSN({
    int id,
  }) async {
    Completer completer = new Completer();
    HttpManager().request("${HttpApis.deleteSn}/$id", method: NWMethod.DELETE,
        success: (data) {
      completer.complete(true);
    }, error: (e) {
      completer.complete(e);
    });
    return completer.future;
  }

  // 仓库端预入库单列表
  static void enPrepareOrderList(
      {String pageNum,
      String pageSize,
      String mailNo,
      Function(List<ENYbrkModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'mailNo': mailNo,
    };

    HttpManager().requestList<ENYbrkModel>(HttpApis.enPrepareOrderList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print(data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

// 仓管APP人员临存订单
  Future enTemporaryExistenceOrderList({
    int pageNum,
    int pageSize,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'status': '2',
    };
    HttpManager().requestList<ENYbrkModel>(
        HttpApis.enTemporaryExistenceOrderList,
        method: NWMethod.GET,
        params: params, success: (data, total) {
      print(data);
      print(total);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 仓管APP人员无主单订单
  Future enOwnerLessList({
    String mailNo: '',
    int pageNum,
    int pageSize,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'mailNo': mailNo,
    };
    HttpManager().requestList<ENYbrkModel>(HttpApis.enOwnerLessList,
        method: NWMethod.GET, params: params, success: (data, total) {
      print(data);
      print(total);
      completer.complete({
        'result': true,
        'data': {'data': data, 'total': total}
      });
    }, error: (e) {
      completer.complete({'result': false, 'data': e.message});
    });
    return completer.future;
  }

  // 仓库端无主单详情
  static void enOwnerLessDetail(
      {int id, Function(ENYbrkModel) success, Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'id': id,
    };
    HttpManager().request<ENYbrkModel>(HttpApis.enOwnerLessDetail,
        params: params, method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 仓库端预入库单详情
  static void enPrepareOrderDetail(
      {num orderId,
      Function(ENYbrkModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<ENYbrkModel>(
        '${HttpApis.enPrepareOrderDetail}/$orderId',
        method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  //查询待理货或待上架订单
  static void getselStayTally(
      {String pageNum,
      String pageSize,
      String status,
      String instoreOrderCode,
      String inspectionRequirement,
      Function(List<ENRkdModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'status': status,
      'instoreOrderCode': instoreOrderCode,
      'inspectionRequirement': inspectionRequirement
    };
    HttpManager().requestList<ENRkdModel>(HttpApis.getselStayTally,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('请求待理货列表,参数: $params, 结果为${data.toString()}');
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  Future getselStayTallyList({
    String pageNum,
    String pageSize,
    String instoreOrderCode,
    String status,
  }) async {
    Completer completer = new Completer();

    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'status': status,
      'instoreOrderCode': instoreOrderCode,
    };

    HttpManager().requestList<ENYbrkModel>(HttpApis.getselStayTally,
        method: NWMethod.GET, params: params, success: (data, total) {
      print('上架,参数为 $params 结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 仓管人员申请新品
  Future enAddNewOrder({
    Map<String, dynamic> orderInfo,
  }) async {
    Completer completer = new Completer();

    Map<String, dynamic> params = orderInfo;

    HttpManager().request(HttpApis.enAddNewOrder,
        method: NWMethod.POST, params: params, success: (data) {
      print('理货申请新品,参数为 $params 结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 上架
  Future tallyShelf(
      {num prepareOrderId,
      String customerCode,
      String batchDepotId,
      List<Map<String, dynamic>> depotIds}) async {
    Completer completer = new Completer();

    Map<String, dynamic> params = {
      'prepareOrderId': prepareOrderId.toString(),
      'depotPosition': batchDepotId,
      'userCode': customerCode,
      'wmsCommodityInfoVOList': depotIds
    };
    HttpManager().request(HttpApis.tallyShelf,
        method: NWMethod.POST, params: params, success: (data) {
      print('上架,参数为 $params 结果为${data.toString()}');
      completer.complete(true);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 判断仓位是否可用
  Future locationIsExist({
    String customerCode,
    String depotPosition,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'userCode': customerCode,
      'depotPosition': depotPosition,
    };
    print("检查 $params 是否库位可用");

    HttpManager().request(HttpApis.locationIsExist,
        method: NWMethod.GET, params: params, success: (data) {
      if (data != null) {
        print("检查 $data 是1111否库位可用");
        completer.complete({
          "result": data['avaiable'],
          "msg": data['msg'],
          "info": data['avaiable']
        });
      } else {
        completer.complete({"result": false, "info": '当前仓位已被绑定请输入其他仓位'});
        print("djdj");
      }
    }, error: (e) {
      // error(e);
      completer.complete({"result": false, "info": e.message});
      print("-----ssss$e");
    });
    return completer.future;
  }

  // 仓管人员申请新品时判断是否为新品completed
  Future entallyStockCode({
    String stockCode,
    String skuCode,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'stockCode': stockCode,
      'skuCode': skuCode,
    };
    print("检查 $params 是否新品");
    HttpManager().request(HttpApis.entallyStockCode,
        method: NWMethod.GET, params: params, success: (data) {
      completer.complete(data["avaiable"] == true);
    }, error: (e) {
      // error(e);
      print("data ${e}");
      ToastUtil.showMessage(message: e.message);
      print("$e");
    });
    return completer.future;
  }

  //查看分拣条数
  Future enSortingCount() async {
    Completer completer = new Completer();
    HttpManager().request(HttpApis.enSortingCount, method: NWMethod.GET,
        success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  // 分拣详情
  Future enSortingDetail({num outOrderId}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'outOrderId': outOrderId,
    };
    HttpManager().request(HttpApis.enSortingDetail,
        method: NWMethod.GET, params: params, success: (data) {
      print('请求拣货详情,$params , 结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  // static void enSortingCount(
  //     {Function(Map<String, dynamic>) success, Function(ErrorEntity) error}) {
  //   HttpManager().request(HttpApis.enSortingCount, method: NWMethod.GET,
  //       success: (data) {
  //     print('结果为${data.toString()}');
  //     // return data;
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }
  //查看分拣数据集合

  static void enSortingList(
      {int transportType,
      int pageNum,
      int pageSize,
      String outStoreName,
      Function(List<ENFenJianModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'transportType': transportType,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'outStoreName': outStoreName,
    };
    HttpManager().requestList<ENFenJianModel>(HttpApis.enSortingList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('请求参数: $params, 结果为${data.toString()}');
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  //查看待出库与已出库数量
  Future enQueryNumber({String monthOutTime}) async {
    Completer completer = new Completer();
    // Map<String, dynamic> params = {
    //   'monthOutTime': monthOutTime,
    // };
    HttpManager().request(HttpApis.enQueryNumber,
        // params: params,
        method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

//根据sku分拣商品
  static void enSortingSpu(
      {String skuCode,
      String outOrderId,
      String tenantUserCode,
      Function(ENFenJianModel) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'skuCode': skuCode,
      'outOrderId': outOrderId,
      'tenantUserCode': tenantUserCode,
    };

    HttpManager().request<ENFenJianModel>(HttpApis.enSortingSpu,
        params: params, method: NWMethod.GET, success: (data) {
      // print('搜索商品,参数: $params, 结果为${data.toString()}');
      success(data);
    }, error: (e) {
      error(e);
    });
  }

//根据snCode分拣商品
  static void enScanSnCode(
      {String snCode,
      String outOrderId,
      String tenantUserCode,
      Function(ENFenJianModel) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'snCode': snCode,
      'outOrderId': outOrderId,
      'tenantUserCode': tenantUserCode,
    };

    HttpManager().request<ENFenJianModel>(HttpApis.enScanSnCode,
        params: params, method: NWMethod.GET, success: (data) {
      // print('搜索商品,参数: $params, 结果为${data.toString()}');
      success(data);
    }, error: (e) {
      error(e);
    });
  }

//根据skuCode或者snCode分拣商品
  Future enSortingWithSkuOrSnCode({
    String code,
    num outOrderId,
  }) async {
    Map<String, dynamic> params = {
      'code': code,
      'outOrderId': outOrderId,
    };
    Completer completer = new Completer();

    HttpManager().request<ENFenJianModel>(HttpApis.sortSkuAndSn,
        params: params, method: NWMethod.GET, success: (data) {
      completer.complete(true);
    }, error: (e) {
      completer.complete(e);
    });

    return completer.future;
  }

//修改分拣商品数量
  Future enUpdSortingNumber({
    int skuId,
    int outOrderId,
    int sortingSkuNumber,
    String snCode,
    String tenantUserCode,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'skuId': skuId,
      'outOrderId': outOrderId,
      'sortingSkuNumber': sortingSkuNumber,
      'snCode': snCode,
      'tenantUserCode': tenantUserCode,
    };
    HttpManager().request(HttpApis.enUpdSortingNumber,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

//分拣完成
  Future enSortingCompleted(
      {int outOrderId,
      String outStoreName,
      String tenantUserCode,
      String consigneeName,
      String logisticsName,
      int spuNumber,
      int totalSku,
      int sortingSpuNumber,
      int sortingTotalSku}) async {
    Completer completer = new Completer();

    Map<String, dynamic> params = {
      'outOrderId': outOrderId,
      'outStoreName': outStoreName,
      'tenantUserCode': tenantUserCode,
      'consigneeName': consigneeName,
      'logisticsName': logisticsName,
      'spuNumber': spuNumber,
      'totalSku': totalSku,
      'sortingSpuNumber': sortingSpuNumber,
      'sortingTotalSku': sortingTotalSku,
    };
    HttpManager().request(HttpApis.enSortingCompleted,
        params: params, method: NWMethod.POST, success: (data) {
      completer.complete(true);
    }, error: (e) {
      completer.complete(false);
      print("$e");
    });
    return completer.future;
  }

//查看待出库数量

  Future enWillListx({
    int crossBorder,
    int pageNum,
    int pageSize,
    String outStoreName,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'crossBorder': crossBorder,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'outStoreName': outStoreName,
    };
    HttpManager().requestList(HttpApis.enWillList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  static void enWillList(
      {int crossBorder,
      int pageNum,
      int pageSize,
      String outStoreName,
      Function(List<dynamic>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'crossBorder': crossBorder,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'outStoreName': outStoreName,
    };
    HttpManager().requestList(HttpApis.enWillList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print(data);
      print('结果为${data.toString()}');
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  static void enAlreadyList(
      {int crossBorder,
      int pageNum,
      int pageSize,
      String outStoreName,
      Function(List<dynamic>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'crossBorder': crossBorder,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'outStoreName': outStoreName,
    };
    HttpManager().requestList(HttpApis.enAlreadyList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 根据 outStoreType 来获取 已出仓或者待出仓
  Future enWillOrAlreadyList({
    String outStoreType,
    int crossBorder,
    int pageNum,
    int pageSize,
    String outStoreName,
  }) async {
    Completer completer = new Completer();

    String endpoint;
    if (outStoreType == "will") {
      endpoint = HttpApis.enWillList;
      print("获取待出仓数据");
    } else if (outStoreType == "already") {
      endpoint = HttpApis.enAlreadyList;
      print("获取已出仓数据");
    }
    Map<String, dynamic> params = {
      'crossBorder': crossBorder,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'outStoreName': outStoreName,
    };
    HttpManager().requestList(endpoint, params: params, method: NWMethod.GET,
        success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  //修改出库单 自提
  Future enOutStorePickUp({
    int wmsOutStoreId,
    String pickUpCode,
    int skuTotal,
    String outSkuOrderImg,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'wmsOutStoreId': wmsOutStoreId,
      'pickUpCode': pickUpCode,
      'skuTotal': skuTotal,
    };
    HttpManager().request(HttpApis.enOutStore,
        params: params, method: NWMethod.PUT, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //修改出库单
  Future enOutStore({
    int wmsOutStoreId,
    int skuTotal,
    String outSkuOrderImg = '',
    String outOrderImg = '',
    String pickUpCode = '',
    String expressNumber = '',
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'wmsOutStoreId': wmsOutStoreId,
      'skuTotal': skuTotal,
      'outSkuOrderImg': outSkuOrderImg,
      'outOrderImg': outOrderImg,
      'pickUpCode': pickUpCode,
      'expressNumber': expressNumber,
    };
    HttpManager().request(HttpApis.enOutStore,
        params: params, method: NWMethod.PUT, success: (data) {
      print('结果为${data.toString()}');
      completer.complete({'result': true, 'data': data});
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete({'result': false, 'data': e.message});
    });
    return completer.future;
  }

  //修改出库单 快递
  Future enOutStoreExpress({
    int wmsOutStoreId,
    int skuTotal,
    String outOrderImg,
    String expressNumber,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'wmsOutStoreId': wmsOutStoreId,
      'skuTotal': skuTotal,
      'outOrderImg': outOrderImg,
      'expressNumber': expressNumber,
    };
    HttpManager().request(HttpApis.enOutStore,
        params: params, method: NWMethod.PUT, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 仓库端待理货列表old
  static void enInStoreOrderList(
      {String pageNum,
      String pageSize,
      String mailNo,
      Function(List<ENRkdModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'mailNo': mailNo,
      'status': '2',
    };
    // HttpManager().requestList<ENRkdModel>(HttpApis.enInStoreOrderList,
    HttpManager().requestList<ENRkdModel>(HttpApis.getselStayTally,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('请求待理货列表,参数: $params, 结果为${data.toString()}');
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 仓库端待理货详情 By Huzi
  static void enInStoreOrderDetail(
      {num sysPrepareOrderId,
      Function(ENRkdDetailModel) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'sysPrepareOrderId': sysPrepareOrderId,
    };
    HttpManager().request<ENRkdDetailModel>(HttpApis.getTallyDetail,
        params: params, method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 仓库端异常单列表
  static void enExceptionOrderList(
      {String pageNum,
      String pageSize,
      String mailNo,
      Function(List<ENYcdModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': 10,
      'mailNo': mailNo,
    };
    HttpManager().requestList<ENYcdModel>(HttpApis.enExceptionOrderList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print(data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 仓库端预异常单详情
  static void enExceptionListDetail(
      {String exceptionOrderId,
      Function(ENYcdDetailModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<ENYcdDetailModel>(
        '${HttpApis.enExceptionListDetail}/$exceptionOrderId',
        method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 仓管人员扫运单号查询预约入库单
  static void enQueryByMailNo(
      {String mailNo,
      Function(List<dynamic>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'mailNo': mailNo,
    };

    HttpManager().requestList<ENYbrkModel>(HttpApis.enQueryMail,
        params: params, method: NWMethod.GET, success: (data, total) {
      print("扫描待收货订单 ${data.toString()}");
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 仓管人员生成无主单
  static void enCreateWzd(
      {String mailNo,
      String ownerlessImg,
      num boxTotalFact,
      int orderOperationalRequirements,
      Function(Map<String, dynamic>) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'mailNo': mailNo,
      'ownerlessImg': ownerlessImg,
      'boxTotalFact': boxTotalFact,
      'orderOperationalRequirements': orderOperationalRequirements,
    };
    HttpManager().request(HttpApis.addOwnerLessSysPrepareOrder,
        params: params, method: NWMethod.POST, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 客户开始

  /* ###################### 通用 ################################*/

  // 查询仓库
  Future depotList({
    String status,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'status': status,
    };
    HttpManager().request(HttpApis.depotList,
        method: NWMethod.GET, params: params, success: (data) {
      print(data);
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 查询所有仓库
  Future prepareOrderDepotList() async {
    Completer completer = new Completer();
    HttpManager().request(HttpApis.prepareOrderDepotList, method: NWMethod.GET,
        success: (data) {
      print(data);
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 预入库单列表completed
  Future prepareOrderList({
    String pageNum,
    String pageSize,
    String date,
    String depotId,
    String mailNo,
    String status,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'date': date,
      'depotId': depotId,
      'mailNo': mailNo,
      'status': status,
    };
    HttpManager().requestList<PerpareOrderModel>(HttpApis.prepareOrderList,
        method: NWMethod.GET, params: params, success: (data, total) {
      print(data);
      print(total);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 客户端预约入库新增sku
  Future csAddSku({
    String orderIdName,
    List wmsSpuDetailList,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'orderIdName': orderIdName,
      'wmsSpuDetailList': wmsSpuDetailList,
    };
    HttpManager().request(HttpApis.csAddSku,
        method: NWMethod.POST, params: params, success: (data) {
      print(data);

      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 客户端查询sku
  Future csGetSku({
    String orderIdName,
    int pageNum = 0,
    int pageSize = 10,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'orderIdName': orderIdName,
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    HttpManager().requestList(HttpApis.csGetSku,
        method: NWMethod.GET, params: params, success: (data, total) {
      print(data);

      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 客户端修改预约入库单,进行发货
  Future updataPrepareOrder({
    int orderId,
    String mailNo,
    String status,
    String logisticsMode,
    String prepareImgUrl,
    int boxTotal,
    String remark,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'orderId': orderId,
      'mailNo': mailNo,
      'status': status,
      'logisticsMode': logisticsMode,
      'prepareImgUrl': prepareImgUrl,
      'boxTotal': boxTotal,
      'remark': remark,
    };
    HttpManager().request(HttpApis.updataPrepareOrder,
        method: NWMethod.POST, params: params, success: (data) {
      print(data);

      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 客户端修改预约入库单,改变物流单号
  Future updPrepareOrder({
    int orderId,
    String mailNo,
    String logisticsMode,
    String prepareImgUrl,
    int boxTotal,
    String remark,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'orderId': orderId,
      'mailNo': mailNo,
      'logisticsMode': logisticsMode,
      'prepareImgUrl': prepareImgUrl,
      'boxTotal': boxTotal,
      'remark': remark,
    };
    HttpManager().request(HttpApis.updPrepareOrder,
        method: NWMethod.POST, params: params, success: (data) {
      print(data);

      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 客户端新增预约入库单
  Future addPrepareOrder({
    int depotId,
    int orderOperationalRequirements,
    String orderIdName,
    String prepareImgUrl,
    String mailNo,
    String status,
    String logisticsMode,
    int boxTotal,
    String remark,
    String hairPhoneNumber,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'depotId': depotId,
      'orderOperationalRequirements': orderOperationalRequirements,
      'orderIdName': orderIdName,
      'mailNo': mailNo,
      'status': status,
      'logisticsMode': logisticsMode,
      'prepareImgUrl': prepareImgUrl,
      'hairPhoneNumber': hairPhoneNumber,
      'boxTotal': boxTotal,
      'remark': remark,
    };
    HttpManager().request(HttpApis.addPrepareOrder,
        method: NWMethod.POST, params: params, success: (data) {
      print(data);

      completer.complete({"data": data, 'result': true});
    }, error: (e) {
      completer.complete({"data": e.message, 'result': false});
    });
    return completer.future;
  }

  // 客户端查询异常单列表

  Future getExceptionOrderList({
    int pageNum,
    int pageSize,
    String date,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'date': date,
    };
    HttpManager().requestList<YcjModel>(HttpApis.getExceptionOrderList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  // 客户端-仓储模块-获取待出库列表
  Future getWillList({
    int pageNum,
    int pageSize,
    String outStoreName,
    String monthOutTime,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'outStoreName': outStoreName,
      'monthOutTime': monthOutTime,
    };
    HttpManager().requestList<ChuKuModel>(HttpApis.getWillList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  // 客户端获取已出库单列表

  Future getAlreadyList({
    int pageNum,
    int pageSize,
    String outStoreName,
    String monthOutTime,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'outStoreName': outStoreName,
      'monthOutTime': monthOutTime,
    };
    HttpManager().requestList<ChuKuModel>(HttpApis.getAlreadyList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  // 客户端获取商品列表

  Future getSpuSkuList({
    int pageNum,
    int pageSize,
    String spuName,
    String skuCode,
    String orderIdName,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'spuName': spuName,
      'skuCode': skuCode,
      'orderIdName': orderIdName,
    };
    print("搜索商品: $params");
    HttpManager().requestList(HttpApis.getSpuSkuList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 查询仓库
  Future getDepotTagList() async {
    Completer completer = new Completer();

    HttpManager().requestList(HttpApis.getDepotTagList, method: NWMethod.GET,
        success: (data, total) {
      print(data);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 查询品类
  Future getCategoryList({int depotId}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'depotId': depotId,
    };
    HttpManager().requestList(HttpApis.getCategoryList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print(data);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  //所有一级品类
  Future getFirstCategorys() async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {};
    HttpManager().requestList(HttpApis.getFirstCategorys,
        params: params, method: NWMethod.GET, success: (data, total) {
      print(data);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 正常件单品出售
  Future postSpuNormalShelf({List reqArray}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'reqArray': reqArray,
    };
    HttpManager().requestList(HttpApis.postSpuNormalShelf,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data);
      completer.complete(data);
    }, error: (e) {
      completer.complete(e);
    });
    return completer.future;
  }

  // 瑕疵件单品出售
  Future postSpuDefectShelf({List reqArray}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'reqArray': reqArray,
    };
    HttpManager().requestList(HttpApis.postSpuDefectShelf,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data);
      completer.complete(data);
    }, error: (e) {
      completer.complete(e);
    });
    return completer.future;
  }

  // 查询商品列表
  Future getSpuList({
    Map condition,
    int categoryId,
    int depotId,
    String searchContent,
    int status,
    int pageNum,
    int pageSize,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'condition': {
        'categoryId': categoryId,
        'depotId': depotId,
        'searchContent': searchContent,
        'status': status
      },
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    HttpManager().requestList(HttpApis.getSpuList,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 查询正常商品点击出售的详情
  Future spuShelfNormalDetail({
    int spuId,
    int depotId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'spuId': spuId,
      'depotId': depotId,
    };
    HttpManager().requestList(HttpApis.spuShelfNormalDetail,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data);
      completer.complete({'data': data, 'total': total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 查询瑕疵商品点击出售的详情
  Future spuShelfDefectDetail({
    int spuId,
    int depotId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'spuId': spuId,
      'depotId': depotId,
    };
    HttpManager().requestList(HttpApis.spuShelfDefectDetail,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data);
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 查询瑕疵商品的列表
  Future spuShelfDefect({
    List condition,
    int pageNum,
    int pageSize,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'condition': condition,
      'pageNum': pageNum,
      'pageSize': pageSize
    };
    HttpManager().requestList(HttpApis.spuShelfDefect,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data);
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 客户端无主单列表completed
  Future csWzjList({
    String pageNum,
    String pageSize,
    String date,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'date': date,
    };
    HttpManager().requestList<WzdModel>(HttpApis.csWzjList,
        method: NWMethod.GET, params: params, success: (data, total) {
      print(data);
      print(total);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 无主单详情
  static void wzdDetail(
      {int id, Function(WzdModel model) success, Function(ErrorEntity) error}) {
    HttpManager().request<WzdModel>('${HttpApis.wzjDetail}/$id',
        method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 查询集市商品详情
  Future csMarketInfo({
    String spuId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'spuId': spuId,
    };
    HttpManager().request<MarketWaresModel>('${HttpApis.csMarketInfo}/$spuId',
        params: params, method: NWMethod.GET, success: (data) {
      print(data);
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端库存正常件spu尺码详情
  Future csPostOutStoreNormalSize({
    int spuId,
    int depotId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'depotId': depotId,
      'spuId': spuId,
    };
    HttpManager().requestList(HttpApis.csPostOutStoreNormalSize,
        params: params, method: NWMethod.POST, success: (data, total) {
      print('结果为${data.toString()}');
      print(data);
      completer.complete({"data": data, "total": total, "result": true});
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete({'result': false, 'data': e});
    });
    return completer.future;
  }

  //客户端库存瑕疵spu尺码详情
  Future csPostOutStoreDefectSize({
    int spuId,
    int depotId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'depotId': depotId,
      'spuId': spuId,
    };
    HttpManager().requestList(HttpApis.csPostOutStoreDefectSize,
        params: params, method: NWMethod.POST, success: (data, total) {
      print('结果为${data.toString()}');
      print(data);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 查询瑕疵商品的列表
  Future csPostOutStoreDefectSizeList({
    List condition,
    int pageNum,
    int pageSize,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'condition': condition,
      'pageNum': pageNum,
      'pageSize': pageSize
    };
    HttpManager().requestList(HttpApis.csPostOutStoreDefectSizeList,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端库存手动出库
  Future csPostOutStore({
    int distributionId,
    int depotId,
    int addressId,
    String logisticsName,
    List skuOrderList,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'distributionId': distributionId,
      'logisticsName': logisticsName,
      'depotId': depotId,
      'addressId': addressId,
      'skuOrderList': skuOrderList,
    };
    HttpManager().request(HttpApis.csPostOutStore,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete({'result': true, 'data': data});
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete({'result': false, 'data': e.message});
    });
    return completer.future;
  }

//客户端自主仓订单
  Future newsOrderList({
    int pageNum,
    int pageSize,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    HttpManager().requestList(HttpApis.newsOrderList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

//客户端自主仓订单详情
  Future newsOrderDetail({
    int id,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {'id': id};
    HttpManager().request('${HttpApis.newsOrderDetail}/$id',
        params: params, method: NWMethod.GET, success: (data) {
      print(data);
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端自主仓订单取消
  Future updNewsOrder({
    int id,
    String orderReview,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {'id': id, 'orderReview': orderReview};
    HttpManager().request(HttpApis.updNewsOrder,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      completer.complete(false);
      print("$e");
    });
    return completer.future;
  }

  // 用户申请新品
  Future csAddNewOrder({
    Map<String, dynamic> orderInfo,
  }) async {
    Completer completer = new Completer();

    Map<String, dynamic> params = orderInfo;

    HttpManager().request(HttpApis.csAddNewOrder,
        method: NWMethod.POST, params: params, success: (data) {
      print('上架,参数为 $params 结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 自主仓生成入库单
  Future addVirtualOrder(
      {String defectDegree, List skuList, int sourcePlace, int status}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'defectDegree': defectDegree,
      'skuList': skuList,
      'sourcePlace': sourcePlace,
      'status': status,
    };
    HttpManager().request(HttpApis.addVirtualOrder,
        method: NWMethod.POST, params: params, success: (data) {
      print('上架,参数为 $params 结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 自主仓申请新品
  Future addVirtualSku({
    Map<String, dynamic> orderInfo,
  }) async {
    Completer completer = new Completer();

    Map<String, dynamic> params = orderInfo;

    HttpManager().request(HttpApis.addVirtualSku,
        method: NWMethod.POST, params: params, success: (data) {
      print('自主仓申请新品,参数为 $params 结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端临存订单
  Future csTemporaryExistenceList({
    int pageNum,
    int pageSize,
    String orderName,
    int status,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'orderName': orderName,
      'status': status,
    };
    HttpManager().requestList<PerpareOrderModel>(
        HttpApis.csTemporaryExistenceList,
        params: params,
        method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  // 客户端获取临存出库单详情

  Future csTemporaryExistenceListDetail({
    int prepareOrderId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'prepareOrderId': prepareOrderId,
    };
    HttpManager().request<CsChuKuModel>(
        '${HttpApis.csTemporaryExistenceListDetail}/$prepareOrderId',
        params: params,
        method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

//客户端添加临存出库单
  Future csAddOutStore(
      {int distributionId,
      int prepareOrderId,
      String consigneeName,
      String consigneePhone,
      String consigneeDistrict,
      String consigneeProvince,
      String consigneeCity,
      String consigneeAddress}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'distributionId': distributionId,
      'prepareOrderId': prepareOrderId,
      'consigneeName': consigneeName,
      'consigneePhone': consigneePhone,
      'consigneeDistrict': consigneeDistrict,
      'consigneeProvince': consigneeProvince,
      'consigneeCity': consigneeCity,
      'consigneeAddress': consigneeAddress
    };
    HttpManager().requestList(HttpApis.csAddOutStore,
        params: params, method: NWMethod.POST, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      completer.complete(e);
    });
    return completer.future;
  }

  // 客户端获取待出库详情
  Future csOutStoreDetail({
    String wmsOutStoreId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'wmsOutStoreId': wmsOutStoreId,
    };
    HttpManager().request<CsChuKuModel>(
        '${HttpApis.csOutStoreDetail}/$wmsOutStoreId',
        params: params,
        method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 客户端获取已出库详情
  Future csAlreadyDetail({
    String wmsOutStoreId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'wmsOutStoreId': wmsOutStoreId,
    };
    HttpManager().request<CsChuKuModel>(
        '${HttpApis.csAlreadyDetail}/$wmsOutStoreId',
        params: params,
        method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  // 客户端认领无主单
  static void userClaimOwnerLessSysPrepareOrder(
      {int id,
      String lastFourCode,
      Function(bool) success,
      Function(ErrorEntity) error}) {
    HttpManager().request(HttpApis.userClaimOwnerLessSysPrepareOrder,
        params: {'id': id, 'lastFourCode': lastFourCode},
        method: NWMethod.POST, success: (data) {
      success(true);
    }, error: (e) {
      error(e);
    });
  }

  //客户端集市商品列表
  Future csGetMarketSpuList(
      {String searchContent,
      int status,
      int pageSize,
      int pageNum,
      dynamic categoryId}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'status': status,
      'searchContent': searchContent,
      'pageSize': pageSize,
      'pageNum': pageNum,
      'categoryId': categoryId
    };
    HttpManager().requestList<MarketWaresModel>(HttpApis.csGetMarketSpuList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total, 'result': true});
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete({"data": e.message, 'result': false});
    });
    return completer.future;
  }

  //客户端集市商品详情
  Future csGetMarketSpuSize({
    int spuId,
    int status,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'status': status,
      'spuId': spuId,
    };
    HttpManager().request(HttpApis.csGetMarketSpuSize,
        params: params, method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      print(data);
      completer.complete(MarketDetailModel.fromJson(data));
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端集市正常商品出货列表
  Future csGetChuHuoNormalList({
    int spuId,
    String storeIdStr,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'storeIdStr': storeIdStr,
      'spuId': spuId,
    };
    HttpManager().requestList<ChuHuoShipmentNormalModel>(
        HttpApis.csGetChuHuoNormalList,
        params: params,
        method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      print(data);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端集市正常商品出货列表
  Future csGetChuHuoDefectList({
    int spuId,
    String storeIdStr,
    int pageSize,
    int pageNum,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'storeIdStr': storeIdStr,
      'spuId': spuId,
      'pageSize': pageSize,
      'pageNum': pageNum,
    };
    HttpManager().requestList<ChuHuoShipmentDefectModel>(
        HttpApis.csGetChuHuoDefectList,
        params: params,
        method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      print(data);
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端集市提交订单
  Future csMarketResale({
    List storeStrList,
    int spuId,
    num resalePrice,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'storeStrList': storeStrList,
      'spuId': spuId,
      'resalePrice': resalePrice
    };
    HttpManager().request(HttpApis.csMarketResale,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端我的在售商品列表
  Future csOnSaleList(
      {int type, int pageSize, int pageNum, String searchStr}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'type': type,
      'pageSize': pageSize,
      'pageNum': pageNum,
      'searchStr': searchStr
    };
    HttpManager().requestList<OnSaleCommodityModel>(HttpApis.csOnSaleList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端下架转售商品
  Future csOffShelf({
    String stringStoreIds,
    int type, //1小程序 2集市3转售
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'stringStoreIds': stringStoreIds,
      'type': type,
    };
    HttpManager().request(HttpApis.csOffShelf,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端在售详情
  Future csOnSaleDetail({
    int depotId,
    int type, //1小程序 2集市3转售
    int status,
    int spuId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'depotId': depotId,
      'type': type,
      'status': status,
      'spuId': spuId
    };
    HttpManager().request(HttpApis.csOnSaleDetail,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端下架单品
  Future csOnSaleOffSeparate({
    int priceId,
    int type, //1小程序 2集市3转售
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'priceId': priceId,
      'type': type,
    };
    HttpManager().request(HttpApis.csOnSaleOffSeparate,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端下架单品
  Future csOnSaleAdjustPrice(
      {int priceId,
      int type, //1小程序 2集市3转售
      String price,
      int skuCount}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'priceId': priceId,
      'type': type,
      'price': price,
      'skuCount': skuCount
    };
    HttpManager().request(HttpApis.csOnSaleAdjustPrice,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //客户端集市计算税费
  Future csMarketOrderTaxFee({
    int addressId,
    int depotId,
    List skuOrderList,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'addressId': addressId,
      'depotId': depotId,
      'skuOrderList': skuOrderList,
    };
    HttpManager().request(HttpApis.csMarketOrderTaxFee,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(e);
    });
    return completer.future;
  }

  //客户端集市提交订单
  Future csMarketOrderAdd({
    int addressId,
    int depotId,
    String userCode,
    String payChannel,
    String openId,
    String notes,
    List skuOrderList,
    String picturePath,
    // String size,
    // bool resaleGoods=false,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'addressId': addressId,
      'depotId': depotId,
      'userCode': userCode,
      'payChannel': payChannel,
      'openId': openId,
      'notes': notes,
      'skuOrderList': skuOrderList,
      'picturePath': picturePath,
      // 'size':size,
      // 'resaleGoods':resaleGoods,
    };
    HttpManager().request(HttpApis.csMarketOrderAdd,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 提交跨境实名信息
  Future perfectInfo({
    int id,
    String userName,
    String cardNum,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'id': id,
      'userName': userName,
      'cardNum': cardNum,
    };
    HttpManager().request(HttpApis.perfectInfo,
        params: params, method: NWMethod.POST, success: (data) {
      print(data);
      completer.complete({'result': true, 'data': data});
    }, error: (e) {
      completer.complete({'result': false, 'data': e.message});
    });
    return completer.future;
  }

  // 查询订单详情
  static void businessOrder(
      {String query,
      Function(OrderDetailModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<OrderDetailModel>('${HttpApis.businessOrder}/$query',
        method: NWMethod.GET, success: (data) {
      // print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 确认收货
  static void postOrderReceived(
      {int orderId,
      Function(OrderDetailModel) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'orderId': orderId,
    };
    HttpManager().request<OrderDetailModel>(HttpApis.postOrderReceived,
        params: params, method: NWMethod.POST, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // Future postOrderReceived({
  //   int orderId,
  // }) async {
  //   Completer completer = new Completer();
  //   Map<String, dynamic> params = {
  //     'orderId': orderId,
  //   };
  //   HttpManager().request(HttpApis.postOrderReceived,
  //       params: params, method: NWMethod.POST, success: (data) {
  //     print('结果为${data.toString()}');
  //     completer.complete({"data": data, 'result': true});
  //   }, error: (e) {
  //     print("$e");
  //     completer.complete({"data": e.message, 'result': false});
  //   });
  //   return completer.future;
  // }

  //查看银行卡列表
  Future getCardList() async {
    Completer completer = new Completer();
    HttpManager().requestList<CardModel>(HttpApis.getCardList,
        method: NWMethod.GET, success: (data, total) {
      print('结果为${data.toString()}');
      completer.complete({"data": data, "total": total});
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  //查看银行卡详情
  Future getCardDetail({int id}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'id': id,
    };
    HttpManager().request<CardModel>('HttpApis.getCardDetail/$id',
        params: params, method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
    });
    return completer.future;
  }

  //添加银行卡
  Future addCard({
    Map postCardInfo,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = postCardInfo;
    HttpManager().request<CardModel>(HttpApis.addCard,
        params: params, method: NWMethod.POST, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  //添加银行卡
  Future editCard({
    Map postCardInfo,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = postCardInfo;

    HttpManager().request<CardModel>(HttpApis.editCard,
        params: params, method: NWMethod.PUT, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 仓管人员查询商品详情
  static void enPrepareSkuDetail(
      {num id, Function(ENWaresModel) success, Function(ErrorEntity) error}) {
    HttpManager().request<ENWaresModel>('${HttpApis.enPrepareSkuDetail}/$id',
        method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 仓管人员查询商品详情
  //      "orderId": 1, //预入库单号
  //     "barCode": "iiiiiiiiiiii", //条形码
  //     "skuCode": "greeyreytert", //sku码
  //     "itemImg": "oooooooo.jpg", //货号图片
  //     "imgUrl": "ppppppppp.jpg", //商品图片
  //     "status": "1" //状态(0：正常 1：瑕疵)
  static void enAddSku(
      {String orderId,
      String barCode,
      String skuCode,
      String itemImg,
      String imgUrl,
      String status,
      Function() success,
      Function(ErrorEntity) error}) {
    Map<String, String> param = {
      'orderId': orderId,
      'barCode': barCode,
      'skuCode': skuCode,
      'itemImg': itemImg,
      'imgUrl': imgUrl,
      'status': status,
    };

    HttpManager().request(HttpApis.enAddSku,
        params: param, method: NWMethod.POST, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 查询今日仓储情况
  static void warehouseNum({
    Function(WareHouseModel) success,
    Function(ErrorEntity) error,
  }) {
    HttpManager().request<WareHouseModel>(HttpApis.warehouseNum,
        method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 客户端仓储模块库存页面类别
  // 获取库存列表品类标签信息
  static void getInventoryCategorys(
      {Function(List<InventoryCategorysModel>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<InventoryCategorysModel>(
        HttpApis.getInventoryCategorys,
        method: NWMethod.GET, success: (data, tatol) {
      print(data.toString());
      success(data, tatol);
    }, error: (e) {
      error(e);
    });
  }

  // 客户端仓储模块库存页面类别
  // 获取库存列表品类标签信息
  static void getInventoryList(
      {int pageNum,
      int pageSize,
      String searchValue,
      int categoryId,
      Function(List<MarketWaresModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    if (searchValue != null) {
      params['searchValue'] = searchValue;
    }
    if (categoryId != null) {
      params['categoryId'] = categoryId;
    }

    HttpManager().requestList<MarketWaresModel>(HttpApis.getInventoryList,
        params: params, method: NWMethod.GET, success: (data, total) {
      print(data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  static void getOrderlist(
      {int orderType,
      String orderStatus,
      Function(List<OrderModel>, num) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'orderType': orderType,
      'orderStatus': orderStatus,
    };
    // if (orderStatus != null) {
    //   params['orderStatus'] = orderStatus;
    // }
    HttpManager().requestList<OrderModel>(HttpApis.getOrderlist,
        params: params, method: NWMethod.GET, success: (data, total) {
      print(data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  //订单 清关重推
  Future getToBC({
    String orderId,
  }) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      'orderId': orderId,
    };
    HttpManager().request('${HttpApis.getToBC}/$orderId',
        params: params, method: NWMethod.GET, success: (data) {
      print('结果为${data.toString()}');
      completer.complete(data);
    }, error: (e) {
      // error(e);
      print("$e");
      completer.complete(false);
    });
    return completer.future;
  }

  // 客户端-集市-设置在售单品集市价格
  static void setSaleSkuAppPrice(
      {int skuId,
      num appPrice,
      int orderStatus,
      Function() success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'skuId': skuId,
      'appPrice': appPrice,
    };

    HttpManager().requestList<OrderModel>(HttpApis.setSaleSkuAppPrice,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 客户端-集市-设置在售单品得物价格
  static void setSaleSkuDWPrice(
      {int skuId,
      num dwPrice,
      int orderStatus,
      Function() success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'skuId': skuId,
      'dwPrice': dwPrice,
    };

    HttpManager().requestList<OrderModel>(HttpApis.setSaleSkuDWPrice,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 修改在售商品app的价格
  static void editForeSaleSku(
      {int id, num appPrice, Function() success, Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'id': id,
      'appPrice': appPrice,
    };

    HttpManager().requestList<OrderModel>(HttpApis.editForeSaleSku,
        params: params, method: NWMethod.PUT, success: (data, total) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 仓管人员提交入库单
  static void commitSku(
      {int orderId, Function() success, Function(ErrorEntity) error}) {
    HttpManager().requestList<OrderModel>(HttpApis.commitSku + '/$orderId',
        method: NWMethod.GET, success: (data, total) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // 物流轨迹查询(非etk和港澳本地)
  static void logistics(
      {String dataCode,
      Function(LogisticsModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<LogisticsModel>(HttpApis.logistics + '/$dataCode',
        method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 客户端查询入库单详情
  static void csInStoreOrderDetail(
      {String instoreOrderId,
      Function(ENRkdDetailModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<ENRkdDetailModel>(
        '${HttpApis.csInStoreOrderDetail}/$instoreOrderId',
        method: NWMethod.GET, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // WV 订单支付
  static void payMoneys(
      {int orderId,
      String payPassword,
      String moneyType,
      Function(dynamic) success,
      Function(ErrorEntity) error}) {
    Map<String, dynamic> params = {
      'orderId': orderId,
      'payPassword': payPassword,
      'moneyType': moneyType
    };

    HttpManager().requestList<dynamic>(HttpApis.payMoneys,
        params: params, method: NWMethod.POST, success: (data, total) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // WV 手动选择页面获取选择尺码标签
  static void sizeQty(
      {String query,
      Function(List<SizeQtyModel>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<SizeQtyModel>('${HttpApis.sizeQty}/$query',
        method: NWMethod.GET, success: (data, total) {
      print(data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // WV 手动选择页面选择商品列表
  static void sizeInventory(
      {String query,
      Function(List<MarketWaresModel>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<MarketWaresModel>(
        '${HttpApis.sizeInventory}/$query',
        method: NWMethod.GET, success: (data, total) {
      print(data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 商品上架可售
  static void addForSale(
      {Map<String, dynamic> params,
      Function() success,
      Function(ErrorEntity) error}) {
    HttpManager().request(HttpApis.addForSale,
        params: params, method: NWMethod.PUT, success: (data) {
      print(data.toString());
      success();
    }, error: (e) {
      error(e);
    });
  }

  // WV 订单支付
  static void outStore(
      {Map<String, dynamic> params,
      Function(dynamic) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<dynamic>(HttpApis.outStore,
        params: params, method: NWMethod.POST, success: (data) {
      print(data.toString());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // WV 查询异常单详情
  static void exceptionListDetail(
      {String query,
      Function(ExceptionListDetailModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<ExceptionListDetailModel>(
        '${HttpApis.exceptionListDetail}/$query',
        method: NWMethod.GET, success: (data) {
      print(data.toJson());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // WV 选择瑕疵瑕商品
  static void selectExceptionSkuSendBack(
      {Map<String, dynamic> params,
      Function(List<SelectExceptionSkuSendBack>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<SelectExceptionSkuSendBack>(
      HttpApis.selectExceptionSkuSendBack,
      params: params,
      method: NWMethod.POST,
      success: (data, total) {
        success(data, total);
      },
      error: (e) {
        error(e);
      },
    );
  }

  // WV 客户端app瑕疵件退回
  static void exceptionSkuSendBackAndCommit(
      {Map<String, dynamic> params,
      Function(dynamic) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<dynamic>(HttpApis.exceptionSkuSendBackAndCommit,
        params: params, method: NWMethod.POST, success: (data) {
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // WV 查询商品详情
  static void prepareSkuDetail(
      {String query,
      Function(CSGodDetailModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<CSGodDetailModel>(
        '${HttpApis.prepareSkuDetail}/$query',
        method: NWMethod.GET, success: (data) {
      print(data.toJson());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // WV 订单生成出库单（一件配发）
  static void outOrderExpress(
      {Map<String, dynamic> params,
      Function(dynamic) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<dynamic>(HttpApis.outOrderExpress,
        params: params, method: NWMethod.POST, success: (data) {
      // print(data.toJson());
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // WV 查询集市价格表
  static void getJiShiPrice(
      {Map<String, dynamic> params,
      Function(List<GetJiShiPriceModel>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<GetJiShiPriceModel>(HttpApis.getJiShiPrice,
        params: params, method: NWMethod.GET, success: (data, total) {
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // WV 查看在售列表
  static void forSaleDetialList(
      {String query,
      Function(List<ForSaleDetialListModel>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<ForSaleDetialListModel>(
        '${HttpApis.forSaleDetialList}/$query',
        method: NWMethod.GET, success: (data, total) {
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // WV 获取出仓物品清单
  static void confirmOut(
      {Map<String, dynamic> params,
      Function(List<ConfirmOutModel>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<ConfirmOutModel>(HttpApis.confirmOut,
        params: params, method: NWMethod.POST, success: (data, total) {
      // print('-------' + data.toString());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // 仓管人员上传照片（快递面单/货单）
  static void editPrepareOrder(
      {String orderId,
      String instoreOrderImg,
      Function(bool) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<dynamic>(HttpApis.editPrepareOrder,
        params: {'orderId': orderId, 'instoreOrderImg': instoreOrderImg},
        method: NWMethod.PUT, success: (data, total) {
      success(true);
    }, error: (e) {
      error(e);
    });
  }

  // WV 获取出仓物品清单
  static void commitForSaleSku(
      {Map<String, dynamic> params,
      Function(List<ConfirmOutModel>, num) success,
      Function(ErrorEntity) error}) {
    HttpManager().requestList<ConfirmOutModel>(HttpApis.commitForSaleSku,
        params: params, method: NWMethod.POST, success: (data, total) {
      // print(data.toJson());
      success(data, total);
    }, error: (e) {
      error(e);
    });
  }

  // WV 获取出仓物品清单
  static void getEtk(
      {Map<String, dynamic> params,
      Function(int) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<int>(HttpApis.getEtk,
        params: params, method: NWMethod.GET, success: (data) {
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // WV 手机端修改订单
  static void businessOrde(
      {Map<String, dynamic> params,
      String code,
      Function() success,
      Function(ErrorEntity) error}) {
    HttpManager().request(HttpApis.businessOrder,
        params: params, method: NWMethod.PUT, success: (data) {
      success();
    }, error: (e) {
      error(e);
    });
  }

  // WV 手机端修改订单
  static void upDateVersion(
      {String platform,
      Function(VersionModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<VersionModel>(HttpApis.upDateVersion + '/' + platform,
        method: NWMethod.GET, success: (data) {
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 获取得物最低价
  static void dwzdj(
      {String skuId, Function(String) success, Function(ErrorEntity) error}) {
    HttpManager().request(HttpApis.dwzdj,
        params: {'skuId': skuId}, method: NWMethod.GET, success: (data) {
      print('得物最低价respond:${data.toString()}');
      String value;
      if (data != null) {
        List items = data['items'];
        if (items != null) {
          items.forEach((element) {
            if (element['bidding_type'] == '3') {
              value = element['lowest_price'];
              return;
            }
          });
        }
      }
      success(value);
    }, error: (e) {
      error(e);
    });
  }

  // 获取固定用户信息详细信息
  static void mineInfo(
      {String skuId,
      Function(MineInfoModel) success,
      Function(ErrorEntity) error}) {
    HttpManager().request<MineInfoModel>(HttpApis.mineInfo,
        method: NWMethod.GET, success: (data) {
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 获取运营商列表
  // static void getAgentList(
  //     {Function(List<AgentModel>) success, Function(ErrorEntity) error}) {
  //   HttpManager().requestList<AgentModel>(HttpApis.getAgentList,
  //       params: {}, method: NWMethod.GET, success: (data, total) {
  //     success(data);
  //   }, error: (e) {
  //     error(e);
  //   });
  // }

  Future getAgentListNew() async {
    Completer completer = new Completer();

    HttpManager().requestList<AgentModel>(HttpApis.getAgentList,
        method: NWMethod.GET, success: (data, total) {
      print(data);
      completer.complete(data);
    }, error: (e) {
      completer.complete(false);
    });
    return completer.future;
  }

  // 切换运营商
  static void changeAgent(
      {int agentId, Function(Map) success, Function(ErrorEntity) error}) {
    HttpManager().request('${HttpApis.changeAgent}/$agentId',
        method: NWMethod.GET, success: (data) {
      print('切换成:${data['token']}');
      Map<String, dynamic> map = new Map();
      map['token'] = data['token'];
      map['agentName'] = data['agentName'];

      success(map);
    }, error: (e) {
      error(e);
    });
  }

//  添加运营商
  static void addAgent(
      {Map<String, dynamic> params,
      Function(int) success,
      Function(ErrorEntity) error}) {
    HttpManager().request(HttpApis.addAgent,
        params: params, method: NWMethod.POST, success: (data) {
      // print('tianjia:${data['token']}');
      // Map<String,dynamic> map = new Map();
      // map['agentName']=data['agentId'];
      success(data);
    }, error: (e) {
      error(e);
    });
  }

  // 测试支付->提交支付信息
  Future submitPaymentInfo(
      {int payChannel, String openId, num price, num orderId}) async {
    Completer completer = new Completer();
    Map<String, dynamic> params = {
      "payChannel": payChannel,
      "openId": openId,
      "price": price,
      "orderId": orderId,
    };
    HttpManager().request(HttpApis.submitPaymentInfo,
        method: NWMethod.POST, params: params, success: (data) {
      print("获取支付信息得到 $data");
      // completer.complete({"succeed": true, "data": data});
      completer.complete(data);
    }, error: (e) {
      print("e---${e}");
      EasyLoadingUtil.showMessage(message: "提交支付信息失败,错误信息:$e");
      // completer.complete({"succeed": false, "e": e});
      completer.complete(false);
    });
    return completer.future;
  }

  // 微信登录相关
  Future getWeChatOpenId({String code}) async {
    // print("code-------${code}");
    Completer completer = new Completer();
    Dio dio = new Dio();
    dio.get("https://api.weixin.qq.com/sns/oauth2/access_token",
        queryParameters: {
          "appid": AppConfig.wechatAppId,
          "secret": AppConfig.wechatAppSecret,
          "code": code,
          "grant_type": "authorization_code"
        }).then((response) {
      print("response.data${response.data}");
      Map<String, dynamic> map = json.decode(response.data);
      if (map["openid"] == null) {
        completer.complete(false);
      } else {
        completer.complete(map["openid"]);
      }
    });
    return completer.future;
  }
}
