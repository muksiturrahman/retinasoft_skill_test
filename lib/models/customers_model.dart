import 'package:meta/meta.dart';
import 'dart:convert';

class CustomersModel {
  int status;
  String msg;
  String description;
  Customers customers;

  CustomersModel({
    required this.status,
    required this.msg,
    required this.description,
    required this.customers,
  });

  factory CustomersModel.fromRawJson(String str) => CustomersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomersModel.fromJson(Map<String, dynamic> json) => CustomersModel(
    status: json["status"],
    msg: json["msg"],
    description: json["description"],
    customers: Customers.fromJson(json["customers"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "description": description,
    "customers": customers.toJson(),
  };
}

class Customers {
  String perPage;
  String from;
  String to;
  String total;
  String currentPage;
  String lastPage;
  String prevPageUrl;
  String firstPageUrl;
  String nextPageUrl;
  String lastPageUrl;
  List<Customer> customers;

  Customers({
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
    required this.customers,
  });

  factory Customers.fromRawJson(String str) => Customers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customers.fromJson(Map<String, dynamic> json) => Customers(
    perPage: json["per_page"].toString(),
    from: json["from"].toString(),
    to: json["to"].toString(),
    total: json["total"].toString(),
    currentPage: json["current_page"].toString(),
    lastPage: json["last_page"].toString(),
    prevPageUrl: json["prev_page_url"].toString(),
    firstPageUrl: json["first_page_url"].toString(),
    nextPageUrl: json["next_page_url"].toString(),
    lastPageUrl: json["last_page_url"].toString(),
    customers: List<Customer>.from(json["customers"].map((x) => Customer.fromJson(x))),
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
    "customers": List<dynamic>.from(customers.map((x) => x.toJson())),
  };
}

class Customer {
  String id;
  String name;
  String phone;
  String balance;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.balance,
  });

  factory Customer.fromRawJson(String str) => Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"].toString(),
    name: json["name"].toString(),
    phone: json["phone"].toString(),
    balance: json["balance"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "balance": balance,
  };
}
