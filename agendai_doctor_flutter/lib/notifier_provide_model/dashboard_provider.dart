import 'dart:async';

import 'package:flutter/cupertino.dart';


class DashboardProvider with ChangeNotifier {

  var _isLoading = false;

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
