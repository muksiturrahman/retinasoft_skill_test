import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BaseClient {
  //GET
  static const TIME_OUT = 30;

  get httpClient => null;

  Future<dynamic> postMethod(String api, Map body) async {
    var url = Uri.parse(api);

    Map bodyMap = body;
    try {
      var response = await http
          .post(url, body: bodyMap)
          .timeout(Duration(seconds: TIME_OUT));
      print(response);
      return _processResponse(response);
    } on SocketException {
      print('No Internet connection');
    } on TimeoutException {
      print('Api not responding');
    } catch (e) {
      print('Unknown error ' + e.toString());
    }
  }

  Future<dynamic> postMethodWithHeader(
      String api, Map body, Map<String, String> headerMap) async {
    var url = Uri.parse(api);

    final bodyMap = jsonEncode(body);
    try {
      var response = await http
          .post(url, headers: headerMap, body: bodyMap)
          .timeout(Duration(seconds: TIME_OUT));
      print(response.toString());
      return _processResponse(response);
    } on SocketException {
      print('No Internet connection');
    } on TimeoutException {
      print('Api not responding');
    } catch (e) {
      print('Unknown error ' + e.toString());
    }
  }

  Future<dynamic> initPostWithHeader(
      String api, Map body, Map<String, String> headerMap) async {
    var url = Uri.parse(api);

    // final bodyMap = jsonEncode(body);
    Map bodyMap = body;

    try {
      var response = await http
          .post(url, headers: headerMap, body: bodyMap)
          .timeout(Duration(seconds: TIME_OUT));
      print(response.toString());
      return _processResponse(response);
    } on SocketException {
      print('No Internet connection');
    } on TimeoutException {
      print('Api not responding');
    } catch (e) {
      print('Unknown error ' + e.toString());
    }
  }

  Future<dynamic> getMethodWithoutHeader(String baseUrl) async {
    var url = Uri.parse(baseUrl);
    try {
      final response = await http.get(url);
      return _processResponse(response);
    } on SocketException {
      print('No Internet connection');
      return "{\"errorMessage\":\"No Internet connection\"}";
    } on TimeoutException {
      print('Api not responding');
      return "{\"errorMessage\":\"Api not responding\"}";
    } catch (e) {
      print('Unknown error ' + e.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      var responseJson = utf8.decode(response.bodyBytes);

      //var responseJson =response.body;
      print(responseJson);
      return responseJson;
    } else {
      print(response.statusCode);

      return null;
    }
  }
}
