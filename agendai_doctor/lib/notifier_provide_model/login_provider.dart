import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';


class LoginProvider with ChangeNotifier {
  var _isLoading = false;
  var userId;

  getLoading() => _isLoading;

  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }
}
