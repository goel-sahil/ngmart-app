import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ngmartflutter/Network/APIHandler.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/DeviceTokenRequest.dart';
import 'package:ngmartflutter/model/NotificationResponse.dart';
import 'package:ngmartflutter/model/bannerResponse/bannerResponse.dart';
import 'package:ngmartflutter/model/cart/AddToCartRequest.dart';
import 'package:ngmartflutter/model/cart/CartResponse.dart';
import 'package:ngmartflutter/model/categories_response.dart';
import 'package:ngmartflutter/model/cms/CmsResponse.dart';
import 'package:ngmartflutter/model/contactUs/ContactUsRequest.dart';
import 'package:ngmartflutter/model/orderHistory/orderHistory.dart';
import 'package:ngmartflutter/model/placeOrder/PlaceOrderRequest.dart';
import 'package:ngmartflutter/model/placeOrder/PlaceSingleOrder.dart';
import 'package:ngmartflutter/model/product/search_product_request.dart';
import 'package:ngmartflutter/model/product_request.dart';
import 'package:ngmartflutter/model/product_response.dart';

class DashboardProvider with ChangeNotifier {
  List<CategoryData> categoryList = new List();

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
      categoryList.addAll(categoriesResponse.data);
      completer.complete(categoriesResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getProducts(
      BuildContext context, int catId, int currentPageNumber) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var request = ProductRequest(categoryId: [catId], page: currentPageNumber);
    var response = await APIHandler.post(
        context: context, url: APIs.getProducts, requestBody: request);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      ProductResponse productResponse = new ProductResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getSearchedProducts(
      BuildContext context, String txt, int currentPageNumber) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var request = SearchProductRequest(searchTxt: txt, page: currentPageNumber);
    var response = await APIHandler.post(
        context: context, url: APIs.getProducts, requestBody: request);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ProductResponse productResponse = new ProductResponse.fromJson(response);
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

  Future<dynamic> placeSingleOrder(
      BuildContext context, num quantity, int productId, int addressId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    MemoryManagement.init();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var request = PlaceSingleOrder(
        quantity: quantity, productId: productId, addressId: addressId);
    var response = await APIHandler.post(
        context: context,
        url: APIs.placeSingleOrder,
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

  Future<dynamic> getBanners(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    MemoryManagement.init();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.get(
        context: context, url: APIs.banners, additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      BannerResponse bannerResponse = new BannerResponse.fromJson(response);
      print("Banner Response==> ${bannerResponse.toJson()}");
      completer.complete(bannerResponse);
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

  Future<dynamic> getOrderHistory(
      BuildContext context, int currentPageNumber) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.get(
        context: context,
        url: "${APIs.getOrders}?page=$currentPageNumber",
        additionalHeaders: headers);

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

  Future<dynamic> contactUs(
      ContactUsRequest request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Request==> ${request.toJson()}");
    var response = await APIHandler.post(
        context: context,
        url: APIs.contactUs,
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

  Future<dynamic> cmsData(BuildContext context, String url) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.get(
        context: context, url: url, additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      CmsResponse productResponse = new CmsResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getNotifications(
      BuildContext context, int currentPageNumber) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context,
        url: "${APIs.notification}?page=$currentPageNumber",
        additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      NotificationResponse productResponse =
          new NotificationResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> deleteNotification(BuildContext context, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };

    var response = await APIHandler.delete(
        context: context,
        url: "${APIs.getNotifications}/$id",
        additionalHeaders: headers);
    print("Notification==> ${APIs.getNotifications}");
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CommonResponse productResponse = new CommonResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> notification(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    MemoryManagement.init();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.post(
        context: context, url: APIs.notification, additionalHeaders: headers);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CommonResponse productResponse = new CommonResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> updateToken(
      BuildContext context, DeviceTokenResponse request) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    MemoryManagement.init();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.post(
        context: context,
        url: APIs.token,
        additionalHeaders: headers,
        requestBody: request);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CommonResponse productResponse = new CommonResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> cancelOrder(BuildContext context, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    MemoryManagement.init();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var url = "${APIs.cancelOrder}/$id";
    print("Url==> $url");
    var response = await APIHandler.put(
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

  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }
}
