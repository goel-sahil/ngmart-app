import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/ui/login/login_screen.dart';
import 'package:ngmartflutter/ui/search/SearchPage.dart';

import 'drawer_item.dart';
import 'HomeScreen.dart';

class NavigationDrawer extends StatefulWidget {
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer>
    with TickerProviderStateMixin {
  int _selectionIndex = 0;
  bool _isLoggedIn = false;
  var drawerItems = new List();
  LoginResponse userInfo;
  Widget _body;

  _onSelectItem(int index) {
    Navigator.pop(context);

    if (_isLoggedIn) {
      if (index == 0) {
        _body = HomeScreen();
      } else if (index == 1) {
        //show profile
      } else if (index == 2) {
        //show cart
      } else if (index == 3) {
        //show purchi
      } else if (index == 4) {
        //show setting
      } else if (index == 5) {
        //show contact us
      } else if (index == 6) {
        //show share
      } else if (index == 7) {
        onLogoutSuccess(context: context);
      }
    } else {
      if (index == 0) {
        _body = HomeScreen();
      } else if (index == 1) {
        //Show Settings
      } else if (index == 2) {
        // Contact us
      } else if (index == 3) {
        //share with friend
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
      drawerItems
          .add(DrawerItem("Buy with Parchi", FontAwesomeIcons.buysellads));
    }
    drawerItems.add(DrawerItem("Settings", FontAwesomeIcons.cogs));
//    drawerItems.add(DrawerItem("About us", FontAwesomeIcons.userAlt));
//    drawerItems.add(DrawerItem("Terms & policy", FontAwesomeIcons.terminal));
    drawerItems.add(DrawerItem("Contact us", FontAwesomeIcons.searchLocation));
//    drawerItems.add(DrawerItem("Review us", FontAwesomeIcons.snapchat));
    drawerItems
        .add(DrawerItem("Share with friends", FontAwesomeIcons.shareAlt));
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
        title: Text("NGMart"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => SearchPage()));
                }),
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
      body: _body,
    );
  }
}
