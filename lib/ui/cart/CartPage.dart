import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/UniversalProperties.dart';
import 'package:ngmartflutter/helper/styles.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/cart/AddToCartRequest.dart';
import 'package:ngmartflutter/model/cart/AddToCartResponse.dart';
import 'package:ngmartflutter/model/cart/CartResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/checkout/CheckOutPage.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  bool fromNavigationDrawer = false;

  CartPage({this.fromNavigationDrawer});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CartData> cartList = new List();
  num _quantity = 1;
  num _perQuantity = 1;
  num total = 0.0;

  @override
  void initState() {
    Timer(Duration(milliseconds: 500), () {
      _hitApi();
    });
    super.initState();
  }

//  @override
//  bool get wantKeepAlive => true;

  Future<void> _hitApi() async {
    provider.setLoading();
    var response = await provider.getCart(context);
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
    } else if (response is CartResponse) {
      cartList.addAll(response.data);
      for (var data in cartList) {
        total += data.quantity * data.pricePerUnit;
      }

      print("First total==> $total");
      setState(() {});
    }
  }

  Future<void> _hitUpdateQuantity(
      {num quantity, int productId, bool fromAdd}) async {
    provider?.setLoading();
    var response = await provider.addToCart(context, quantity, productId);
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
      }
    } else if (response is CommonResponse) {}
  }

  Future<void> _hitRemoveItemFromCart({int cartId, int position}) async {
    provider?.setLoading();
    var response = await provider.removeFromCart(context, cartId);
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
    } else if (response is AddToCartResponse) {
      showInSnackBar(response.message);
      total = total -
          (cartList[position].quantity * cartList[position].pricePerUnit);
      cartList.removeAt(position);
      cartCount = response.data.totalCartItems;
      setState(() {});
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      key: _scaffoldKey,
      appBar: widget.fromNavigationDrawer
          ? null
          : AppBar(
              title: Text("Shopping Cart"),
              centerTitle: true,
            ),
      body: Stack(
        children: <Widget>[
          cartList.isNotEmpty
              ? SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      createHeader(),
                      createSubTitle(),
                      createCartList(),
                      footer(context)
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        color: AppColors.kPrimaryBlue,
                        size: 60,
                      ),
                      getSpacer(height: 4),
                      Text(
                        "Your cart empty.",
                        style: h4,
                      ),
                      getSpacer(height: 4),
                      Text(
                        "Looks like you have not added anything to your cart yet.",
                        style: h6.copyWith(
                            color: AppColors.kBlackGrey, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: provider.getLoading(),
              context: context,
            ),
          )
        ],
      ),
    );
  }

  footer(BuildContext context) {
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
                  "${getFormattedCurrency(total.toDouble())}",
                  style: CustomTextStyle.textFormFieldBlack.copyWith(
                      color: Colors.greenAccent.shade700, fontSize: 14),
                ),
              ),
            ],
          ),
          getSpacer(height: 8),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => CheckOutPage(
                            cartList: cartList,
                            total: total,
                            fromBuyNow: false,
                          )));
            },
            color: AppColors.kPrimaryBlue,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Place order",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(color: Colors.white),
            ),
          ),
          getSpacer(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "SHOPPING CART",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 16, color: Colors.black),
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Total(${cartList.length ?? 0}) Items",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 12, color: Colors.grey),
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, position) {
        _quantity = cartList[position].quantity;
        _perQuantity = cartList[position].initialQuantity;
        total = 0;
        for (var data in cartList) {
          total = total + (data.quantity * data.pricePerUnit);
        }

//        print(
//            "${cartList[position].product.title}==> ${cartList[position].toJson()}");

        return createCartListItem(listData: cartList[position], pos: position);
      },
      itemCount: cartList.length ?? 0,
    );
  }

  createCartListItem({CartData listData, int pos}) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
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
                        image: NetworkImage(listData.product.imageUrl))),
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
                          "${listData.product.title} (${getFormattedCurrency(listData.product.price.toDouble())} / ${listData.product.quantity} ${listData.product.quantityUnit.title})" ??
                              "",
                          maxLines: 2,
                          softWrap: true,
                          style: CustomTextStyle.textFormFieldSemiBold
                              .copyWith(fontSize: 14),
                        ),
                      ),
                      getSpacer(height: 6),
                      Text(
                        listData.product?.brand?.title ?? "",
                        style: CustomTextStyle.textFormFieldRegular
                            .copyWith(color: Colors.grey, fontSize: 14),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${getFormattedCurrency((listData.pricePerUnit * listData.quantity).toDouble())}",
                              style: CustomTextStyle.textFormFieldBlack
                                  .copyWith(
                                      color: AppColors.kPrimaryBlue,
                                      fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      print("_quantity==>${listData.quantity}");
                                      print(
                                          "quantityIncrement==>${listData.product.quantityIncrement}");

                                      if (listData.quantity <=
                                              listData
                                                  .product.quantityIncrement ||
                                          _quantity.toStringAsFixed(1) ==
                                              listData?.product?.quantity
                                                  ?.toStringAsFixed(1)) {
                                        return;
                                      }

                                      _quantity -=
                                          listData.product.quantityIncrement;
                                      listData.quantity = (listData.quantity -
                                          listData.product.quantityIncrement);
                                      //hit APi
                                      _hitUpdateQuantity(
                                          quantity: listData.quantity,
                                          productId: listData.productId);

                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      size: 24,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.only(
                                        bottom: 2, right: 12, left: 12),
                                    child: Text(
                                      _quantity.toStringAsFixed(2) ?? "1",
                                      style:
                                          CustomTextStyle.textFormFieldSemiBold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _quantity +=
                                            listData.product.quantityIncrement;
                                        listData.quantity = (listData.quantity +
                                            listData.product.quantityIncrement);
                                      });
                                      _hitUpdateQuantity(
                                          quantity: listData.quantity,
                                          productId: listData.productId);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Colors.grey.shade700,
                                    ),
                                  )
                                ],
                              ),
                            )
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
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              _hitRemoveItemFromCart(position: pos, cartId: listData.id);
            },
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10, top: 8),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.green),
            ),
          ),
        )
      ],
    );
  }
}
