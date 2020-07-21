import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/ui/cart/CartPage.dart';
import 'package:ngmartflutter/ui/contactUs/Contact_us.dart';
import 'package:ngmartflutter/ui/login/login_screen.dart';
import 'package:ngmartflutter/ui/orderByParchi/OrderByParchiScreen.dart';
import 'package:ngmartflutter/ui/orderHistory/OrderHistory.dart';
import 'package:ngmartflutter/ui/profile/ProfileScreen.dart';
import 'package:ngmartflutter/ui/search/SearchPage.dart';
import 'package:ngmartflutter/ui/settings/setting.dart';
import 'package:share/share.dart';

import 'drawer_item.dart';
import 'HomeScreen.dart';

class NavigationDrawer extends StatefulWidget {
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _selectionIndex = 0;
  bool _isLoggedIn = false;
  bool showSearch = true;
  var drawerItems = new List();
  LoginResponse userInfo;
  Widget _body;
  String _title = "NGMart";
  DateTime currentBackPressTime;

  _onSelectItem(int index) {
    Navigator.pop(context);
    if (_isLoggedIn) {
      if (index == 0) {
        _title = "NGMart";
        _pageController.jumpToPage(0);
        showSearch = true;
      } else if (index == 1) {
        //show profile
        _pageController.jumpToPage(1);
        _title = "My Profile";
        showSearch = false;
      } else if (index == 2) {
        //show cart
        _pageController.jumpToPage(2);
        _title = "My Cart";
        showSearch = false;
      } else if (index == 3) {
        //show purchi
        _title = "Order by Parchi";
        _pageController.jumpToPage(3);
        showSearch = false;
      } else if (index == 4) {
        //show order history
        _title = "Order History";
        _pageController.jumpToPage(4);
        showSearch = false;
      } else if (index == 5) {
        //show setting
        _title = "Settings";
        _pageController.jumpToPage(5);
        showSearch = false;
      } else if (index == 6) {
        //show contact us
        _title = "Contact us";
        _pageController.jumpToPage(6);
        showSearch = false;
      } else if (index == 7) {
        onLogoutSuccess(context: context);
        _pageController.jumpToPage(7);
      }
    } else {
      if (index == 0) {
        _pageController.jumpToPage(0);
        _title = "NGMart";
        showSearch = true;
      } else if (index == 1) {
        //Show parchi screen
        _title = "Order by Parchi";
        _pageController.jumpToPage(3);
        showSearch = false;
      } else if (index == 2) {
        //Show Settings
        _title = "Settings";
        _pageController.jumpToPage(5);
        showSearch = false;
      } else if (index == 3) {
        // Contact us
        _title = "Contact us";
        _pageController.jumpToPage(6);
        showSearch = false;
      }
    }

    setState(() {
      _selectionIndex = index;
    });
  }

  @override
  void initState() {
    _body = HomeScreen();
    MemoryManagement.init();
    _isLoggedIn = MemoryManagement.getLoggedInStatus() ?? false;
    print("Logged In===> $_isLoggedIn");
    if (_isLoggedIn) {
      var infoData = jsonDecode(MemoryManagement.getUserInfo());
      userInfo = LoginResponse.fromJson(infoData);
    }
    drawerItems.add(DrawerItem("Shop Now", FontAwesomeIcons.cartPlus));
    if (_isLoggedIn) {
      drawerItems.add(DrawerItem("My Profile", FontAwesomeIcons.userCircle));
      drawerItems.add(DrawerItem("My Cart", FontAwesomeIcons.shoppingCart));
    }
    drawerItems
        .add(DrawerItem("Order by Parchi", FontAwesomeIcons.luggageCart));
    if (_isLoggedIn) {
      drawerItems.add(DrawerItem("Order History", FontAwesomeIcons.history));
    }
    drawerItems.add(DrawerItem("Settings", FontAwesomeIcons.cogs));
    drawerItems.add(DrawerItem("Contact us", FontAwesomeIcons.mailBulk));
    if (_isLoggedIn) {
      drawerItems.add(DrawerItem("Log out", FontAwesomeIcons.signOutAlt));
    }
    super.initState();
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
        title: Text(_title ?? "NGMart"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: showSearch
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SearchPage()));
                    })
                : Container(),
          )
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
              HomeScreen(),
              ProfileScreen(fromAdmin: false,),
              CartPage(
                fromNavigationDrawer: true,
              ),
              OrderByParchiScreen(
                fromNavigation: true,
              ),
              OrderHistory(),
              Setting(),
              ContactUs(),
            ],
            physics: NeverScrollableScrollPhysics()),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_pageController.page != 0) {
      _setSelectedZero();
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

  _setSelectedZero(){
    _title = "NGMart";
    _pageController.jumpToPage(0);
    showSearch = true;
    setState(() {
      _selectionIndex = 0;
    });
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
