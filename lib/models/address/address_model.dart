class AddressModel {
  Object searchValue;
  Object createBy;
  Object createTime;
  Object updateBy;
  Object updateTime;
  Object remark;
  int id;
  String userCode;
  String userName;
  String userPhone;
  String province;
  String city;
  String area;
  String userAddress;
  String cardName;
  String cardNum;
  String cardJust;
  String cardBack;
  Object cardTerm;
  String zipCode;
  int isdefault;
  int dataflag;

  AddressModel.fromJsonMap(Map<String, dynamic> map)
      : searchValue = map["searchValue"],
        createBy = map["createBy"],
        createTime = map["createTime"],
        updateBy = map["updateBy"],
        updateTime = map["updateTime"],
        remark = map["remark"],
        id = map["id"],
        userCode = map["userCode"],
        userName = map["userName"],
        userPhone = map["userPhone"],
        province = map["province"],
        city = map["city"],
        area = map["area"],
        userAddress = map["userAddress"],
        cardName = map["cardName"],
        cardNum = map["cardNum"],
        cardJust = map["cardJust"],
        cardBack = map["cardBack"],
        zipCode = map["zipCode"],
        cardTerm = map["cardTerm"],
        isdefault = map["isdefault"],
        dataflag = map["dataflag"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchValue'] = searchValue;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['updateTime'] = updateTime;
    data['remark'] = remark;
    data['id'] = id;
    data['userCode'] = userCode;
    data['userName'] = userName;
    data['userPhone'] = userPhone;
    data['province'] = province;
    data['city'] = city;
    data['area'] = area;
    data['userAddress'] = userAddress;
    data['cardName'] = cardName;
    data['cardNum'] = cardNum;
    data['cardJust'] = cardJust;
    data['cardBack'] = cardBack;
    data['zipCode'] = zipCode;
    data['cardTerm'] = cardTerm;
    data['isdefault'] = isdefault;
    data['dataflag'] = dataflag;
    return data;
  }
}
