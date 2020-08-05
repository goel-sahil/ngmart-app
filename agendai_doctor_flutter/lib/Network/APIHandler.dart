import 'dart:async';
import 'dart:convert';
import 'package:agendaiDoctor/Network/api_error.dart';
import 'package:agendaiDoctor/helper/Messages.dart';
import 'package:agendaiDoctor/helper/UniversalFunctions.dart';
import 'package:agendaiDoctor/helper/UniversalProperties.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'LoginError.dart';


enum MethodType { POST, GET, PUT, DELETE }

class APIHandler {
  static Map<String, String> defaultHeaders = {
    "Content-Type": "application/json",
    "device_type": isAndroid() ? "1" : "2",
    "app_version": "1.0.0",
  };

  static Dio dio = Dio();

  // POST method
  static Future<dynamic> post({
    dynamic requestBody,
    @required BuildContext context,
    String url,
    Map<String, String> additionalHeaders = const {},
  }) async {
    return await _hitApi(
      context: context,
      url: url,
      methodType: MethodType.POST,
      requestBody: requestBody,
      additionalHeaders: additionalHeaders,
    );
  }

  // GET method
  static Future<dynamic> get({
    @required String url,
    @required BuildContext context,
    dynamic requestBody,
    Map<String, String> additionalHeaders = const {},
  }) async {
    return await _hitApi(
      context: context,
      url: url,
      methodType: MethodType.GET,
      requestBody: requestBody,
      additionalHeaders: additionalHeaders,
    );
  }

  // GET method
  static Future<dynamic> delete({
    @required String url,
    @required BuildContext context,
    Map<String, String> additionalHeaders = const {},
  }) async {
    return await _hitApi(
      context: context,
      url: url,
      methodType: MethodType.DELETE,
      additionalHeaders: additionalHeaders,
    );
  }

  // PUT method
  static Future<dynamic> put({
    @required dynamic requestBody,
    @required BuildContext context,
    @required String url,
    Map<String, String> additionalHeaders = const {},
  }) async {
    return await _hitApi(
      context: context,
      url: url,
      methodType: MethodType.PUT,
      requestBody: requestBody,
      additionalHeaders: additionalHeaders,
    );
  }

  // Generic HTTP method
  static Future<dynamic> _hitApi({
    @required BuildContext context,
    @required MethodType methodType,
    @required String url,
    dynamic requestBody,
    Map<String, String> additionalHeaders = const {},
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    try {
      Map<String, String> headers = {};
      headers.addAll(defaultHeaders);
      headers.addAll(additionalHeaders);
      print("Headers==> $headers");
      var response;
      switch (methodType) {
        case MethodType.POST:
          response = await dio
              .post(
                url,
                options: Options(
                  headers: headers,
                ),
                data: requestBody,
              )
              .timeout(timeoutDuration);

          break;
        case MethodType.GET:
          response = await dio
              .get(url,
                  options: Options(
                    headers: headers,
                  ),
                  queryParameters: requestBody)
              .timeout(timeoutDuration);
          break;
        case MethodType.PUT:
          response = await dio
              .put(
                url,
                data: json.encode(requestBody),
                options: Options(
                  headers: headers,
                ),
              )
              .timeout(timeoutDuration);
          break;
        case MethodType.DELETE:
          response = await dio
              .delete(
                url,
                options: Options(
                  headers: headers,
                ),
              )
              .timeout(timeoutDuration);
          break;
      }

      print("url: ${url}");
      print("Request==>: ${json.encode(requestBody)}");
      print("Response==>: ${response.data}");
      print("Status code ${response?.statusCode}");

      completer.complete(response.data);
    } on DioError catch (e) {
      print("error ${e.response?.statusCode}");
      print("message ${e.response?.data}");
      print("Status code ${e.response?.statusCode}");

      if (e.response?.statusCode == 403) {
        LoginError apiError = new LoginError(
          error: parseError(e.response.data),
          status: 403,
          id: e.response.data["data"]["user"]["id"],
          onAlertPop: () {},
        );
        completer.complete(apiError);
      } else if (e.response?.statusCode == 401) {
        APIError apiError = new APIError(
          error: Messages.unAuthorizedError,
          status: 401,
          onAlertPop: () {
            onLogoutSuccess(
              context: context,
            );
          },
        );
        completer.complete(apiError);
      } else {
        APIError apiError = new APIError(
            error: parseError(e.response?.data ?? Messages.genericError),
            status: e.response?.statusCode ?? 0);
        completer.complete(apiError);
      }
    } catch (e) {
      print("errro ${e.toString()}");
      APIError apiError =
          new APIError(error: Messages.genericError, status: 500);
      completer.complete(apiError);
    }
    return completer.future;
  }

  static String parseError(dynamic response) {
    try {
      return response["message"];
    } catch (e) {
      return Messages.genericError;
    }
  }
}
