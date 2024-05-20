
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:retinasoft_skill_test/models/business_type_model.dart';
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