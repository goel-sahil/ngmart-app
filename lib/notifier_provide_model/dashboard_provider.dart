import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ngmartflutter/Network/APIHandler.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/model/categories_response.dart';
import 'package:ngmartflutter/model/product_request.dart';
import 'package:ngmartflutter/model/product_response.dart';

class DashboardProvider with ChangeNotifier {
  List<DataInner> productList = new List();

  var _isLoading = false;

  getLoading() => _isLoading;

  Future<dynamic> getCategories(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var response =
        await APIHandler.get(context: context, url: APIs.getCategories);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      CategoriesResponse categoriesResponse =
          new CategoriesResponse.fromJson(response);
      completer.complete(categoriesResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getProducts(BuildContext context, int catId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    productList.clear();
    var request = ProductRequest(categoryId: [catId]);
    var response = await APIHandler.post(
        context: context, url: APIs.getProducts, requestBody: request);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      ProductResponse productResponse = new ProductResponse.fromJson(response);
      productList.addAll(productResponse.data.dataInner);
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
