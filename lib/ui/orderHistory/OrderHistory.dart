import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/orderHistory/orderHistory.dart';
import 'package:ngmartflutter/model/product_response.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/productDetail/ProductDetail.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DataOrderHistory> dataList=new List();
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
                return createCartListItem(dataList[index].orderItems.first);
              },
              itemCount: dataList.length ?? 0,
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
            (dataList.length == 0) &&
                    (provider.getLoading() == false)
                ? Center(
                    child:
                        getNoDataView(msg: "No Orders found.", onRetry: null))
                : Container()
          ],
        ));
  }

/*  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: CustomTextStyle.textFormFieldMedium
                      .copyWith(color: Colors.grey, fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  "\$299.00",
                  style: CustomTextStyle.textFormFieldBlack.copyWith(
                      color: Colors.greenAccent.shade700, fontSize: 14),
                ),
              ),
            ],
          ),
          getSpacer(height: 8),
          RaisedButton(
            onPressed: () {
//              Navigator.push(context,
//                  new MaterialPageRoute(builder: (context) => CheckOutPage()));
            },
            color: Colors.green,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Checkout",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(color: Colors.white),
            ),
          ),
          getSpacer(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }*/

  /* createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "SHOPPING CART",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 16, color: Colors.black),
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
  }*/

/*  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Total(3) Items",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 12, color: Colors.grey),
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }*/

/*  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return createCartListItem();
      },
      itemCount: 5,
    );
  }*/

  createCartListItem(OrderItems productList) {
    return InkWell(
      onTap: () {
//        Navigator.push(
//            context,
//            CupertinoPageRoute(
//                builder: (context) => ProductDetailPage(
//                      productData: productList,
//                    )));
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
                Hero(
                  transitionOnUserGestures: true,
                  tag: productList.product.title,
                  child: Container(
                    margin:
                        EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        color: Colors.blue.shade50,
                        image: DecorationImage(
                            image: NetworkImage(productList.product.imageUrl))),
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
                            productList.product.title,
                            maxLines: 2,
                            softWrap: true,
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 14),
                          ),
                        ),
                        getSpacer(height: 6),
                        Text(
                          productList.product.brand.title ?? "",
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
                                "\₹${productList.product.price} / ${productList.quantity} ${productList.product.quantityUnit.title}",
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
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value),duration: Duration(seconds: 1),));
  }
}
