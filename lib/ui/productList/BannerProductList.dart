
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/product_response.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/cart/CartPage.dart';
import 'package:ngmartflutter/ui/productDetail/ProductDetail.dart';
import 'package:provider/provider.dart';

class BannerProductScreen extends StatefulWidget {
  var title;
  List<DataInner> products;

  BannerProductScreen({this.title, this.products});

  @override
  _BannerProductScreenState createState() => _BannerProductScreenState();
}

class _BannerProductScreenState extends State<BannerProductScreen> {
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title ?? "Products"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.shoppingCart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => CartPage(
                              fromNavigationDrawer: false,
                            )));
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: <Widget>[
            ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return createCartListItem(widget.products[index]);
              },
              itemCount: widget.products.length ?? 0,
              controller: scrollController,
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
            (widget.products.length == 0)
                ? Center(
                    child:
                        getNoDataView(msg: "No Product found.", onRetry: null))
                : Container()
          ],
        ));
  }

  createCartListItem(DataInner productList) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ProductDetailPage(
                      productData: productList,
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
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
