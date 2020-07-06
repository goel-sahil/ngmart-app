import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/orderHistory/orderHistory.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:provider/provider.dart';

import 'OrderHistoryItems.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> with AutomaticKeepAliveClientMixin<OrderHistory>{
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<DataOrderHistory> dataList = new List();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Timer(Duration(milliseconds: 500), () {
      _hitApi();
    });
    super.initState();
  }

  Future<void> _hitApi() async {
    provider.setLoading();
    var response = await provider.getOrderHistory(context);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is OrderHistoryResponse) {
      dataList = response.data.dataInner;
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: <Widget>[
            ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return createCartListItem(dataList[index]);
              },
              itemCount: dataList.length ?? 0,
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

  createCartListItem(DataOrderHistory productList) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => OrderItemsScreen(
                      dataList: productList.orderItems,
                      orderId: productList.id,
                    )));
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
                              productList.orderItems.first.product.imageUrl))),
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
                            "Order ID: ${productList.orderItems.first.orderId}",
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
                                    .copyWith(color: Colors.green),
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
