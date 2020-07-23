import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/Messages.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/admin/product/AdminProductRequest.dart';
import 'package:ngmartflutter/model/admin/product/AdminProductResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:ngmartflutter/ui/admin/product/ProductDetail.dart';
import 'package:provider/provider.dart';

import 'AddProductScreen.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  AdminProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  int _currentPageNumber = 1;
  List<AdminProductList> productList = new List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    _setScrollListener();
    _currentPageNumber = 1;
    Timer(Duration(milliseconds: 500), () {
      _hitApi();
    });
    super.initState();
  }

  void _setScrollListener() {
    scrollController = new ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (productList.length >= (PAGINATION_SIZE * _currentPageNumber) &&
            _loadMore) {
          isPullToRefresh = true;
          _hitApi();
          showInSnackBar("Loading data...");
        }
      }
    });
  }

  Future<void> _hitApi({String text, bool fromSearch = false}) async {
    if (!isPullToRefresh && !fromSearch) {
      provider.setLoading(); //show loader
    }
    isPullToRefresh = false;

    if (_loadMore) {
      _currentPageNumber++;
    } else {
      _currentPageNumber = 1;
    }
    AdminProductRequest adminProductRequest = AdminProductRequest(search: text);
    var response = await provider.getProducts(
        context, _currentPageNumber, adminProductRequest);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is AdminProductResponse) {
      if (_currentPageNumber == 1) {
        productList.clear();
      }

      productList.addAll(response.data.dataInner);

      if (response.data.dataInner.length < response.data.perPage) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }
    }
  }

  _hitDeleteProductApi({int id, int position}) async {
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(
          context: context, title: "Error", message: Messages.noInternetError);
      return;
    }
    provider.setLoading();

    var response = await provider.deleteProduct(context, id);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is CommonResponse) {
      showInSnackBar(response.message);
      productList.removeAt(position);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AdminProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            RefreshIndicator(
              key: _refreshIndicatorKey,
              child: Container(
                margin: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: getScreenSize(context: context).height,
                        height: 50,
                        child: new TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            _loadMore = false;
                            _hitApi(text: value, fromSearch: true);
                          },
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: AppColors.kPrimaryBlue)),
                              hintText: 'Search for product',
                              labelText: 'Search for product',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.kPrimaryBlue,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  productList.clear();
                                  setState(() {});
                                  _currentPageNumber = 1;
                                  _hitApi();
                                },
                                icon: Icon(Icons.clear),
                              )),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return createCartListItem(
                                index: index, productList: productList[index]);
                          },
                          itemCount: productList.length ?? 0,
                          controller: scrollController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onRefresh: () async {
                isPullToRefresh = true;
                _loadMore = false;
                await _hitApi();
              },
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
            (productList.length == 0) && (provider.getLoading() == false)
                ? Center(
                    child:
                        getNoDataView(msg: "No Product found.", onRetry: null))
                : Container()
          ],
        ));
  }

  createCartListItem({AdminProductList productList, int index}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AdminProductDetailPage(
                      productData: productList,
                    )));
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Edit',
            color: Colors.black45,
            icon: Icons.edit,
            onTap: () async {
              var isUpdated = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddProductScreen(
                            fromProductScreen: true,
                            adminProductItem: productList,
                          )));
              if (isUpdated != null && isUpdated) {
                _currentPageNumber = 1;
                _loadMore = false;
                _hitApi();
              }
            },
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              _hitDeleteProductApi(id: productList.id, position: index);
            },
          ),
        ],
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: <Widget>[
                  Hero(
                    transitionOnUserGestures: true,
                    tag: productList.title,
                    child: Container(
                      margin:
                          EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.blue.shade50,
                          image: DecorationImage(
                              image: NetworkImage(productList.imageUrl))),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 4),
                            child: Text(
                              productList.title,
                              maxLines: 2,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                          getSpacer(height: 6),
                          Text(
                            productList.brand.title ?? "",
                            style:
                                CustomTextStyle.textFormFieldRegular.copyWith(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "${getFormattedCurrency(productList.price.toDouble())} / ${productList.quantity} ${productList.quantityUnit.title}",
                                  style: CustomTextStyle.textFormFieldBlack
                                      .copyWith(color: AppColors.kPrimaryBlue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 100,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
