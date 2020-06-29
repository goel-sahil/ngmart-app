import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';

class LoginProvider with ChangeNotifier {
  var _isLoading = false;

  getLoading() => _isLoading;


//  Future<dynamic> forgotPassword(
//      ForgotPasswordRequest request, BuildContext context) async {
//    Completer<dynamic> completer = new Completer<dynamic>();
//    Map<String, String> headers = {
//      "Content-Type": "application/x-www-form-urlencoded"
//    };
//
//    var response = await APIHandler.post(
//        context: context,
//        url: APIs.forgotPassword,
//        requestBody: request.toJson(),
//        additionalHeaders: headers);
//
//    hideLoader();
//    if (response is APIError) {
//      completer.complete(response);
//      return completer.future;
//    } else {
//      print("Forogt Response==> ${jsonDecode(response)}");
//      ForgotResponse forgotPasswordResponse =
//          new ForgotResponse.fromJson(jsonDecode(response));
//      print("response ${forgotPasswordResponse.toJson()}");
//      //check if error
//      if (forgotPasswordResponse.error == "1") {
//        APIError apiError =
//            new APIError(error: forgotPasswordResponse.msg ?? "", status: 400);
//        completer.complete(apiError);
//      } else {
//        completer.complete(forgotPasswordResponse);
//      }
//      notifyListeners();
//      return completer.future;
//    }
//  }

  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }
}
