import 'entity_factory.dart';

class BaseEntity<T> {
  int code;
  String message;
  T data;

  BaseEntity({this.code, this.message, this.data});

  factory BaseEntity.fromJson(json) {
    if (json == null) {
      return null;
    }
    return BaseEntity(
      code: json["code"],
      message: json["msg"],
      // data值需要经过工厂转换为我们传进来的类型
      data: EntityFactory.generateOBJ<T>(json["data"]),
    );
  }
}

class BaseListEntity<T> {
  int code;
  String message;
  num total;
  List<T> data;

  BaseListEntity({this.code, this.message, this.data, this.total});

  factory BaseListEntity.fromJson(json) {
    List<T> mData = [];
    if (json['rows'] != null) {
      //遍历data并转换为我们传进来的类型
      (json['rows'] as List).forEach((v) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      });
    }

    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      (json['data'] as List).forEach((v) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      });
    }

    return BaseListEntity(
        code: json["code"],
        message: json["msg"],
        data: mData,
        total: json["total"]);
  }
}
