import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/product_response.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/productDetail/ProductDetail.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> listCategory = new List();
  List<String> listShoesImage = new List();
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = new TextEditingController();
  int _currentPageNumber = 1;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _loadMore = false;
  ScrollController scrollController = new ScrollController();
  List<DataInner> searchProductList = new List();

  @override
  void initState() {
    _setScrollListener();
    super.initState();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _setScrollListener() {
    scrollController = new ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (searchProductList.length >=
                (PAGINATION_SIZE * _currentPageNumber) &&
            _loadMore) {
          _hitApi(_searchController.text);
          showInSnackBar("Loading data...");
        }
      }
    });
  }

  Future<void> _hitApi(String txt) async {
    provider.setLoading();
    if (_loadMore) {
      _currentPageNumber++;
    } else {
      _currentPageNumber = 1;
    }
    var response =
        await provider.getSearchedProducts(context, txt, _currentPageNumber);
    if (response is APIError) {
      searchProductList.clear();
      showInSnackBar(response.error);
    } else if (response is ProductResponse) {
      if (_currentPageNumber == 1) {
        searchProductList.clear();
      }
      searchProductList.addAll(response.data.dataInner);
      if (response.data.dataInner.length < PAGINATION_SIZE) {
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
      backgroundColor: Colors.grey.shade50,
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          searchHeader(),
          horizontalDivider(),
          getSpacer(height: 14),
          recentSearchListView(),
        ],
      ),
    );
  }

  searchHeader() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.grey.shade700,
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: (val) {
                  _loadMore=false;
                  _hitApi(val);
                },
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: "Search for products",
                    hintStyle: CustomTextStyle.textFormFieldRegular
                        .copyWith(color: Colors.grey, fontSize: 12),
                    labelStyle: CustomTextStyle.textFormFieldRegular
                        .copyWith(color: Colors.black, fontSize: 12),
                    border: textFieldBorder(),
                    suffixIcon: Container(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          provider.getLoading()
                              ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator())
                              : Container(),
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey.shade700,
                            ),
                            onPressed: () {
                              _currentPageNumber = 1;
                              _searchController.clear();
                              searchProductList.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                    enabledBorder: textFieldBorder(),
                    focusedBorder: textFieldBorder()),
              ),
            )
          ],
        ));
  }

  OutlineInputBorder textFieldBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(color: Colors.transparent));

  horizontalDivider() {
    return Container(
      color: Colors.grey.shade200,
      height: 1,
      width: double.infinity,
    );
  }

  recentSearchListView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "PRODUCT SEARCHES",
                  style: CustomTextStyle.textFormFieldBold.copyWith(
                      color: Colors.black.withOpacity(.5), fontSize: 11),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          getSpacer(height: 6),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: getScreenSize(context: context).height - 60),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return createCartListItem(searchProductList[index]);
              },
              itemCount: searchProductList.length,
              primary: false,
              controller: scrollController,
              scrollDirection: Axis.vertical,
            ),
          )
        ],
      ),
    );
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

  recentSearchListViewItem(String listShoesImage, int index) {
    double leftMargin = 8;
    double rightMargin = 8;
    if (index == 0) {
      leftMargin = 16;
    }
    if (index == this.listShoesImage.length - 1) {
      rightMargin = 16;
    }
    return Container(
      margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
      child: Column(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(listShoesImage), fit: BoxFit.cover),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                shape: BoxShape.circle),
          ),
          getSpacer(height: 4),
          Text(
            "Search Item",
            overflow: TextOverflow.ellipsis,
            textWidthBasis: TextWidthBasis.parent,
            softWrap: true,
            textAlign: TextAlign.center,
            style: CustomTextStyle.textFormFieldRegular
                .copyWith(fontSize: 10, color: Colors.black),
          )
        ],
      ),
    );
  }

  wishListItemListView() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              "ITEMS YOU HAVE WISHLISTED",
              style: CustomTextStyle.textFormFieldBold
                  .copyWith(color: Colors.black.withOpacity(.5), fontSize: 11),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return createWishListItem();
                },
                itemCount: 10,
                primary: false,
                scrollDirection: Axis.horizontal,
              ),
            ),
          )
        ],
      ),
    );
  }

  createWishListItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: Colors.teal.shade200,
                image: DecorationImage(
                    image: AssetImage("images/shoes_1.png"), fit: BoxFit.cover),
              ),
            ),
            flex: 70,
          ),
          getSpacer(height: 6),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "HIGHLANDER",
              style: CustomTextStyle.textFormFieldRegular
                  .copyWith(color: Colors.black.withOpacity(0.7), fontSize: 12),
            ),
          ),
          getSpacer(height: 6),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "\$12",
              style: CustomTextStyle.textFormFieldBold
                  .copyWith(color: Colors.black, fontSize: 12),
            ),
          ),
          getSpacer(height: 6),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: <Widget>[
                Text(
                  "\$15",
                  style: CustomTextStyle.textFormFieldRegular.copyWith(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough),
                ),
                getSpacer(width: 4),
                Text(
                  "55% OFF",
                  style: CustomTextStyle.textFormFieldRegular
                      .copyWith(color: Colors.red.shade400, fontSize: 12),
                ),
              ],
            ),
          ),
          getSpacer(height: 6),
        ],
      ),
    );
  }

/*
  viewedItemListView() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              "ITEMS YOU HAVE VIEWED",
              style: CustomTextStyle.textFormFieldBold
                  .copyWith(color: Colors.black.withOpacity(.5), fontSize: 11),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return createWishListItem();
                },
                itemCount: 10,
                primary: false,
                scrollDirection: Axis.horizontal,
              ),
            ),
          )
        ],
      ),
    );
  }
*/

}
