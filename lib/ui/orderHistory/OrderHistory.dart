import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/orderHistory/orderHistory.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/FullScreenImageScreen.dart';
import 'package:provider/provider.dart';

import 'OrderHistoryItems.dart';

class OrderHistory extends StatefulWidget {
  bool fromNotification;

  OrderHistory({this.fromNotification});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DataOrderHistory> dataList = new List();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  int _currentPageNumber = 1;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController = new ScrollController();

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
        if (dataList.length >= (PAGINATION_SIZE * _currentPageNumber) &&
            _loadMore) {
          isPullToRefresh = true;
          _hitApi();
          showInSnackBar("Loading data...");
        }
      }
    });
  }

  Future<void> _hitApi() async {
    if (!isPullToRefresh) {
      provider.setLoading(); //show loader
    }
    isPullToRefresh = false;

    if (_loadMore) {
      _currentPageNumber++;
    } else {
      _currentPageNumber = 1;
    }
    var response = await provider.getOrderHistory(context, _currentPageNumber);
    if (response is APIError) {
      if (response.status == 401) {
        showAlert(
          context: context,
          titleText: "Error",
          message: response.error,
          actionCallbacks: {
            "OK": () {
              onLogoutSuccess(context: context);
            }
          },
        );
      } else {
        showInSnackBar(response.error);
      }
    } else if (response is OrderHistoryResponse) {
      if (_currentPageNumber == 1) {
        dataList.clear();
      }
      dataList.addAll(response.data.dataInner);
      if (response.data.dataInner.length < response.data.perPage) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: widget.fromNotification
            ? AppBar(
                title: Text("Order History"),
                centerTitle: true,
              )
            : null,
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: <Widget>[
            RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                isPullToRefresh = true;
                _loadMore = false;
                await _hitApi();
              },
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return createCartListItem(
                      dataList[index], dataList[index].type);
                },
                itemCount: dataList.length ?? 0,
              ),
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
            (dataList.length == 0) && (provider.getLoading() == false)
                ? Center(
                    child:
                        getNoDataView(msg: "No Orders found.", onRetry: null))
                : Container()
          ],
        ));
  }

  createCartListItem(DataOrderHistory productList, int type) {
    return InkWell(
      onTap: () {
        if (type == 1) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => FullScreenImage(
                        imageSrc: productList.imageUrl,
                      )));
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => OrderItemsScreen(
                        dataList: productList.orderItems,
                        orderId: productList.id,
                      )));
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      color: Colors.blue.shade50,
                      image: DecorationImage(
                          image: NetworkImage(
                            type == 0
                                ? productList
                                        .orderItems?.first?.product?.imageUrl ??
                                    ""
                                : productList.imageUrl,
                          ),
                          fit: BoxFit.fill)),
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
                            "Order ID: ${type == 0 ? productList.orderItems.first.orderId : productList.id}",
                            maxLines: 2,
                            softWrap: true,
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 14),
                          ),
                        ),
                        getSpacer(height: 6),
                        Text(
                          "Price: ${getFormattedCurrency(productList.totalPrice.toDouble())}",
                          style: CustomTextStyle.textFormFieldRegular.copyWith(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Date: ${getFormattedDateString(dateTime: getDateFromString(dateString: productList.createdAt))}",
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
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 1),
    ));
  }
}
