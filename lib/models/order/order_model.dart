// 订单列表数据

class OrderModel {
  int orderId;
  num orderSum;
  int orderStatus;
  String createTime;
  List detailsList;
  bool selected;
  String logisticsNum;
  String depotName;
  int bcStatus; //清关状态 0 正常 1 重推
  int depotId;
  bool virtualCommodity;

  OrderModel(
      {this.orderId,
      this.orderSum,
      this.createTime,
      this.detailsList,
      this.selected,
      this.logisticsNum,
      this.depotName,
      this.bcStatus,
      this.orderStatus,
      this.depotId,
      this.virtualCommodity
      //431024199608012724
      });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderDetailListItem> sysPrepareSkuListTmp;
    if (json['detailsList'] != null) {
      sysPrepareSkuListTmp = [];
      (json['detailsList'] as List).forEach((element) {
        sysPrepareSkuListTmp.add(OrderDetailListItem.fromJson(element));
      });
    }

    List<OrderDetailListItem> detailsListTmp;
    if (json['detailsList'] != null) {
      detailsListTmp = [];
      (json['detailsList'] as List).forEach((element) {
        detailsListTmp.add(OrderDetailListItem.fromJson(element));
      });
    }
    return OrderModel(
      orderId: json['orderId'],
      orderSum: json['orderSum'],
      createTime: json['createTime'],
      detailsList: detailsListTmp,
      selected: json['selected'] ?? false,
      logisticsNum: json['logisticsNum'],
      bcStatus: json['bcStatus'],
      orderStatus: json['orderStatus'],
      depotId: json['depotId'],
      depotName: json['depotName'],
      virtualCommodity: json['virtualCommodity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'orderSum': orderSum,
        'createTime': createTime,
        'detailsList': detailsList.map((v) => v.toJson()).toList(),
        'selected': selected,
        'logisticsNum': logisticsNum,
        'bcStatus': bcStatus,
        'orderStatus': orderStatus,
        'depotId': depotId,
        'depotName': depotName,
        'virtualCommodity': virtualCommodity
      };
}

class OrderDetailListItem {
  int detailId;
  num subTotal;
  int buyNum;
  String color;
  String productName;
  String size;
  String specification;
  String picturePath;
  int status;

  OrderDetailListItem(
      {this.detailId,
      this.subTotal, //商品总价
      this.buyNum,
      this.color,
      this.productName,
      this.size,
      this.specification,
      this.picturePath,
      this.status});

  factory OrderDetailListItem.fromJson(Map<String, dynamic> json) {
    return OrderDetailListItem(
      detailId: json['detailId'],
      subTotal: json['subTotal'],
      buyNum: json['buyNum'],
      color: json['color'],
      productName: json['productName'],
      size: json['size'],
      specification: json['specification'],
      picturePath: json['picturePath'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'detailId': detailId,
        'subTotal': subTotal,
        'buyNum': buyNum,
        'color': color,
        'productName': productName,
        'size': size,
        'picturePath': picturePath,
        'status': status,
      };
}
