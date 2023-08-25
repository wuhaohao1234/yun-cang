import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wms/models/address/area_model.dart';
import 'package:wms/models/address/city_model.dart';
import 'package:wms/models/address/province_model.dart';
import 'package:wms/models/address/country_model.dart';
import 'package:wms/network/http_services.dart';
import 'package:wms/utils/event_bus_util.dart';
import 'package:wms/utils/toast_util.dart';

class WMSChooseAreaPageController extends GetxController {
  final bool countryStatus;
  WMSChooseAreaPageController({Key key, this.countryStatus});
  var countryList = RxList<CountryModel>();
  var provinceList = RxList<ProvinceModel>();
  var cityList = RxList<CityModel>();
  var areaList = RxList<AreaModel>();

  var country = ''.obs;
  var province = ''.obs;
  var city = ''.obs;
  var area = ''.obs;

  PageController pageViewController;

// 获取国家
  void requestCountry() {
    HttpServices.getCountryList(success: (data, total) {
      countryList.value = data;
    }, error: (error) {
      ToastUtil.showMessage(message: error.message);
    });
  }

  // 获取省
  void requestProvince() {
    HttpServices.getProvinceList(success: (data, total) {
      provinceList.value = data;
    }, error: (error) {
      ToastUtil.showMessage(message: error.message);
    });
  }

  // 获取市
  void requestCity(String provinceId) {
    HttpServices.getCityList(
        provinceId: provinceId,
        success: (data, total) {
          cityList.value = data;
        },
        error: (error) {
          ToastUtil.showMessage(message: error.message);
        });
  }

  // 获取区域
  void requestArea(String cityId) {
    HttpServices.getAreaList(
        cityId: cityId,
        success: (data, total) {
          areaList.value = data;
        },
        error: (error) {
          ToastUtil.showMessage(message: error.message);
        });
  }

  // 点击国家
  void onTapCountry(int index) {
    country.value = countryList[index].countryName;
    EventBusUtil.getInstance().fire(
      SelectedArea({
        'country': country.value,
        'countryId': countryList
            .indexWhere(
              (element) => element.countryName == country.value,
            )
            .toString(),
      }),
    );
    country.value = '';
    Get.back();
  }

  // 点击省
  void onTapProvince(int index) {
    requestCity(provinceList[index].provinceId);
    province.value = provinceList[index].provinceName;
    pageViewController.jumpToPage(1);
  }

  // 点击市
  void onTapCity(int index) {
    requestArea(cityList[index].cityId);
    city.value = cityList[index].cityName;
    pageViewController.jumpToPage(2);
  }

  // 点击区
  void onTapArea(int index) {
    area.value = areaList[index].areaName;
    EventBusUtil.getInstance().fire(
      SelectedArea({
        'province': province.value,
        'city': city.value,
        'area': area.value,
        // 'country': country.value,
        // 'countryId': countryList
        //     .indexWhere(
        //       (element) => element.countryName == country.value,
        //     )
        //     .toString(),
      }),
    );
    country.value = '';
    province.value = '';
    city.value = '';
    area.value = '';
    cityList.clear();
    areaList.clear();
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    print('pageViewController init ........');
    pageViewController = PageController();
    requestCountry();
    if (!countryStatus) requestProvince();
  }

  @override
  void onClose() {
    super.onClose();
    print('pageViewController dispose ........');
    pageViewController?.dispose();
  }
}
