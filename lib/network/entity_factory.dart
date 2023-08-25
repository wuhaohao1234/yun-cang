import 'package:wms/models/ConfirmOut_model.dart';
import 'package:wms/models/address/address_model.dart';
import 'package:wms/models/mine/agent_model.dart';
import 'package:wms/models/address/area_model.dart';
import 'package:wms/models/address/country_model.dart';
import 'package:wms/models/market/chu_huo_shipment_normal_model.dart';
import 'package:wms/models/market/chu_huo_shipment_defect_model.dart';
import 'package:wms/models/address/city_model.dart';
import 'package:wms/models/storage/ckd_detail_model.dart';
import 'package:wms/models/storage/cs_dck_model.dart';
import 'package:wms/models/cs_god_detail_model.dart';
import 'package:wms/models/storage/cs_yckd_model.dart';
import 'package:wms/models/storage/chuku_model.dart';
import 'package:wms/models/entrepot/ruku/en_rkd_detail_model.dart';
import 'package:wms/models/entrepot/ruku/en_rkd_model.dart';
import 'package:wms/models/entrepot/en_wares_model.dart';
import 'package:wms/models/entrepot/ruku/en_wzd_model.dart';
import 'package:wms/models/entrepot/ruku/en_ybrk_model.dart';
import 'package:wms/models/entrepot/ruku/en_ycd_detail_model.dart';
import 'package:wms/models/entrepot/ruku/en_ycd_model.dart';
import 'package:wms/models/entrepot/sku/en_shangpin_model.dart';
import 'package:wms/models/entrepot/chuku/en_fenjian_model.dart';
import 'package:wms/models/storage/exception_list_detail_model.dart';
import 'package:wms/models/forSaleDetialList_model.dart';
import 'package:wms/models/getJiShiPrice_model.dart';
import 'package:wms/models/inventory_categorys_model.dart';
import 'package:wms/models/logistics_model.dart';
import 'package:wms/models/market/market_all_detail_model.dart';
import 'package:wms/models/market/market_detail_model.dart';
import 'package:wms/models/market/market_wares_model.dart';
import 'package:wms/models/mine/mine_info_model.dart';
import 'package:wms/models/mine/card_model.dart';
import 'package:wms/models/mine/moneys_log_model.dart';
import 'package:wms/models/order/order_model.dart';
import 'package:wms/models/order/order_detail_model.dart';
import 'package:wms/models/oss_model.dart';
import 'package:wms/models/storage/perpare_order_model.dart';
import 'package:wms/models/storage/onsale_commodity_model.dart';
import 'package:wms/models/address/province_model.dart';
import 'package:wms/models/storage/rkd_model.dart';
import 'package:wms/models/select_exception_sku_send_back_model.dart';
import 'package:wms/models/old/shipment_model.dart';
import 'package:wms/models/market/shipment_model2.dart';
import 'package:wms/models/size_qty_model.dart';
import 'package:wms/models/mine/user_info_model.dart';
import 'package:wms/models/version_model.dart';
import 'package:wms/models/mine/wallet_account_model.dart';
import 'package:wms/models/ware_house_model.dart';
import 'package:wms/models/storage/wzd_model.dart';
import 'package:wms/models/storage/ycj_model.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (json == null) {
      return null;
    }
    switch (T.toString()) {
      case "UserInfoModel":
        return UserInfoModel.fromJson(json) as T;
        break;
      case "PerpareOrderModel":
        return PerpareOrderModel.fromJson(json) as T;
        break;
      case "WzdModel":
        return WzdModel.fromJson(json) as T;
        break;
      case "OssModel":
        return OssModel.fromJsonMap(json) as T;
        break;
      case "AddressModel":
        return AddressModel.fromJsonMap(json) as T;
        break;
      case "CountryModel":
        return CountryModel.fromJson(json) as T;
        break;
      case "ProvinceModel":
        return ProvinceModel.fromJson(json) as T;
        break;
      case "CityModel":
        return CityModel.fromJson(json) as T;
        break;
      case "AreaModel":
        return AreaModel.fromJson(json) as T;
        break;
      case "ENWzdModel":
        return ENWzdModel.fromJson(json) as T;
        break;
      case "WalletAccountModel":
        return WalletAccountModel.fromJson(json) as T;
        break;
      case "MoneysLogModel":
        return MoneysLogModel.fromJson(json) as T;
        break;
      case "ENYcdModel":
        return ENYcdModel.fromJson(json) as T;
        break;
      case "ENShangPingModel":
        return ENShangPingModel.fromJson(json) as T;
        break;
      case "ENRkdModel":
        return ENRkdModel.fromJson(json) as T;
        break;
      case "ENRkdDetailModel":
        return ENRkdDetailModel.fromJson(json) as T;
        break;
      case "ENYcdDetailModel":
        return ENYcdDetailModel.fromJson(json) as T;
        break;
      case "ENYbrkModel":
        return ENYbrkModel.fromJson(json) as T;
        break;
      case "RkdModel":
        return RkdModel.fromJson(json) as T;
        break;
      case "YcjModel":
        return YcjModel.fromJson(json) as T;
        break;
      case "OnSaleCommodityModel":
        return OnSaleCommodityModel.fromJson(json) as T;
        break;
      case "ENWaresModel":
        return ENWaresModel.fromJson(json) as T;
        break;
      case "MarketWaresModel":
        return MarketWaresModel.fromJson(json) as T;
        break;
      case "MarketAllDetailModel":
        return MarketAllDetailModel.fromJson(json) as T;
        break;
      case "MarkeDetailModel":
        return MarketDetailModel.fromJson(json) as T;
        break;
      case "WareHouseModel":
        return WareHouseModel.fromJson(json) as T;
        break;

      case "ShipmentModel":
        return ShipmentModel.fromJson(json) as T;
        break;
      case "InventoryCategorysModel":
        return InventoryCategorysModel.fromJson(json) as T;
        break;
      case "OrderModel":
        return OrderModel.fromJson(json) as T;
        break;
      case "OrderDetailModel":
        return OrderDetailModel.fromJson(json) as T;
        break;
      case "LogisticsModel":
        return LogisticsModel.fromJson(json) as T;
        break;
      case "ChuKuModel":
        return ChuKuModel.fromJson(json) as T;
        break;
      case "CkdDetailModel":
        return CkdDetailModel.fromJson(json) as T;
        break;
      case "CSYckdModel":
        return CSYckdModel.fromJson(json) as T;
        break;
      case "SizeQtyModel":
        return SizeQtyModel.fromJson(json) as T;
        break;
      case "CardModel":
        return CardModel.fromJson(json) as T;
        break;
      case "ExceptionListDetailModel":
        return ExceptionListDetailModel.fromJson(json) as T;
        break;
      case "SelectExceptionSkuSendBack":
        return SelectExceptionSkuSendBack.fromJson(json) as T;
        break;
      case "ForSaleDetialListModel":
        return ForSaleDetialListModel.fromJson(json) as T;
        break;
      case "ConfirmOutModel":
        return ConfirmOutModel.fromJson(json) as T;
        break;
      case "GetJiShiPriceModel":
        return GetJiShiPriceModel.fromJson(json) as T;
        break;
      case "ChuHuoShipmentModel":
        return ChuHuoShipmentModel.fromJson(json) as T;
        break;
      case "VersionModel":
        return VersionModel.fromJson(json) as T;
        break;
      case "CsChuKuModel":
        return CsChuKuModel.fromJson(json) as T;
        break;
      case "CSGodDetailModel":
        return CSGodDetailModel.fromJson(json) as T;
        break;
      case "MineInfoModel":
        return MineInfoModel.fromJson(json) as T;
        break;
      case "ChuHuoShipmentNormalModel":
        return ChuHuoShipmentNormalModel.fromJson(json) as T;
        break;
      case "ChuHuoShipmentDefectModel":
        return ChuHuoShipmentDefectModel.fromJson(json) as T;
        break;
      case "AgentModel":
        return AgentModel.fromJson(json) as T;
        break;
      case "ENFenJianModel":
        return ENFenJianModel.fromJson(json) as T;
        break;

      default:
        return json as T;
    }
  }
}
