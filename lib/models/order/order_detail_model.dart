import 'order_model.dart';

class OrderDetailModel {
  String createTime;
  int id;
  int orderType; // /** 订单来源：0-app 1-得物 */
  String tenantUserCode; // 	卖家客户代码
  String userCode; // 	买家用户客户代码
  String orderCode; // 	订单编号
  int orderStatus; // 	/** 订单状态：1-待付款 2-待发货 3-待收货 4-待评价 5-已完成 6-已取消 7-退款中 8-退货/退款中 9退货/退款成功 10-部分退款 */
  String logisticsName; //	发货时所用的物流公司的名称
  String logisticsNum;
  String payTime; //	付款时间
  String remark; // 	下单时的备注
  String notes; // 	下单时的备注
  String payNum; // 支付单号

  String picturePath; // 	图片路径
  num buyNums; // 	购买数量
  int weight; // 	重量，单位(千克)

  String userName; // 收货人名称
  String userPhone; //收货人手机号码
  String province; //省份
  String city; //	城市
  String area; //	城市
  String address; //详细地址

  num orderSum; // 订单金额
  num sellPrice;
  num postFee; //运费
  num warehouseMoneys;
  num tariff; //税费
  int payStatus; // /** 支付状态：1-已支付 0-未支付 */
  String logistics; // 	订单编号
  List<OrderDetailListItem> wmsUserOrderDetailsList;
  int depotId;
  String depotName;
  int settlement;

  bool selected;

  OrderDetailModel({
    this.createTime,
    this.id,
    this.orderType,
    this.tenantUserCode,
    this.userCode,
    this.orderCode,
    this.orderStatus,
    this.payTime,
    this.remark,
    this.notes,
    this.payNum,
    this.picturePath,
    this.buyNums,
    this.weight,
    this.userName,
    this.userPhone,
    this.province,
    this.city,
    this.area,
    this.address,
    this.logisticsName,
    this.orderSum,
    this.payStatus,
    this.logisticsNum,
    this.selected,
    this.wmsUserOrderDetailsList,
    this.depotId,
    this.depotName,
    this.postFee,
    this.warehouseMoneys,
    this.tariff,
    this.sellPrice,
    this.settlement,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    List<OrderDetailListItem> orderListTmp;
    if (json['wmsUserOrderDetailsList'] != null) {
      orderListTmp = [];
      (json['wmsUserOrderDetailsList'] as List).forEach((element) {
        orderListTmp.add(OrderDetailListItem.fromJson(element));
      });
    }
    return OrderDetailModel(
      createTime: json['createTime'],
      id: json['id'],
      orderType: json['orderType'],
      tenantUserCode: json['tenantUserCode'],
      userCode: json['userCode'],
      orderCode: json['orderCode'],
      orderStatus: json['orderStatus'],
      payTime: json['payTime'],
      remark: json['remark'],
      notes: json['notes'],
      payNum: json['payNum'],
      picturePath: json['picturePath'],
      buyNums: json['buyNums'],
      weight: json['weight'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      province: json['province'],
      city: json['city'],
      area: json['area'],
      address: json['address'],
      logisticsName: json['logisticsName'],
      orderSum: json['orderSum'].toDouble(),
      sellPrice: json['sellPrice'].toDouble(),
      postFee: (json['postFee'] ?? 0).toDouble(),
      warehouseMoneys: (json['warehouseMoney'] ?? 0).toDouble(),
      tariff: (json['tariff'] ?? 0).toDouble(),
      logisticsNum: json['logisticsNum'],
      payStatus: json['payStatus'],
      selected: json['selected'],
      wmsUserOrderDetailsList: orderListTmp,
      depotId: json['depotId'],
      depotName: json['depotName'],
      settlement: json['settlement'],
    );
  }

  Map<String, dynamic> toJson() => {
        'orderSum': orderSum,
        'sellPrice': sellPrice,
        'postFee': postFee,
        'warehouseMoneys': warehouseMoneys,
        'tariff': tariff,
        'createTime': createTime,
        'id': id,
        'orderType': orderType,
        'tenantUserCode': tenantUserCode,
        'userCode': userCode,
        'orderCode': orderCode,
        'orderStatus': orderStatus,
        'payTime': payTime,
        'remark': remark,
        'notes': notes,
        'payNum': payNum,
        'picturePath': picturePath,
        'buyNums': buyNums,
        'weight': weight,
        'userName': userName,
        'userPhone': userPhone,
        'province': province,
        'city': city,
        'area': area,
        'address': address,
        'logisticsName': logisticsName,
        'logisticsNum': logisticsNum,
        'payStatus': payStatus,
        'selected': selected,
        'wmsUserOrderDetailsList': wmsUserOrderDetailsList,
        'depotId': depotId,
        'depotName': depotName,
        'settlement': settlement,
      };
}
