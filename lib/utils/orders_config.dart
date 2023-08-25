/// Create by bigv on 21-7-14
/// Description:

class OrderStatusConfig {
  static String orderState(String state) {
    String stateString = '';
    switch (state) {
      case "TO_PAY":
        stateString = '待付款';
        break;
      case "TO_DELIVERY":
        stateString = '待发货';
        break;
      case "TO_RECEIVED":
        stateString = '待收货';
        break;
      case "RECEIVED":
        stateString = '已收货';
        break;
      case "DEAL_FAILURE":
        stateString = '交易失败';
        break;

      default:
        stateString = '';
    }
    return stateString;
  }
}

class OrderConfig {
  static String orderState(int state) {
    String stateString = '';
    switch (state) {
      case 1:
        stateString = '待付款';
        break;
      case 2:
        stateString = '待发货';
        break;
      case 3:
        stateString = '待收货';
        break;
      case 4:
        stateString = '待评价';
        break;
      case 5:
        stateString = '已收货';
        break;
      case 6:
        stateString = '已取消';
        break;
      case 7:
        stateString = '已取消';
        break;
      case 8:
        stateString = '退货/退款中';
        break;
      case 9:
        stateString = '退货/退款成功';
        break;
      case 2000:
        stateString = '支付成功';
        break;
      case 2010:
        stateString = '待平台收货';
        break;
      case 3000:
        stateString = '平台已收货';
        break;
      case 3010:
        stateString = '质检通过';
        break;
      case 3020:
        stateString = '鉴别通过';
        break;
      case 3030:
        stateString = '待平台发货';
        break;
      case 3040:
        stateString = '待买家收货';
        break;
      case 4000:
        stateString = '交易成功';
        break;
      case 7000:
        stateString = '交易失败';
        break;
      case 8000:
        stateString = '关闭中';
        break;
      case 8010:
        stateString = '交易关闭成功';
        break;
    }
    return stateString;
  }
}
