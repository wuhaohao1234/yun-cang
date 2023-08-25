import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:wms/configs/wms_user.dart';
import 'package:wms/utils/event_bus_util.dart';
import 'package:wms/utils/easy_loading_util.dart';
import 'base_entity.dart';
import 'error_entity.dart';
import 'http_apis.dart';

enum NWMethod { GET, POST, DELETE, PUT }

const NWMethodValues = {
  NWMethod.GET: "get",
  NWMethod.POST: "post",
  NWMethod.DELETE: "delete",
  NWMethod.PUT: "put"
};

class HttpManager {
  static final HttpManager _shared = HttpManager._internal();

  factory HttpManager() => _shared;

  Dio dio;

  Connectivity _connectivity;

  HttpManager._internal() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: HttpApis.baseUrl,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: 5000,
        receiveTimeout: 5000,
      );
      dio = Dio(options);
      // dio.interceptors.add(TokenInterceptor());
      _connectivity = Connectivity();
    }
  }

  clear() {
    dio.clear();
  }

  Map<String, dynamic> _addPublicParameters(Map<String, dynamic> params) {
    if (params == null) {
      params = Map();
    }
    return params;
  }

  Future request<T>(
    String path, {
    Map<String, dynamic> params,
    Function(T) success,
    Function(ErrorEntity) error,
    NWMethod method = NWMethod.POST,
  }) async {
    //检查当前网络状态
    ConnectivityResult result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      error(ErrorEntity(code: -1, message: "网络已断开，请检查网络！"));
      return null;
    }

    String token = WMSUser.getInstance().token;

    print('url : ${HttpApis.baseUrl}$path, params : $params \	 token=$token');

    try {
      Response response = await dio.request(
        path,
        queryParameters:
            ((method == NWMethod.GET) || (method == NWMethod.DELETE))
                ? params
                : null,
        data: ((method == NWMethod.POST) || (method == NWMethod.PUT))
            ? params
            : null,
        options: Options(
            method: NWMethodValues[method],
            headers: token != null
                ? {HttpHeaders.authorizationHeader: "Bearer $token"}
                : null),
      );
      EasyLoadingUtil.showInfo(
          message:
              "请求: $path, 方法:$method, 参数:$params, 返回:${response.toString()}");

      // print('response : ${response.toString()}');

      if (response != null && response.statusCode == 200) {
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code == 200) {
          success(entity.data);
        } else if (entity.code == 401) {
          error(ErrorEntity(code: entity.code, message: '登录已过期，请重新登录'));
          EventBusUtil.getInstance()
              .fire(ReLogin(WMSUser.getInstance().userInfoModel.phoneNum));
        } else {
          error(ErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(ErrorEntity(
            code: response.statusCode, message: response.statusMessage));
      }
    } on DioError catch (e) {
      print('error - ${e.message}');
      error(createErrorEntity(e));
    }
  }

  Future requestList<T>(
    String path, {
    Map<String, dynamic> params,
    Function(List, num) success,
    Function(ErrorEntity) error,
    NWMethod method = NWMethod.GET,
  }) async {
    //检查当前网络状态
    ConnectivityResult result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      error(ErrorEntity(code: -1, message: "网络已断开，请检查网络！"));
      return null;
    }

    String token = WMSUser.getInstance().token;

    //添加公共参数
    params = _addPublicParameters(params);

    print('url : $path params : ${params.toString()} token = $token');

    try {
      Response response = await dio.request(path,
          queryParameters:
              ((method == NWMethod.GET) || (method == NWMethod.DELETE))
                  ? params
                  : null,
          data: ((method == NWMethod.POST) || (method == NWMethod.PUT))
              ? params
              : null,
          options: Options(
              method: NWMethodValues[method],
              headers: token != null
                  ? {HttpHeaders.authorizationHeader: "Bearer $token"}
                  : null));

      print('请求列表$path, 参数 $params, 返回结果 ${response.toString()}');
      EasyLoadingUtil.showInfo(
          message:
              "请求: $path, 方法:$method, 参数:$params, 返回:${response.toString()}");

      if (response != null && response.statusCode == 200) {
        BaseListEntity entity = BaseListEntity<T>.fromJson(response.data);
        if (entity.code == 200) {
          success(entity.data, entity.total);
        } else if (entity.code == 401) {
          print('走了500============');
          error(ErrorEntity(code: entity.code, message: '登录已过期，请重新登录'));
          EventBusUtil.getInstance()
              .fire(ReLogin(WMSUser.getInstance().userInfoModel.phoneNum));
        } else {
          error(ErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        print("请求失败走了这里，。。。。。。。");
        error(ErrorEntity(
            code: response.statusCode, message: response.statusMessage));
      }
    } on DioError catch (e) {
      print("请求失败走了这里22222，。。。。。。。");
      print('error ==  ${e.message}');
      error(createErrorEntity(e));
    }
  }

  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return ErrorEntity(code: 1, message: "请求取消");
        }
        break;
      case DioErrorType.connectTimeout:
        {
          return ErrorEntity(code: 2, message: "连接超时");
        }
        break;
      case DioErrorType.sendTimeout:
        {
          return ErrorEntity(code: 3, message: "请求超时");
        }
        break;
      case DioErrorType.receiveTimeout:
        {
          return ErrorEntity(code: 4, message: "响应超时");
        }
        break;
      case DioErrorType.response:
        {
          try {
            int errCode = error.response.statusCode;
            String errMsg = error.response.statusMessage;
            return ErrorEntity(code: errCode, message: errMsg);
          } on Exception catch (_) {
            return ErrorEntity(code: 5, message: "网络错误");
          }
        }
        break;
      default:
        {
          return ErrorEntity(code: -1, message: "请求失败，请稍后再试");
        }
    }
  }

  static int currentTimeMillis() {
    int millisecondes = DateTime.now().millisecondsSinceEpoch;
    return millisecondes ~/ 1000;
  }
}

class TokenInterceptor extends Interceptor {
  // @override
  // onError(DioError err, ErrorInterceptorHandler handler) async {
  //   super.onError(err, handler);
  // }
}
