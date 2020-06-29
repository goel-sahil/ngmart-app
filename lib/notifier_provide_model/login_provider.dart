import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:ngmartflutter/Network/APIHandler.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/Login/LoginRequest.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/model/otp/otp_request.dart';
import 'package:ngmartflutter/model/signUp/SignUpRequest.dart';

class LoginProvider with ChangeNotifier {
  var _isLoading = false;
  var userId;

  getLoading() => _isLoading;

  Future<dynamic> login(LoginRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {"Accept": "application/json"};

    var response = await APIHandler.post(
        context: context,
        url: APIs.login,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    print("Response==> ${response.error}");
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponseData =
          new LoginResponse.fromJson(jsonDecode(response));
      print("response ${loginResponseData.toJson()}");
      completer.complete(loginResponseData);
//        MemoryManagement.init();
//        MemoryManagement.setUserInfo(userInfo: json.encode(loginResponseData));
//        MemoryManagement.setuserId(id: loginResponseData.userId);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> signUp(SignUpRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {"Accept": "application/json"};

    var response = await APIHandler.post(
        context: context,
        url: APIs.register,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponseData = new LoginResponse.fromJson(response);
      print("response ${loginResponseData.toJson()}");
      userId = loginResponseData.data.user.id;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> verifyOtp(OtpRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {"Accept": "application/json"};

    var response = await APIHandler.post(
        context: context,
        url: APIs.otpVerify,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CommonResponse loginResponseData = new CommonResponse.fromJson(response);
      print("response ${loginResponseData.toJson()}");
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> resendOtp(OtpRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {"Accept": "application/json"};

    var response = await APIHandler.post(
        context: context,
        url: APIs.resendOtp,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CommonResponse loginResponseData = new CommonResponse.fromJson(response);
      print("response ${loginResponseData.toJson()}");
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }
}
