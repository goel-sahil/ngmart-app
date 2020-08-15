import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:ngmartflutter/Network/APIHandler.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/admin/ContactUs/ContactResponse.dart';
import 'package:ngmartflutter/model/admin/banner/BannerResponse.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandRequest.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandResponse.dart';
import 'package:ngmartflutter/model/admin/brand/AdminBrandList.dart';
import 'package:ngmartflutter/model/admin/brand/BrandResponse.dart';
import 'package:ngmartflutter/model/admin/category/AdminCategoryResponse.dart';
import 'package:ngmartflutter/model/admin/category/CategoryListResponse.dart';
import 'package:ngmartflutter/model/admin/cms/CmsRequest.dart';
import 'package:ngmartflutter/model/admin/cms/CmsResponse.dart';
import 'package:ngmartflutter/model/admin/order/OrderStatusRequest.dart';
import 'package:ngmartflutter/model/admin/product/AdminProductRequest.dart';
import 'package:ngmartflutter/model/admin/product/AdminProductResponse.dart';
import 'package:ngmartflutter/model/admin/order/AdminOrderResponse.dart';
import 'package:ngmartflutter/model/admin/InvoiceResponse.dart';

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

  Future<dynamic> getBanners(
      BuildContext context, int currentPageNumber) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context,
        url: "${APIs.getBanners}?page=$currentPageNumber",
        additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      BannerResponse productResponse = new BannerResponse.fromJson(response);
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

  Future<dynamic> getOrders(BuildContext context, String url) async {
    print("Url==> $url");
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");
    var response = await APIHandler.get(
        context: context, url: url, additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      AdminOrderResponse productResponse =
          new AdminOrderResponse.fromJson(response);
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

  Future<dynamic> getCategoryList(
      BuildContext context, String catId, bool forUpdate) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");
    var url;
    if (forUpdate) {
      url = "${APIs.getCategoryList}?category_id=$catId";
    } else {
      url = "${APIs.getCategoryList}";
    }
    print("Cat url==> $url");
    var response = await APIHandler.get(
        context: context, url: url, additionalHeaders: headers);

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

  Future<dynamic> getSubCategoryList(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context,
        url: "${APIs.getCategoryList}?sub_category=1",
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

  Future<dynamic> getQuantityUnitList(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context,
        url: APIs.getQuantityUnitList,
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


  Future<dynamic> bannerProducts(BuildContext context, int currentPageNumber,
      AdminProductRequest adminProductRequest) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.post(
        context: context,
        url: "${APIs.bannerProducts}?page=$currentPageNumber",
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

  Future<dynamic> getInvoice(
    BuildContext context,
    int id,
  ) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    print("Token==> ${MemoryManagement.getAccessToken()}");

    var response = await APIHandler.get(
        context: context,
        url: "${APIs.adminOrders}/$id/invoice",
        additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      InvoiceResponse adminCategoryResponse =
          new InvoiceResponse.fromJson(response);
      completer.complete(adminCategoryResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getCms(
    BuildContext context,
  ) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };

    var response = await APIHandler.get(
        context: context, url: "${APIs.cms}", additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      CmsResponse adminCategoryResponse = new CmsResponse.fromJson(response);
      completer.complete(adminCategoryResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getContacts(
      BuildContext context,
      ) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };

    var response = await APIHandler.get(
        context: context, url: "${APIs.contacts}", additionalHeaders: headers);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("Response==> $response");
      ContactResponse adminCategoryResponse = new ContactResponse.fromJson(response);
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

  Future<dynamic> updateOrderStatus(BuildContext context, int id,
      OrderStatusRequest orderStatusequest) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.put(
        context: context,
        url: "${APIs.adminOrders}/$id",
        requestBody: orderStatusequest,
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

  Future<dynamic> deleteBanner(BuildContext context, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.delete(
        context: context,
        url: "${APIs.getBanners}/$id",
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

  Future<dynamic> deleteContact(BuildContext context, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.delete(
        context: context,
        url: "${APIs.contacts}/$id",
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


  Future<dynamic> updateCms(
      BuildContext context, CmsRequest request, int id) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };
    var response = await APIHandler.put(
        context: context,
        url: "${APIs.cms}/$id",
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
