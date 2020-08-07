import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/admin/banner/BannerResponse.dart';
import 'package:ngmartflutter/model/admin/product/AdminProductRequest.dart';
import 'package:ngmartflutter/model/admin/product/AdminProductResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatefulWidget {
  List<Products> selectedProductList;

  SelectProductScreen({this.selectedProductList});

  @override
  _SelectProductScreenState createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  AdminProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  int _currentPageNumber = 1;
  List<Products> productList = new List();

//  List<Products> selectedProductList = new List();
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
    var response = await provider.bannerProducts(
        context, _currentPageNumber, adminProductRequest);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is AdminProductResponse) {
      if (_currentPageNumber == 1) {
        productList.clear();
      }

      productList.addAll(response.data.dataInner);
      _showSelectedIfAny();
      _compareLists();

      if (response.data.dataInner.length < response.data.perPage) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }
    }
  }

  _showSelectedIfAny() {
    if (widget.selectedProductList?.isNotEmpty == true) {
      for (int i = 0; i < productList.length; i++) {
        for (int j = 0; j < widget.selectedProductList.length; j++) {
          if (productList[i].id == widget.selectedProductList[j].id) {
            productList[i].isSelected = true;
          }
        }
      }
    }
    setState(() {});
  }

  _compareLists() {
    if (widget?.selectedProductList?.isNotEmpty == true) {
      for (int i = 0; i < productList.length; i++) {
        for (int j = 0; j < widget.selectedProductList.length; j++) {
          if (productList[i].id == widget.selectedProductList[j].id) {
            productList[i].isSelected = true;
          }
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AdminProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Select Products"),
          centerTitle: true,
          actions: <Widget>[
            InkWell(
              onTap: () {
//                for (int i = 0; i < productList.length; i++) {
//                  if (productList[i].isSelected) {
//                    print("Selected item==>  ${productList[i].title}");
//                    selectedProductList.add(productList[i]);
//                  }
//                }
//                print("List size==> ${selectedProductList.length}");
                Navigator.pop(context, widget.selectedProductList);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 18, right: 10),
                child: Text("Done"),
              ),
            )
          ],
        ),
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
                          physics: AlwaysScrollableScrollPhysics(),
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

  createCartListItem({Products productList, int index}) {
    return InkWell(
        onTap: () {},
        child: new CheckboxListTile(
          title: new Text(productList.title),
          value: productList.isSelected,
          onChanged: (bool value) {
            if (value == true) {
              widget.selectedProductList.add(productList);
            } else {
              for (int i = 0; i < widget.selectedProductList.length; i++) {
                if (widget.selectedProductList[i].id == productList.id) {
                  widget.selectedProductList.removeAt(i);
                }
              }
            }
            productList.isSelected = value;
            print("List size===> ${widget.selectedProductList.length}");
            setState(() {});
          },
        ));
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
