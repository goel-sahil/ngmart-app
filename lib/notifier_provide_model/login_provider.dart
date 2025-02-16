import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:ngmartflutter/Network/APIHandler.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/LoginError.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/ChangePasswordRequest.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/Login/LoginRequest.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/model/forgotPassword/ForgotPassword.dart';
import 'package:ngmartflutter/model/otp/otp_request.dart';
import 'package:ngmartflutter/model/resetPassword/ResetPasswordRequest.dart';
import 'package:ngmartflutter/model/signUp/SignUpRequest.dart';
import 'package:ngmartflutter/ui/otp/otp_verification.dart';

class LoginProvider with ChangeNotifier {
  var _isLoading = false;
  var userId;

  getLoading() => _isLoading;

  Future<dynamic> login(LoginRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {"Accept": "application/json"};
    print("Request==> ${request.toJson()}");
    var response = await APIHandler.post(
        context: context,
        url: APIs.login,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    }else if(response is LoginError){
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponseData = new LoginResponse.fromJson(response);
      print("response ${loginResponseData.toJson()}");
      MemoryManagement.init();
      MemoryManagement.setAccessToken(
          accessToken: loginResponseData.data.token ?? "");
      MemoryManagement.setUserInfo(userInfo: json.encode(loginResponseData));
      MemoryManagement.setUserRole(role: loginResponseData.data.user.roleId);
      MemoryManagement.setLoggedInStatus(logInStatus: true);
      if (loginResponseData?.data?.user?.pushNotification == 1) {
        MemoryManagement.setNotificationOnOff(onoff: true);
      } else {
        MemoryManagement.setNotificationOnOff(onoff: false);
      }
      completer.complete(loginResponseData);
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

  Future<dynamic> profileUpdate(
      SignUpRequest request, BuildContext context) async {
    MemoryManagement.init();
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };

    var response = await APIHandler.post(
        context: context,
        url: APIs.profileUpdate,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponseData = new LoginResponse.fromJson(response);
      print("response ${loginResponseData.toJson()}");
      MemoryManagement.setUserInfo(userInfo: json.encode(loginResponseData));
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> verifyOtp(OtpRequest request, BuildContext context,
      String url, OTPType otpType) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {"Accept": "application/json"};
    print("Url==> $url");
    print("Request==> ${request.toJson()}");
    var response = await APIHandler.post(
        context: context,
        url: url,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponseData = new LoginResponse.fromJson(response);
      print("response ${loginResponseData.toJson()}");
      if (otpType == OTPType.REGISTER) {
        MemoryManagement.setAccessToken(
            accessToken: loginResponseData.data.token ?? "");
        MemoryManagement.setUserInfo(userInfo: json.encode(loginResponseData));
        MemoryManagement.setLoggedInStatus(logInStatus: true);
        if (loginResponseData?.data?.user?.pushNotification == 1) {
          MemoryManagement.setNotificationOnOff(onoff: true);
        } else {
          MemoryManagement.setNotificationOnOff(onoff: false);
        }
      }
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> resendOtp(
      OtpRequest request, BuildContext context, String url) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {"Accept": "application/json"};

    var response = await APIHandler.post(
        context: context,
        url: url,
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

  Future<dynamic> changePhoneVerify(
      OtpRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    MemoryManagement.init();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };

    var response = await APIHandler.post(
        context: context,
        url: APIs.changePhoneVerify,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponseData = new LoginResponse.fromJson(response);
      print("response ${loginResponseData.toJson()}");
      MemoryManagement.setUserInfo(userInfo: json.encode(loginResponseData));
      MemoryManagement.setLoggedInStatus(logInStatus: true);
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> forgotPassword(
      LoginRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {"Accept": "application/json"};

    var response = await APIHandler.post(
        context: context,
        url: APIs.forgotPassword,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ForgotPasswordResponse loginResponseData =
          new ForgotPasswordResponse.fromJson(response);
      print("response ${loginResponseData.toJson()}");
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> resetPassword(
      ResetPasswordRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {"Accept": "application/json"};
    print("Request==> ${request.toJson()}");
    var response = await APIHandler.post(
        context: context,
        url: APIs.resetPassword,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CommonResponse loginResponseData = new CommonResponse.fromJson(response);
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> changePhoneNumber(
      LoginRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    MemoryManagement.init();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.post(
        context: context,
        url: APIs.changePhone,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ForgotPasswordResponse loginResponseData =
          new ForgotPasswordResponse.fromJson(response);
      print("response ${loginResponseData.toJson()}");
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> changePassword(
      ChangePasswordRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };

    print("Request==> ${request.toJson()}");
    var response = await APIHandler.post(
        context: context,
        url: APIs.changePassword,
        requestBody: request.toJson(),
        additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CommonResponse loginResponseData = new CommonResponse.fromJson(response);
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
