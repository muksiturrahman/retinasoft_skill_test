import 'package:meta/meta.dart';
import 'dart:convert';

class TransactionListModel {
  int status;
  String msg;
  String description;
  Transactions transactions;

  TransactionListModel({
    required this.status,
    required this.msg,
    required this.description,
    required this.transactions,
  });

  factory TransactionListModel.fromRawJson(String str) => TransactionListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionListModel.fromJson(Map<String, dynamic> json) => TransactionListModel(
    status: json["status"],
    msg: json["msg"],
    description: json["description"],
    transactions: Transactions.fromJson(json["transactions"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "description": description,
    "transactions": transactions.toJson(),
  };
}

class Transactions {
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
  List<Transaction> transactions;

  Transactions({
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
    required this.transactions,
  });

  factory Transactions.fromRawJson(String str) => Transactions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
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
    transactions: List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
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
    "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
  };
}

class Transaction {
  String id;
  String transactionNo;
  String type;
  String amount;
  String transactionDate;
  String details;
  String billNo;
  String image;
  String imageFullPath;
  String status;

  Transaction({
    required this.id,
    required this.transactionNo,
    required this.type,
    required this.amount,
    required this.transactionDate,
    required this.details,
    required this.billNo,
    required this.image,
    required this.imageFullPath,
    required this.status,
  });

  factory Transaction.fromRawJson(String str) => Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"].toString(),
    transactionNo: json["transaction_no"].toString(),
    type: json["type"].toString(),
    amount: json["amount"].toString(),
    transactionDate: json["transaction_date"].toString(),
    details: json["details"].toString(),
    billNo: json["bill_no"].toString(),
    image: json["image"].toString(),
    imageFullPath: json["image_full_path"].toString(),
    status: json["status"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_no": transactionNo,
    "type": type,
    "amount": amount,
    "transaction_date": transactionDate,
    "details": details,
    "bill_no": billNo,
    "image": image,
    "image_full_path": imageFullPath,
    "status": status,
  };
}
