import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/UniversalProperties.dart';
import 'package:ngmartflutter/helper/buttons.dart';
import 'package:ngmartflutter/helper/colors.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/helper/styles.dart';
import 'package:ngmartflutter/model/cart/AddToCartResponse.dart';
import 'package:ngmartflutter/model/cart/CartResponse.dart';
import 'package:ngmartflutter/model/product_response.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/cart/CartPage.dart';
import 'package:ngmartflutter/ui/checkout/CheckOutPage.dart';
import 'package:ngmartflutter/ui/login/login_screen.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final String pageTitle;
  final DataInner productData;

  ProductDetailPage({Key key, this.pageTitle, this.productData})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  num _quantity = 1;
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  var _userLoggedIn = false;

  Future<void> _hitApi(
      {num quantity, int productId, bool fromBuyNow = false}) async {
    provider.setLoading();
    var response = await provider.addToCart(context, quantity, productId);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is AddToCartResponse) {
      showInSnackBar(response.message);
      cartCount = response.data.totalCartItems;
      setState(() {});
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  void initState() {
    _quantity = widget?.productData?.quantity ?? "";
    MemoryManagement.init();
    _userLoggedIn = MemoryManagement.getLoggedInStatus() ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
        backgroundColor: bgColor,
        key: _scaffoldKeys,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.kPrimaryBlue,
          centerTitle: true,
          title: Text(widget.productData.title,
              style: h4.copyWith(color: Colors.white)),
          actions: <Widget>[
            getCartWidget(
                count: cartCount,
                onClick: () {
                  if (_userLoggedIn) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => CartPage(
                                  fromNavigationDrawer: false,
                                )));
                  } else {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Login()));
                  }
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 100, bottom: 100),
                            padding: EdgeInsets.only(top: 100, bottom: 50),
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("${widget?.productData?.title ?? ""}",
                                    style: h3),
                                getSpacer(height: 6),
                                Text(widget?.productData?.brand?.title ?? "",
                                    style: h4),
                                getSpacer(height: 6),
                                Text(
                                    "${getFormattedCurrency(widget?.productData?.price?.toDouble())} / ${widget?.productData?.quantity} ${widget?.productData?.quantityUnit?.title}",
                                    style: h5),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 20),
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                            '${widget?.productData?.category?.title}',
                                            style: h5),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                            widget?.productData?.description ??
                                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages',
                                            maxLines: 7,
                                            overflow: TextOverflow.ellipsis,
                                            style: descText),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 6, bottom: 25),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Text('Quantity', style: h6),
                                        margin: EdgeInsets.only(bottom: 15),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 55,
                                            height: 55,
                                            child: OutlineButton(
                                              onPressed: () {
                                                debugPrint(
                                                    "Quantity Inc==> ${widget.productData.quantityIncrement}");
                                                setState(() {
                                                  _quantity += widget
                                                      .productData
                                                      .quantityIncrement;
                                                  debugPrint(
                                                      "Final quantity==> $_quantity");
                                                });
                                              },
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Text(
                                                _quantity.toStringAsFixed(2),
                                                style: h3),
                                          ),
                                          Container(
                                            width: 55,
                                            height: 55,
                                            child: OutlineButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (_quantity ==
                                                          widget.productData
                                                              .quantityIncrement ||
                                                      _quantity <
                                                          widget.productData
                                                              .quantityIncrement ||
                                                      _quantity.toStringAsFixed(
                                                              1) ==
                                                          widget?.productData
                                                              ?.quantity
                                                              ?.toStringAsFixed(
                                                                  1)) {
                                                    return;
                                                  }
                                                  debugPrint(
                                                      "Quantity==> $_quantity");
                                                  debugPrint(
                                                      "Quantity Inc==> ${widget.productData.quantityIncrement}");
                                                  _quantity -= widget
                                                      .productData
                                                      .quantityIncrement;
                                                  debugPrint(
                                                      "Final quantity==> $_quantity");
                                                });
                                              },
                                              child: Icon(Icons.remove),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 180,
                                  child: froyoOutlineBtn('Buy Now', () {
                                    if (_userLoggedIn) {
                                      var price = ((widget.productData.price /
                                              widget.productData.quantity) *
                                          _quantity);
                                      var brand = CartBrand(
                                          title: widget
                                                  ?.productData?.brand?.title ??
                                              "");
                                      var product = Product(
                                          title:
                                              widget?.productData?.title ?? "",
                                          brand: brand,
                                          quantity: _quantity,
                                          imageUrl:
                                              widget?.productData?.imageUrl ??
                                                  "");
                                      var cartData = CartData(
                                          productId: widget.productData.id,
                                          product: product,
                                          quantity: _quantity);
                                      var list = List<CartData>();
                                      list.add(cartData);
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  CheckOutPage(
                                                    cartList: list,
                                                    total: price,
                                                    fromBuyNow: true,
                                                    productId:
                                                        widget.productData.id,
                                                    quantity: _quantity,
                                                  )));
                                    } else {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => Login()));
                                    }
                                  }),
                                ),
                                Container(
                                  width: 180,
                                  child: froyoFlatBtn('Add to Cart', () {
                                    if (_userLoggedIn) {
                                      _hitApi(
                                          productId: widget.productData.id,
                                          quantity: _quantity);
                                    } else {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => Login()));
                                    }
                                  }),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                      color: Color.fromRGBO(0, 0, 0, .05))
                                ]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            height: 160,
                            child: foodItem(widget.productData,
                                isProductPage: true,
                                onTapped: () {},
                                imgWidth: 250,
                                onLike: () {}),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
          ],
        ));
  }

  Widget foodItem(DataInner food,
      {double imgWidth, onLike, onTapped, bool isProductPage = false}) {
    return Container(
      width: 180,
      height: 180,
      // color: Colors.red,
      margin: EdgeInsets.only(left: 20),
      child: Stack(
        children: <Widget>[
          Container(
              width: 180,
              height: 180,
              child: RaisedButton(
                  color: white,
                  elevation: (isProductPage) ? 20 : 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: onTapped,
                  child: Hero(
                      transitionOnUserGestures: true,
                      tag: food.title,
                      child: Image.network(
                        food.imageUrl,
                        width: (imgWidth != null) ? imgWidth : 100,
                        fit: BoxFit.cover,
                      )))),
          Positioned(
            bottom: 0,
            left: 0,
            child: (!isProductPage)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(food.title, style: foodNameText),
                      Text(food.price.toString(), style: priceText),
                    ],
                  )
                : Text(' '),
          ),
        ],
      ),
    );
  }
}
