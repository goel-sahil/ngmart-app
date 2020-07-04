import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ngmartflutter/Network/APIHandler.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/cart/AddToCartRequest.dart';
import 'package:ngmartflutter/model/cart/CartResponse.dart';
import 'package:ngmartflutter/model/categories_response.dart';
import 'package:ngmartflutter/model/orderHistory/orderHistory.dart';
import 'package:ngmartflutter/model/placeOrder/PlaceOrderRequest.dart';
import 'package:ngmartflutter/model/product/search_product_request.dart';
import 'package:ngmartflutter/model/product_request.dart';
import 'package:ngmartflutter/model/product_response.dart';

class DashboardProvider with ChangeNotifier {
  List<DataInner> productList = new List();
  List<DataInner> searchProductList = new List();

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

  Future<dynamic> getSearchedProducts(BuildContext context, String txt) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var request = SearchProductRequest(searchTxt: txt);
    var response = await APIHandler.post(
        context: context, url: APIs.getProducts, requestBody: request);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ProductResponse productResponse = new ProductResponse.fromJson(response);
      searchProductList.clear();
      searchProductList.addAll(productResponse.data.dataInner);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> addToCart(
      BuildContext context, num quantity, int productId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    MemoryManagement.init();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var request = AddToCartRequest(quantity: quantity, productId: productId);
    var response = await APIHandler.post(
        context: context,
        url: APIs.addToCart,
        requestBody: request,
        additionalHeaders: headers);

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

  Future<dynamic> getCart(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.get(
        context: context, url: APIs.addToCart, additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      CartResponse categoriesResponse = new CartResponse.fromJson(response);
      completer.complete(categoriesResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> removeFromCart(BuildContext context, int cartId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    MemoryManagement.init();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var url = "${APIs.addToCart}/$cartId";
    var response = await APIHandler.delete(
        context: context, url: url, additionalHeaders: headers);

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

  Future<dynamic> placeOrder(BuildContext context, int orderId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var request = PlaceOrderRequest(addressId: orderId);
    var response = await APIHandler.post(
        context: context,
        url: APIs.placeOrder,
        additionalHeaders: headers,
        requestBody: request);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      CommonResponse categoriesResponse = new CommonResponse.fromJson(response);
      completer.complete(categoriesResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getOrderHistory(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.get(
        context: context, url: APIs.getOrders, additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      OrderHistoryResponse productResponse =
          new OrderHistoryResponse.fromJson(response);
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
