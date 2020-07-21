import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/ui/admin/banner/AddBannerScreen.dart';
import 'package:ngmartflutter/ui/admin/brand/AddBrandScreen.dart';
import 'package:ngmartflutter/ui/admin/product/AddProductScreen.dart';
import 'package:ngmartflutter/ui/admin/product/ProductList.dart';
import 'package:ngmartflutter/ui/admin/quantity/AddQuantityScreen.dart';
import 'package:ngmartflutter/ui/admin/order/OrderScreen.dart';
import 'package:ngmartflutter/ui/admin/quantity/QuantiityScreen.dart';
import 'package:ngmartflutter/ui/drawer/drawer_item.dart';
import 'package:ngmartflutter/ui/login/login_screen.dart';
import 'package:ngmartflutter/ui/settings/setting.dart';

import '../CommingSoonScreen.dart';
import 'banner/BannerScreen.dart';
import 'brand/BrandScreen.dart';
import 'category/AddCategoryScreen.dart';
import 'category/CategoryScreen.dart';

class AdminNavigationDrawer extends StatefulWidget {
  _AdminNavigationDrawerState createState() => _AdminNavigationDrawerState();
}

class _AdminNavigationDrawerState extends State<AdminNavigationDrawer>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _selectionIndex = 0;
  bool _isLoggedIn = false;
  bool showAddIcon = true;
  var drawerItems = new List();
  LoginResponse userInfo;
  Widget _body;
  String _title = "Brands";
  DateTime currentBackPressTime;

  @override
  void initState() {
    _body = CommingSoonScreen();
    MemoryManagement.init();
    _isLoggedIn = MemoryManagement.getLoggedInStatus() ?? false;
    print("Logged In===> $_isLoggedIn");
    if (_isLoggedIn) {
      var infoData = jsonDecode(MemoryManagement.getUserInfo());
      userInfo = LoginResponse.fromJson(infoData);
    }
    drawerItems.add(DrawerItem("Brands", FontAwesomeIcons.meetup));
    drawerItems
        .add(DrawerItem("Quantity Units", FontAwesomeIcons.sortAmountUp));
    drawerItems.add(DrawerItem("Category", FontAwesomeIcons.bars));
    drawerItems.add(DrawerItem("Products", FontAwesomeIcons.th));
    drawerItems.add(DrawerItem("Banners", FontAwesomeIcons.history));
    drawerItems.add(DrawerItem("Orders", FontAwesomeIcons.firstOrder));
    drawerItems.add(DrawerItem("Settings", FontAwesomeIcons.cogs));
    drawerItems.add(DrawerItem("Log out", FontAwesomeIcons.signOutAlt));
    super.initState();
  }

  _onSelectItem(int index) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
    if (_isLoggedIn) {
      if (index == 0) {
        //show profile
        _pageController.jumpToPage(0);
        _title = "Brands";
        showAddIcon = true;
      } else if (index == 1) {
        //show profile
        _pageController.jumpToPage(1);
        _title = "Quantity Units";
        showAddIcon = true;
      } else if (index == 2) {
        //show cart
        _pageController.jumpToPage(2);
        _title = "Category";
        showAddIcon = true;
      } else if (index == 3) {
        //show purchi
        _title = "Product";
        _pageController.jumpToPage(3);
        showAddIcon = true;
      } else if (index == 4) {
        //show order history
        _title = "Banners";
        _pageController.jumpToPage(4);
        showAddIcon = true;
      } else if (index == 5) {
        //show setting
        _title = "Cms Pages";
        _pageController.jumpToPage(5);
        showAddIcon = true;
      } else if (index == 6) {
        //show setting
        _title = "Settings";
        _pageController.jumpToPage(6);
        showAddIcon = false;
      } else if (index == 7) {
        onLogoutSuccess(context: context);
        _pageController.jumpToPage(7);
      }
    }

    setState(() {
      _selectionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(
          d.title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
        selected: i == _selectionIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_title ?? "Brands"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: showAddIcon
                  ? IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        if (_pageController.page == 0) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddBrandScreen(
                                        fromBrandScreen: false,
                                        title: "",
                                        brandId: 1,
                                      )));
                        } else if (_pageController.page == 1) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddQuantityScreen(
                                        fromBrandScreen: false,
                                        title: "",
                                        brandId: 1,
                                      )));
                        } else if (_pageController.page == 2) {
                          bool isWOrkDone = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddCategoryScreen(
                                        fromCategoryScreen: false,
                                      )));
                          if (isWOrkDone != null && isWOrkDone) {
                            _pageController.jumpToPage(2);
                          }
                        } else if (_pageController.page == 3) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddProductScreen(
                                        fromProductScreen: false,
                                      )));
                        } else if (_pageController.page == 4) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddBannerScreen(
                                        fromProductScreen: false,
                                      )));
                        }
                      })
                  : Container())
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      if (!_isLoggedIn) {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => Login()));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _isLoggedIn
                              ? "${userInfo.data.user.firstName} ${userInfo.data.user.lastName}"
                              : "LogIn",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                accountEmail: Text(_isLoggedIn ? userInfo.data.user.email : ""),
                currentAccountPicture: _isLoggedIn
                    ? CircleAvatar(
                        child: Text(
                          userInfo.data.user.firstName[0] ?? "N",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      )
                    : Container(),
              ),
              Column(
                children: drawerOptions,
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageView(
            controller: _pageController,
            children: <Widget>[
              BrandScreen(),
              QuantityScreen(),
              CategoryScreen(),
              ProductScreen(),
              BannerScreen(),
              AdminOrdersScreen(),
              Setting(),
              CommingSoonScreen(),
            ],
            physics: NeverScrollableScrollPhysics()),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_pageController.page != 0) {
      _pageController.jumpToPage(0);
      _title = "Brands";
      setState(() {});
      return Future.value(false);
    } else if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      FlutterToast(context).showToast(
        child: toast,
        toastDuration: Duration(seconds: 1),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: AppColors.kPrimaryBlue,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning,
          color: Colors.white,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(
          "Press Back again to exit.",
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}
