class OssModel {
  String accessid;
  String policy;
  String signature;
  String dir;
  String host;
  String expire;
  String callback;

  OssModel.fromJsonMap(Map<String, dynamic> map)
      : accessid = map["accessid"],
        policy = map["policy"],
        signature = map["signature"],
        dir = map["dir"],
        host = map["host"],
        expire = map["expire"],
        callback = map["callback"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessid'] = accessid;
    data['policy'] = policy;
    data['signature'] = signature;
    data['dir'] = dir;
    data['host'] = host;
    data['expire'] = expire;
    data['callback'] = callback;
    return data;
  }
}
