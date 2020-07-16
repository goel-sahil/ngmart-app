import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:ngmartflutter/Network/APIHandler.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/ChangePasswordRequest.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/Login/LoginRequest.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/model/admin/BrandResponse.dart';
import 'package:ngmartflutter/model/cms/CmsResponse.dart';
import 'package:ngmartflutter/model/forgotPassword/ForgotPassword.dart';
import 'package:ngmartflutter/model/otp/otp_request.dart';
import 'package:ngmartflutter/model/resetPassword/ResetPasswordRequest.dart';
import 'package:ngmartflutter/model/signUp/SignUpRequest.dart';
import 'package:ngmartflutter/ui/otp/otp_verification.dart';

class AdminProvider with ChangeNotifier {
  var _isLoading = false;

  getLoading() => _isLoading;

  Future<dynamic> getBrands(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context, url: APIs.getBrands, additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      BranResponse productResponse = new BranResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> deleteBrand(BuildContext context,int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.delete(
        context: context, url: "${APIs.getBrands}/$id", additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      CommonResponse productResponse = new CommonResponse.fromJson(response);
      completer.complete(productResponse);
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
