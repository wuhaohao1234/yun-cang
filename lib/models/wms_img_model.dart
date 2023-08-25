class WMSImgModel {
  String url;
  String name;
  num uid;
  String status;

  WMSImgModel({
    this.url,
    this.name,
    this.uid,
    this.status,
  });

  factory WMSImgModel.fromJson(Map<String, dynamic> json) {
    return WMSImgModel(
      url: json['url'],
      name: json['name'],
      uid: json['uid'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'name': name,
        'uid': uid,
        'status': status,
      };
}
