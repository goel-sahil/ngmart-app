import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/helper/styles.dart';
import 'package:ngmartflutter/model/categories_response.dart';
import 'package:ngmartflutter/ui/cart/CartPage.dart';
import 'package:ngmartflutter/ui/login/login_screen.dart';
import 'package:ngmartflutter/ui/productList/ProductList.dart';
import 'HomeScreen.dart';

class SubCategoryScreen extends StatefulWidget {
  List<Categories> categories;
  var catName;

  SubCategoryScreen({this.categories, this.catName});

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  var _userLoggedIn = false;

  @override
  void initState() {
    MemoryManagement.init();
    _userLoggedIn = MemoryManagement.getLoggedInStatus() ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.catName ?? "SubCategory"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.shoppingCart,
                  color: Colors.white,
                ),
                onPressed: () {
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
                },
              ),
            ],
          ),
          body: _buildGridItem(),
        ),
      ),
    );
  }

  Widget _buildGridItem() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      // to disable GridView's scrolling
      itemBuilder: (ctx, index) {
        return prepareList(index, widget.categories[index]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: getScreenSize(context: context).width /
            (getScreenSize(context: context).height / 1.5),
      ),
      itemCount: widget.categories.length,
    );
  }

  Widget prepareList(int k, Categories categories) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ProductScreen(
                        id: categories.id,
                        title: categories.title,
                      )));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            getNetworkImage(
                url: categories.imageUrl ??
                    "https://www.festivalclaca.cat/imgfv/m/248-2486181_red-kashmir-apple-png-free-download-apple-fruit.png"),
            getSpacer(height: 10),
            Container(
              color: Colors.black26,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                categories.title ?? "",
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
}
