import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:ngmartflutter/Network/APIHandler.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/admin/BrandResponse.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandRequest.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandResponse.dart';
import 'package:ngmartflutter/model/admin/brand/AdminBrandList.dart';
import 'package:ngmartflutter/model/admin/category/AdminCategoryResponse.dart';
import 'package:ngmartflutter/model/admin/category/CategoryListResponse.dart';
import 'package:ngmartflutter/model/admin/product/AdminProductRequest.dart';
import 'package:ngmartflutter/model/admin/product/AdminProductResponse.dart';

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

  Future<dynamic> getQuantity(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context, url: APIs.getQuantity, additionalHeaders: headers);

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

  Future<dynamic> getCategory(BuildContext context, int page) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context,
        url: "${APIs.category}?page=$page",
        additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      AdminCategoryResponse adminCategoryResponse =
          new AdminCategoryResponse.fromJson(response);
      completer.complete(adminCategoryResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getCategoryList(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context,
        url: APIs.getCategoryList,
        additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      CategoryListResponse adminCategoryResponse =
          new CategoryListResponse.fromJson(response);
      completer.complete(adminCategoryResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getBrandList(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context,
        url: APIs.getSelectBrandList,
        additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      AdminBrandList adminCategoryResponse =
      new AdminBrandList.fromJson(response);
      completer.complete(adminCategoryResponse);
      notifyListeners();
      return completer.future;
    }
  }




  Future<dynamic> getProducts(BuildContext context, int currentPageNumber,
      AdminProductRequest adminProductRequest) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.post(
        context: context,
        url: "${APIs.products}?page=$currentPageNumber",
        requestBody: adminProductRequest.toJson(),
        additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      AdminProductResponse adminCategoryResponse =
          new AdminProductResponse.fromJson(response);
      completer.complete(adminCategoryResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> deleteBrand(BuildContext context, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.delete(
        context: context,
        url: "${APIs.getBrands}/$id",
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

  Future<dynamic> deleteQuantity(BuildContext context, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.delete(
        context: context,
        url: "${APIs.getQuantity}/$id",
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

  Future<dynamic> deleteCategory(BuildContext context, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.delete(
        context: context,
        url: "${APIs.category}/$id",
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

  Future<dynamic> deleteProduct(BuildContext context, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.delete(
        context: context,
        url: "${APIs.product}/$id",
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



  Future<dynamic> addBrand(
      BuildContext context, AddBrandRequest request) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.post(
        context: context,
        url: "${APIs.addBrand}",
        additionalHeaders: headers,
        requestBody: request);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AddBrandResponse productResponse =
          new AddBrandResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> addQuantity(
      BuildContext context, AddBrandRequest request) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.post(
        context: context,
        url: "${APIs.getQuantity}",
        additionalHeaders: headers,
        requestBody: request);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AddBrandResponse productResponse =
          new AddBrandResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> updateBrand(
      BuildContext context, AddBrandRequest request, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.put(
        context: context,
        url: "${APIs.addBrand}/$id",
        additionalHeaders: headers,
        requestBody: request);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AddBrandResponse productResponse =
          new AddBrandResponse.fromJson(response);
      completer.complete(productResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> updateQuantity(
      BuildContext context, AddBrandRequest request, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.put(
        context: context,
        url: "${APIs.getQuantity}/$id",
        additionalHeaders: headers,
        requestBody: request);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AddBrandResponse productResponse =
          new AddBrandResponse.fromJson(response);
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
