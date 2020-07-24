import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/AssetStrings.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/styles.dart';
import 'package:ngmartflutter/model/bannerResponse/bannerResponse.dart';
import 'package:ngmartflutter/model/categories_response.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/drawer/SubCategoryScreen.dart';
import 'package:ngmartflutter/ui/orderByParchi/OrderByParchiScreen.dart';
import 'package:ngmartflutter/ui/productList/BannerProductList.dart';
import 'package:ngmartflutter/ui/productList/ProductList.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  List<Container> listData = new List();
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CategoryData> categoryList = new List();
  List<DataBanner> bannerList = new List();

  Widget prepareList(int k, CategoryData categoryList) {
    return Card(
      child: InkWell(
        onTap: () {
          if (categoryList.categories.length > 0) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => SubCategoryScreen(
                          categories: categoryList.categories,
                          catName: categoryList.title,
                        )));
          } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ProductScreen(
                          id: categoryList.id,
                          title: categoryList.title,
                        )));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            getSpacer(height: 20),
            getCachedNetworkImage(
                url: categoryList.imageUrl, height: 100, width: 100),
            getSpacer(height: 10),
            Container(
              color: Colors.black26,
              width: getScreenSize(context: context).width,
              alignment: Alignment.center,
              child: Text(
                categoryList.title ?? "",
                style: h7,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    Timer(Duration(milliseconds: 500), () {
      _hitApi();
      _hitBannerApi();
    });
    super.initState();
  }

  Future<void> _hitApi() async {
    provider.setLoading();
    var response = await provider.getCategories(context);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is CategoriesResponse) {
      categoryList.addAll(response.data);
    }
  }

  Future<void> _hitBannerApi() async {
    provider.setLoading();
    var response = await provider.getBanners(context);
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
    } else if (response is BannerResponse) {
      bannerList?.clear();
      bannerList.addAll(response.data.dataInner);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    return SafeArea(
      child: Material(
        child: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Consumer<DashboardProvider>(
                  builder: (BuildContext context, DashboardProvider value,
                          Widget child) =>
                      Column(
                    children: <Widget>[
                      (bannerList.isNotEmpty && !provider.getLoading())
                          ? _getCarousel(enlargeCenterPage: true)
                          : SizedBox(
                              height: 30,
                              width: getScreenSize(context: context).width,
                            ),
                      getSpacer(height: 20),
                      Container(
                        width: getScreenSize(context: context).width - 30,
                        child: new FlatButton(
                            child: new Text(
                              "Order By Parchi",
                              style: TextStyle(
                                  color: AppColors.kWhite,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => OrderByParchiScreen(
                                            fromNavigation: false,
                                          )));
                            },
                            color: AppColors.kPrimaryBlue,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(4.0))),
                      ),
                      getSpacer(height: 10),
                      sectionHeader("Shop by Category"),
                      getSpacer(height: 10),
                      new StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: categoryList.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) =>
                            prepareList(index, categoryList[index]),
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(2, 2),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      getSpacer(height: 10),
                      Divider(),
                      (bannerList.isNotEmpty && !provider.getLoading())
                          ? _getCarousel(enlargeCenterPage: true)
                          : SizedBox(
                              height: 30,
                              width: getScreenSize(context: context).width,
                            ),
                      getSpacer(height: 10),
                    ],
                  ),
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
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget _getCarousel({bool enlargeCenterPage = false}) {
    return CarouselSlider.builder(
        itemCount: bannerList.length ?? 0,
        itemBuilder: (BuildContext context, int itemIndex) => Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(color: Colors.white),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => BannerProductScreen(
                              title: bannerList[itemIndex].title,
                              products: bannerList[itemIndex].products,
                            )));
              },
              child: getNetworkImage(
                  url: bannerList[itemIndex].imageUrl,
                  height: 170,
                  width: getScreenSize(context: context).width),
            )),
        options: CarouselOptions(
          height: 170,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 2),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: enlargeCenterPage,
          scrollDirection: Axis.horizontal,
        ));
  }
}

Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(headerTitle, style: h4),
      ),
    ],
  );
}

Widget getNetworkImage(
    {@required String url,
    BoxFit fit,
    double width = 100,
    double height = 100}) {
  return ProgressiveImage(
    placeholder: AssetImage(AssetStrings.placeHolder),
    // size: 1.87KB
    thumbnail: NetworkImage(url),
    // size: 1.29MB
    image: NetworkImage(url),
    height: height,
    width: width,
    fit: BoxFit.fill,
  );
}
