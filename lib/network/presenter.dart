
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:retinasoft_skill_test/models/branches_model.dart';
import 'package:retinasoft_skill_test/models/business_type_model.dart';
import 'package:retinasoft_skill_test/models/customers_model.dart';
import 'package:retinasoft_skill_test/network/base_client.dart';
import 'package:retinasoft_skill_test/network/service.dart';

Future<dynamic> initBusinessTypeInfo(BuildContext context) async {
  String url = ApiService.businessTypeUrl;

  var response = await BaseClient().getMethodWithoutHeader(url);

  if (response != null) {
    try {
      BusinessTypeModel businessTypeModel =
      BusinessTypeModel.fromJson(json.decode(response));

      return businessTypeModel;
    } catch (e) {
      return initBusinessTypeInfo(context);
    }
  } else {
    // return AppString.errorMsg;
  }
}


Future<dynamic> initBranchesInfo(BuildContext context, String apiToken) async {
  String url = ApiService.getBranchesUrl;

  Map<String, String> headerMap = {
    "Authorization": "Bearer ${apiToken}"
  };

  var response = await BaseClient().getMethodWithHeader(url, headerMap);

  if (response != null) {
    try {
      BranchesModel branchesModel =
      BranchesModel.fromJson(json.decode(response));

      return branchesModel;
    } catch (e) {
      return initBranchesInfo(context, apiToken);
    }
  } else {
    // return AppString.errorMsg;
  }
}

Future<dynamic> initCustomerInfo(BuildContext context, String apiToken, String branchId) async {
  String url = '${ApiService.baseUrl}admin/${branchId}/0/customers';

  Map<String, String> headerMap = {
    "Authorization": "Bearer ${apiToken}"
  };

  var response = await BaseClient().getMethodWithHeader(url, headerMap);

  if (response != null) {
    try {
      CustomersModel customersModel =
      CustomersModel.fromJson(json.decode(response));

      return customersModel;
    } catch (e) {
      return initCustomerInfo(context, apiToken, branchId);
    }
  } else {
    // return AppString.errorMsg;
  }
}