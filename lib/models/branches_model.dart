import 'package:meta/meta.dart';
import 'dart:convert';

class BranchesModel {
  int status;
  String msg;
  String description;
  Branches branches;

  BranchesModel({
    required this.status,
    required this.msg,
    required this.description,
    required this.branches,
  });

  factory BranchesModel.fromRawJson(String str) => BranchesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchesModel.fromJson(Map<String, dynamic> json) => BranchesModel(
    status: json["status"],
    msg: json["msg"],
    description: json["description"],
    branches: Branches.fromJson(json["branches"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "description": description,
    "branches": branches.toJson(),
  };
}

class Branches {
  int perPage;
  int from;
  int to;
  int total;
  int currentPage;
  int lastPage;
  dynamic prevPageUrl;
  String firstPageUrl;
  dynamic nextPageUrl;
  String lastPageUrl;
  List<Branch> branches;

  Branches({
    required this.perPage,
    required this.from,
    required this.to,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.prevPageUrl,
    required this.firstPageUrl,
    required this.nextPageUrl,
    required this.lastPageUrl,
    required this.branches,
  });

  factory Branches.fromRawJson(String str) => Branches.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Branches.fromJson(Map<String, dynamic> json) => Branches(
    perPage: json["per_page"],
    from: json["from"],
    to: json["to"],
    total: json["total"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    prevPageUrl: json["prev_page_url"],
    firstPageUrl: json["first_page_url"],
    nextPageUrl: json["next_page_url"],
    lastPageUrl: json["last_page_url"],
    branches: List<Branch>.from(json["branches"].map((x) => Branch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "per_page": perPage,
    "from": from,
    "to": to,
    "total": total,
    "current_page": currentPage,
    "last_page": lastPage,
    "prev_page_url": prevPageUrl,
    "first_page_url": firstPageUrl,
    "next_page_url": nextPageUrl,
    "last_page_url": lastPageUrl,
    "branches": List<dynamic>.from(branches.map((x) => x.toJson())),
  };
}

class Branch {
  String id;
  String name;

  Branch({
    required this.id,
    required this.name,
  });

  factory Branch.fromRawJson(String str) => Branch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"].toString(),
    name: json["name"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
