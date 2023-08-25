import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  static EventBus _instance;

  static EventBus getInstance() {
    if (null == _instance) {
      _instance = new EventBus();
    }
    return _instance;
  }
}

class SelectedArea {
  Map<String, String> area;

  SelectedArea(this.area);
}

class ChangeOrderModel {
  int model;
  ChangeOrderModel(this.model);
}

class RefreshListData {
  int type; // 1 订单 2 集市
  RefreshListData(this.type);
}

class ReLogin{
  String account;
  ReLogin(this.account,);
}

class UpdateKcData{
  dynamic data;
  UpdateKcData(this.data);
}
