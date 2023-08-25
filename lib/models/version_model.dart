class VersionModel {
  String title; // title
  String details; // details
  num edition; // edition
  num isUpdate; // 是否强制更新 1强制更新 0 非强制
  String path; //	文件路径

  VersionModel(
      {this.title, this.details, this.edition, this.isUpdate, this.path});

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      title: json['title'],
      details: json['details'],
      edition: json['edition'],
      isUpdate: json['isUpdate'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'details': details,
    'edition': edition,
    'isUpdate': isUpdate,
    'path': path,
  };
}
