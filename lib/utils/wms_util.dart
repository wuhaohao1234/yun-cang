class WMSUtil {
  // 异常枚举值转文字描述
  static String getExceptionTypeString(String type) {
    if (type == null) return '';
    type = type.replaceAll('0', '缺配件');
    type = type.replaceAll('1', '划痕磨损');
    type = type.replaceAll('2', '污渍');
    type = type.replaceAll('3', '做工');
    return type;
  }

  // 瑕疵等级
  static String getDefectDegreddTypeString(int defectDegree) {
    String str = '';
    switch (defectDegree) {
      case 0:
        str = '缺配件';
        break;
      case 1:
        str = '划痕磨损';
        break;
      case 2:
        str = '污渍';
        break;
      case 3:
        str = '做工';
        break;
    }
    return str;
  }

  // 支付方式
  static String getPayModelString(int payModel) {
    String str = '';
    switch (payModel) {
      case 0:
        str = '账户余额';
        break;
      case 1:
        str = '微信';
        break;
      case 2:
        str = '支付宝';
        break;
    }
    return str;
  }

  // 分割图片URL
  static List<String> segmentationImageUrl(String url) {
    if (url == null) return [];
    return url.split(';');
  }

  // 获取当前年月份
  static String getCurrentDate() {
    DateTime _now = DateTime.now();
    int _year = _now.year;
    int _month = _now.month;
    return '$_year-${_month.toString().padLeft(2, '0')}';
  }

  // 物流状态转文字描述
  //-1 单号或快递公司代码错误 单号或快递公司代码错误 0 暂无轨迹 暂无轨迹 1 快递收件 快递收件 2 在途中 在途中 3 签收 签收 4 问题件 问题件 5 问题件 疑难件（收件人拒绝签收，地址有误或不能送达派送区域，收费等原因无法正常派送） 6 退件签收 退件签收
  static String stateStringForState(String state) {
    if (state == null) return '';
    var string = '';
    switch (state) {
      case '-1':
        // string = '单号或快递公司代码错误 ';
        string = '状态错误';
        break;
      case '0':
        string = '暂无轨迹';
        break;
      case '1':
        string = '快递收件';
        break;
      case '2':
        string = '在途中';
        break;
      case '3':
        string = '签收';
        break;
      case '4':
        string = '问题件';
        break;
      case '5':
        string = '疑难件';
        break;
      case '6':
        string = '退件签收';
        break;
    }
    return string;
  }

// 订单状态 0 通过 1 已发布 2 驳回 3取消
  static String orderReviewStringChange(String orderReview) {
    String str = '';
    switch (orderReview) {
      case '0':
        str = '通过';
        break;
      case '1':
        str = '已发布';
        break;
      case '2':
        str = '驳回';
        break;
      case '3':
        str = '取消';
        break;
    }
    return str;
  }

  // 送货时间
  static String expirationStringChange(int expiration) {
    String str = '';
    switch (expiration) {
      case 0:
        str = '预计3-5日送达';
        break;
      case 1:
        str = '预计2周内送达';
        break;
      case 2:
        str = '预计2月内送达';
        break;
      default:
        str = '...';
    }
    return str;
  }

  // 自主单状态 0 待签收  1 认领生成 2 已签收
  static String statusStringChange(String status) {
    String str = '';
    switch (status) {
      case '0':
        str = '已发货，待签收';
        break;
      case '1':
        str = '认领生成';
        break;
      case '2':
        str = '已签收';
        break;
      case '3':
        str = '取消';
        break;
      case '4':
        str = '发货';
        break;
      default:
        str = '...';
    }
    return str;
  }

  // 仓库状态 0 日本仓  1 香港仓 2 已签收
  static int statusDepotNameChange(String depotName) {
    int id;
    switch (depotName) {
      case '日本仓':
        id = 1;
        break;
      case '香港1仓':
        id = 2;
        break;

      default:
        id = null;
    }
    return id;
  }

  // 仓库状态 0 日本仓  1 香港仓 2 已签收
  static String statusDepotIdChange(int depotId) {
    String depotName;
    switch (depotId) {
      case 1:
        depotName = '日本仓';
        break;
      case 2:
        depotName = '香港仓';
        break;

      default:
        depotName = '';
    }
    return depotName;
  }

// 处理模式 0 商品质检  1 理货点数 2 临时存放
  static String orderOperationalRequirementsStringChange(
      String orderOperationalRequirements) {
    String str = '';
    switch (orderOperationalRequirements) {
      case '1':
        str = '仅理货点数';
        break;
      case '2':
        str = '质检拍照';
        break;
      case '3':
        str = '临时存放';
        break;
    }
    return str;
  }
}
