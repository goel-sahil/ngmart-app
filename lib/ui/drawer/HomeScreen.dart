import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/styles.dart';
import 'package:ngmartflutter/model/categories_response.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/drawer/SubCategoryScreen.dart';
import 'package:ngmartflutter/ui/productList/ProductList.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Container> listData = new List();
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Data> categoryList = new List();

  Widget prepareList(int k, Data categoryList) {
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
            getNetworkImage(
                url: categoryList.imageUrl ??
                    "https://www.festivalclaca.cat/imgfv/m/248-2486181_red-kashmir-apple-png-free-download-apple-fruit.png"),
            getSpacer(height: 10),
            Container(
              color: Colors.black26,
              width: double.infinity,
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
                      _getCarousel(enlargeCenterPage: true),
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
                            onPressed: () {},
                            color: AppColors.kPrimaryBlue,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(4.0))),
                      ),
                      getSpacer(height: 10),
                      sectionHeader("Shop by Category"),
                      getSpacer(height: 10),
                      GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        // to disable GridView's scrolling
                        itemBuilder: (ctx, index) {
                          return prepareList(index, categoryList[index]);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: getScreenSize(context: context)
                                  .width /
                              (getScreenSize(context: context).height / 1.5),
                        ),
                        itemCount: categoryList.length,
                      ),
                      getSpacer(height: 10),
                      Divider(),
                      _getCarousel(enlargeCenterPage: false),
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
    placeholder: NetworkImage(url),
    // size: 1.87KB
    thumbnail: NetworkImage(url),
    // size: 1.29MB
    image: NetworkImage(url),
    height: height,
    width: width,
    fit: BoxFit.contain,
  );
}

Widget _getCarousel({bool enlargeCenterPage = false}) {
  return CarouselSlider.builder(
      itemCount: 15,
      itemBuilder: (BuildContext context, int itemIndex) => Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(color: Colors.white),
          child: Image.network(
            "https://img.freepik.com/free-vector/local-business-marketing-banner-template_107791-2219.jpg?size=626&ext=jpg&uid=A",
            fit: BoxFit.fill,
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
