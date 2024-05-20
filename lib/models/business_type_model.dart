import 'dart:convert';

class BusinessTypeModel {
  int status;
  String msg;
  String description;
  List<BusinessType> businessTypes;

  BusinessTypeModel({
    required this.status,
    required this.msg,
    required this.description,
    required this.businessTypes,
  });

  factory BusinessTypeModel.fromRawJson(String str) => BusinessTypeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessTypeModel.fromJson(Map<String, dynamic> json) => BusinessTypeModel(
    status: json["status"],
    msg: json["msg"],
    description: json["description"],
    businessTypes: List<BusinessType>.from(json["business_types"].map((x) => BusinessType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "description": description,
    "business_types": List<dynamic>.from(businessTypes.map((x) => x.toJson())),
  };
}

class BusinessType {
  String id;
  String name;
  String slug;

  BusinessType({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory BusinessType.fromRawJson(String str) => BusinessType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessType.fromJson(Map<String, dynamic> json) => BusinessType(
    id: json["id"].toString(),
    name: json["name"].toString(),
    slug: json["slug"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
  };
}
